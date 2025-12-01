"""
Run this script once (or whenever your documents update)
to build Candace's RAG vector index.

Usage:
    python ingest_rag.py "C:/path/to/YourCourseDocs"

If no path is given, defaults to ./docs under the project root.
"""

import os
from app.services import rag_utils

# --- CONFIGURATION ---
# 1. Application root (where the 'app' folder is located)
APP_ROOT = os.path.dirname(os.path.abspath(__file__))

# 2. Point to your existing 'docs/' folder.
PUBLIC_DOCS_PATH = os.path.join(APP_ROOT, "docs") # <-- CHANGE HERE

# --- SCRIPT DE INGESTA ---
if __name__ == "__main__":
    print("--- Ingesting documents for RAG with ChromaDB ---")

    # Initialize RAG configuration
    rag_utils.init(app_root=APP_ROOT)
    
    if not os.path.isdir(PUBLIC_DOCS_PATH):
        print(f"[ERROR] Document folder does not exist: {PUBLIC_DOCS_PATH}")
    else:
        try:
            print(f"Searching for documents in: {PUBLIC_DOCS_PATH}")
            doc_count, chunk_count = rag_utils.ingest_folder(PUBLIC_DOCS_PATH)
            print(f"\n[SUCCESS] Ingest completed.")
            print(f"Processed {doc_count} documents and created {chunk_count} public chunks.")

        except Exception as e:
            print(f"\n[ERROR] Error: {e}")

## run this cript on terminal: python ingest_rag.py "C:/path/to/YourCourseDocs"
## python ingest_rag.py "C:\Users\emilio.vasquez\Documents\UG-Research\Candace-Virtual-Assistant\Candace Virtual Assistant\docs\docs_formatted"
