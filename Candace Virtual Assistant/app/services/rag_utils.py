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
        yield text[i:i + size]
        i += max(1, size - overlap)


def _flatten_json(obj):
    out = []

    def _walk(x):
        if isinstance(x, dict):
            for v in x.values():
                _walk(v)
        elif isinstance(x, list):
            for v in x:
                _walk(v)
        elif isinstance(x, str):
            s = x.strip()
            if s:
                out.append(s)

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
    """
    Lazily load the sentence embedding model.  When a CUDA-capable GPU is
    available and PyTorch has been installed with CUDA support, offload
    embeddings to the GPU to accelerate inference.  This behavior can be
    disabled by setting the environment variable CANDACE_EMBED_DEVICE to
    'cpu'.  If CANDACE_EMBED_DEVICE is set to 'cuda' the embedder will be
    forced onto the GPU regardless of autodetection.
    """
    global _sbert
    if _sbert is None:
        # Determine device: use explicit env override if provided, otherwise
        # automatically choose CUDA when available.
        device_override = os.getenv("CANDACE_EMBED_DEVICE", None)
        device = None
        if device_override:
            # Accept values like 'cpu' or 'cuda'
            device = device_override.strip().lower()
        else:
            try:
                import torch
                if torch.cuda.is_available():
                    device = "cuda"
                else:
                    device = "cpu"
            except Exception:
                device = "cpu"
        try:
            _sbert = SentenceTransformer(EMBED_MODEL_ID, device=device)
        except Exception:
            # Fallback to default loading semantics if specifying device fails
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
            if not c:
                continue
            chunks.append(c)
            meta.append({"path": p, "chunk": c, "id": f"{len(docs) - 1}:{j}"})

    if not chunks:
        raise RuntimeError("No text extracted; check your files.")

    sbert = _load_embedder()
    embs = sbert.encode(
        chunks,
        convert_to_numpy=True,
        show_progress_bar=True,
        normalize_embeddings=True,
    )
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

def estimate_tokens(text: str) -> int:
    """Rough token estimator so we can control context length."""
    if not text:
        return 0
    # Simple heuristic: 1 token ≈ 4 chars
    return max(1, len(text) // 4)


def choose_top_k(query: str) -> int:
    """Choose how many RAG chunks to retrieve based on question type."""
    q = query.lower()

    if any(w in q for w in ["list", "all assignments", "everything", "every assignment"]):
        return 6      # big list-style question → more sources

    if any(w in q for w in ["assignment", "due", "grade"]):
        return 4      # course-specific

    return 3          # simple question

def budget_hits(student_context: str, hits: list[dict], max_tokens: int) -> list[dict]:
    """
    Keep only as many vector hits as will fit into the token budget.
    """
    used = estimate_tokens(student_context)
    out = []

    for h in hits:
        chunk_tokens = estimate_tokens(h["chunk"])
        if used + chunk_tokens > max_tokens:
            break
        out.append(h)
        used += chunk_tokens

    return out

def build_trimmed_context(student_context: str, query: str, max_total_tokens: int) -> str:
    """
    Combine student context + RAG hits under a token budget.
    """
    print(
        f"[RAG] build_trimmed_context: max_total_tokens={max_total_tokens}, "
        f"query={query!r}, student_tokens≈{estimate_tokens(student_context)}"
    )

    k = choose_top_k(query)
    hits = retrieve(query, k=k)

    allowed = budget_hits(
        student_context=student_context,
        hits=hits,
        max_tokens=max_total_tokens,
    )

    print(
        f"[RAG] allowed_hits={len(allowed)} / {len(hits)} possible, "
        f"total_tokens≈{estimate_tokens(student_context) + sum(estimate_tokens(h['chunk']) for h in allowed)}"
    )

    parts = [student_context]
    for h in allowed:
        parts.append(f"[Source: {os.path.basename(h['path'])}]\n{h['chunk']}")

    return "\n\n".join(parts).strip()

def retrieve(query: str, k: int | None = None) -> list[dict]:
    _lazy_load_index()

    if _faiss is None or not _meta:
        return []

    # dynamic K selection if not given
    if k is None:
        k = choose_top_k(query)

    sbert = _load_embedder()
    q = sbert.encode([query], convert_to_numpy=True, normalize_embeddings=True)
    D, I = _faiss.search(q, k)

    hits = []
    for score, idx in zip(D[0].tolist(), I[0].tolist()):
        if idx == -1:
            continue
        m = _meta[idx]
        hits.append({
            "path": m["path"],
            "chunk": m["chunk"],
            "score": float(score),
        })

    return hits

def format_context(hits: List[dict]) -> str:
    if not hits:
        return ""
    lines = []
    for h in hits:
        lines.append(f"[Source: {os.path.basename(h['path'])}]\n{h['chunk']}")
    return "\n\n".join(lines)
