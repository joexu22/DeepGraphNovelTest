#!/usr/bin/env python3
"""Print a continuity context pack for an LLM: what is true, known, believed, and off-limits
for one character as of one chapter.

    pip install neo4j
    python3 scripts/playhead_context.py --pov sancho --chapter 8

Runs the last query in examples/quixote/graph/playhead_queries.cypher (the context pack).
Connection comes from NEO4J_URI / NEO4J_USER / NEO4J_PASSWORD (defaults match .env.example).
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path

from neo4j import GraphDatabase

QUERIES = Path(__file__).resolve().parents[1] / "examples/quixote/graph/playhead_queries.cypher"


def context_query() -> str:
    statements = [s.strip() for s in QUERIES.read_text(encoding="utf-8").split(";") if s.strip()]
    return statements[-1]


def section(title: str, items: list[str], empty: str = "(none)") -> str:
    body = "\n".join(f"- {i}" for i in items) if items else f"- {empty}"
    return f"### {title}\n{body}"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--pov", default="sancho", help="Person id, e.g. quixote or sancho")
    ap.add_argument("--chapter", type=int, default=8, help="Playhead: chapter number")
    args = ap.parse_args()

    driver = GraphDatabase.driver(
        os.environ.get("NEO4J_URI", "bolt://localhost:7687"),
        auth=(os.environ.get("NEO4J_USER", "neo4j"), os.environ.get("NEO4J_PASSWORD", "novelgraph")),
        # worldToChapter is optional (open-ended facts omit it); silence "property key does not exist"
        notifications_min_severity="OFF",
    )
    with driver:
        records, _, _ = driver.execute_query(context_query(), N=args.chapter, who=args.pov)
    if not records:
        raise SystemExit(f"No Person with id {args.pov!r}. Load load.cypher and time_model.cypher first.")
    r = records[0]

    print(f"## Continuity context: {r['pov']}, as of chapter {r['asOfChapter']}\n")
    print(section("True in the world", r["world"]))
    print()
    print(section(f"{r['pov']} knows", r["knows"]))
    print()
    print(section(f"{r['pov']} believes (may be wrong; write them as believed)", r["believes"]))
    print()
    print(section(f"{r['pov']} must NOT know or realize yet (reader-only)", r["mustNotKnow"]))
    print()
    print(section("Open promises", r["openPromises"]))


if __name__ == "__main__":
    main()
