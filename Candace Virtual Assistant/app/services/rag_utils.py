# app/services/rag_utils.py
import os, json, faiss, numpy as np
from dataclasses import dataclass
from typing import List, Iterable, Tuple
from sentence_transformers import SentenceTransformer
from pypdf import PdfReader

EMBED_MODEL_ID = os.getenv("CANDACE_EMBED_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
INDEX_DIR = os.getenv("CANDACE_INDEX_DIR", None)
CHUNK_SIZE = 800
CHUNK_OVERLAP = 120
TOP_K = 4

_sbert = None
_faiss = None
_meta = []

def _sliding_window(text: str, size: int, overlap: int) -> Iterable[str]:
    i, n = 0, len(text)
    while i < n:
        yield text[i:i+size]
        i += max(1, size - overlap)

def _flatten_json(obj):
    out = []
    def _walk(x):
        if isinstance(x, dict):
            for v in x.values(): _walk(v)
        elif isinstance(x, list):
            for v in x: _walk(v)
        elif isinstance(x, str):
            s = x.strip()
            if s: out.append(s)
    _walk(obj)
    return "\n".join(out)

def _read_text_from_path(path: str) -> str:
    path = str(path)
    low = path.lower()
    if low.endswith(".pdf"):
        try:
            reader = PdfReader(path)
            return "\n".join((page.extract_text() or "") for page in reader.pages)
        except Exception:
            return ""
    if low.endswith((".txt", ".md")):
        try:
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                return f.read()
        except Exception:
            return ""
    if low.endswith(".json"):
        try:
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                data = json.load(f)
            return _flatten_json(data)
        except Exception:
            return ""
    return ""

def _collect_paths(target: str) -> List[str]:
    """Accept a file or directory; return supported files."""
    if os.path.isfile(target):
        low = target.lower()
        return [target] if low.endswith((".pdf", ".txt", ".md", ".json")) else []
    found = []
    for dirpath, _, filenames in os.walk(target):
        for fn in filenames:
            low = fn.lower()
            if low.endswith((".pdf", ".txt", ".md", ".json")):
                found.append(os.path.join(dirpath, fn))
    return found

def _load_embedder():
    global _sbert
    if _sbert is None:
        _sbert = SentenceTransformer(EMBED_MODEL_ID)
    return _sbert

def _ensure_dirs(dirpath: str):
    os.makedirs(dirpath, exist_ok=True)
    os.makedirs(os.path.join(dirpath, "store"), exist_ok=True)

@dataclass
class RAGConfig:
    index_dir: str
    top_k: int = TOP_K

def init(app_root: str, index_dir: str | None = None) -> RAGConfig:
    global INDEX_DIR
    INDEX_DIR = index_dir or os.path.join(app_root, "vectorstore")
    _ensure_dirs(INDEX_DIR)
    return RAGConfig(index_dir=INDEX_DIR, top_k=TOP_K)

def ingest_folder(target: str, index_dir: str | None = None) -> Tuple[int, int]:
    """Build (or rebuild) FAISS index from a folder OR a single file."""
    global _faiss, _meta
    idx_dir = index_dir or INDEX_DIR
    _ensure_dirs(idx_dir)

    targets = _collect_paths(target)
    print(f"[INGEST] Target: {target}")
    print(f"[INGEST] Found {len(targets)} candidate files:")
    for p in targets:
        print("  -", p)

    if not targets:
        raise RuntimeError(f"No supported docs found under: {target}")

    docs, chunks, meta = [], [], []
    for p in targets:
        txt = _read_text_from_path(p)
        if not txt.strip():
            print(f"[WARN] No text extracted from: {p}")
            continue
        docs.append(p)
        for j, chunk in enumerate(_sliding_window(txt, CHUNK_SIZE, CHUNK_OVERLAP)):
            c = chunk.strip()
            if not c: continue
            chunks.append(c)
            meta.append({"path": p, "chunk": c, "id": f"{len(docs)-1}:{j}"})

    if not chunks:
        raise RuntimeError("No text extracted; check your files.")

    sbert = _load_embedder()
    embs = sbert.encode(chunks, convert_to_numpy=True, show_progress_bar=True, normalize_embeddings=True)
    dim = embs.shape[1]

    index = faiss.IndexFlatIP(dim)
    index.add(embs)

    faiss.write_index(index, os.path.join(idx_dir, "store", "candace.faiss"))
    with open(os.path.join(idx_dir, "store", "meta.json"), "w", encoding="utf-8") as f:
        json.dump(meta, f)

    _faiss, _meta = index, meta
    return len(docs), len(chunks)

def _lazy_load_index():
    global _faiss, _meta
    if _faiss is not None and _meta:
        return
    idx_path = os.path.join(INDEX_DIR, "store", "candace.faiss")
    meta_path = os.path.join(INDEX_DIR, "store", "meta.json")
    if not (os.path.exists(idx_path) and os.path.exists(meta_path)):
        _faiss, _meta = None, []
        return
    _faiss = faiss.read_index(idx_path)
    with open(meta_path, "r", encoding="utf-8") as f:
        _meta = json.load(f)

def retrieve(query: str, k: int | None = None) -> List[dict]:
    _lazy_load_index()
    if _faiss is None or not _meta:
        return []
    sbert = _load_embedder()
    q = sbert.encode([query], convert_to_numpy=True, normalize_embeddings=True)
    D, I = _faiss.search(q, k or TOP_K)
    hits = []
    for score, idx in zip(D[0].tolist(), I[0].tolist()):
        if idx == -1: continue
        m = _meta[idx]
        hits.append({"path": m["path"], "chunk": m["chunk"], "score": float(score)})
    return hits

def format_context(hits: List[dict]) -> str:
    if not hits: return ""
    lines = []
    for h in hits:
        lines.append(f"[Source: {os.path.basename(h['path'])}]\n{h['chunk']}")
    return "\n\n".join(lines)
