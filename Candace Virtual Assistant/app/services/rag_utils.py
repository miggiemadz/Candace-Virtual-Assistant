# app/services/rag_utils.py
import os
import chromadb
from dataclasses import dataclass
from typing import List, Iterable, Tuple, Optional
from sentence_transformers import SentenceTransformer
from pypdf import PdfReader

# --- Constants ---
EMBED_MODEL_ID = os.getenv("CANDACE_EMBED_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
CHROMA_DIR = os.getenv("CANDACE_CHROMA_DIR", None)
COLLECTION_NAME = "candace_docs"
CHUNK_SIZE = 800
CHUNK_OVERLAP = 120
TOP_K = 4

# --- Globals ---
_sbert = None
_chroma_client = None

# --- Text Processing Utilities (unchanged) ---
def _sliding_window(text: str, size: int, overlap: int) -> Iterable[str]:
    i, n = 0, len(text)
    while i < n:
        yield text[i:i + size]
        i += max(1, size - overlap)

def _read_text_from_path(path: str) -> str:
    path = str(path)
    low = path.lower()
    if low.endswith(".pdf"):
        try:
            reader = PdfReader(path)
            return "\n".join((page.extract_text() or "") for page in reader.pages)
        except Exception: return ""
    if low.endswith((".txt", ".md", ".json")):
        try:
            with open(path, "r", encoding="utf-8", errors="ignore") as f: return f.read()
        except Exception: return ""
    return ""

def _collect_paths(target: str) -> List[str]:
    if os.path.isfile(target):
        low = target.lower()
        return [target] if low.endswith((".pdf", ".txt", ".md", ".json")) else []
    found = []
    for dirpath, _, filenames in os.walk(target):
        for fn in filenames:
            if fn.lower().endswith((".pdf", ".txt", ".md", ".json")):
                found.append(os.path.join(dirpath, fn))
    return found

# --- Model and Client Loading ---
def _load_embedder():
    global _sbert
    if _sbert is None:
        _sbert = SentenceTransformer(EMBED_MODEL_ID)
    return _sbert

def _get_chroma_client():
    global _chroma_client
    if _chroma_client is None:
        if not CHROMA_DIR:
            raise ValueError("CHROMA_DIR is not configured in init()")
        _chroma_client = chromadb.PersistentClient(path=CHROMA_DIR)
    return _chroma_client

# --- Public API ---
@dataclass
class RAGConfig:
    chroma_dir: str
    top_k: int = TOP_K

def init(app_root: str, chroma_dir: str | None = None) -> RAGConfig:
    global CHROMA_DIR
    CHROMA_DIR = chroma_dir or os.path.join(app_root, "chroma_db")
    os.makedirs(CHROMA_DIR, exist_ok=True)
    return RAGConfig(chroma_dir=CHROMA_DIR, top_k=TOP_K)

def ingest_folder(target: str, owner_id: str = "public") -> Tuple[int, int]:
    """Build or update ChromaDB collection with documents from a folder.

    Args:
        target: Path to a folder or a single file.
        owner_id: The ID of the user owning these documents. Defaults to 'public'.
    """
    client = _get_chroma_client()
    collection = client.get_or_create_collection(name=COLLECTION_NAME)
    sbert = _load_embedder()

    targets = _collect_paths(target)
    if not targets:
        raise RuntimeError(f"No supported docs found under: {target}")

    chunks, metadatas, ids = [], [], []
    doc_count = 0
    for path in targets:
        text = _read_text_from_path(path)
        if not text.strip():
            print(f"[WARN] No text extracted from: {path}")
            continue
        doc_count += 1
        for i, chunk_text in enumerate(_sliding_window(text, CHUNK_SIZE, CHUNK_OVERLAP)):
            if not chunk_text.strip(): continue
            chunks.append(chunk_text)
            metadatas.append({"source": os.path.basename(path), "owner_id": owner_id})
            ids.append(f"{owner_id}_{os.path.basename(path)}_{i}")

    if not chunks:
        raise RuntimeError("No text extracted; check your files.")

    collection.add(documents=chunks, metadatas=metadatas, ids=ids)
    print(f"[INGEST] Added {len(chunks)} chunks from {doc_count} documents for owner '{owner_id}'.")
    return doc_count, len(chunks)

def retrieve(query: str, student_id: Optional[str], k: int | None = None) -> List[dict]:
    """Retrieve relevant documents, filtering by user and public access.

    Args:
        query: The user's question.
        student_id: The ID of the student asking the question.
        k: Number of results to return.

    Returns:
        A list of document chunks with metadata.
    """
    try:
        client = _get_chroma_client()
        collection = client.get_or_create_collection(name=COLLECTION_NAME)
    except ValueError:
        print("[WARN] RAG collection does not exist. Run ingestion first.")
        return []

    # Define the filter: documents must be public OR owned by the current student
    where_filter = {"owner_id": "public"}
    if student_id:
        where_filter = {
            "$or": [
                {"owner_id": "public"},
                {"owner_id": str(student_id)}
            ]
        }

    results = collection.query(
        query_texts=[query],
        n_results=k or TOP_K,
        where=where_filter
    )

    hits = []
    if not results or not results.get("documents"):
        return []

    for doc, meta, dist in zip(results["documents"][0], results["metadatas"][0], results["distances"][0]):
        hits.append({
            "path": meta.get("source", "unknown"),
            "chunk": doc,
            "score": 1 - dist # Convert distance to similarity score
        })
    return hits

def format_context(hits: List[dict]) -> str:
    if not hits: return ""
    lines = []
    for h in hits:
        lines.append(f"[Source: {h['path']}]\n{h['chunk']}")
    return "\n".join(lines)

