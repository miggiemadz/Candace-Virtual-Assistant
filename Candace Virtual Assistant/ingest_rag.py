"""
Run this script once (or whenever your documents update)
to build Candace's RAG vector index.

Usage:
    python ingest_rag.py "C:/path/to/YourCourseDocs"

If no path is given, defaults to ./docs under the project root.
"""

import sys, os
from app import create_app
from app.services import rag_utils

def main():
    target = sys.argv[1] if len(sys.argv) > 1 else "docs"
    target = os.path.abspath(target)

    app = create_app()
    with app.app_context():
        try:
            docs, chunks = rag_utils.ingest_folder(target)
            print(f"[SUCCESS] Indexed {docs} files, {chunks} chunks from: {target}")
            print(f"[INFO] Index stored under: {rag_utils.INDEX_DIR}")
        except Exception as e:
            print(f"[ERROR] Ingestion failed: {e}")
            # Extra diagnostics
            if not (os.path.isdir(target) or os.path.isfile(target)):
                print(f"[HINT] Path does not exist: {target}")
            else:
                print(f"[HINT] If this is a folder, ensure it contains .pdf/.txt/.md/.json")
                print(f"[HINT] If this is a file, ensure its extension is one of: .pdf, .txt, .md, .json")
            sys.exit(1)

if __name__ == "__main__":
    main()

## run this cript on terminal: python ingest_rag.py "C:/path/to/YourCourseDocs"
