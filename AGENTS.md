# Agent notes — novel-graph seed

This repo is a **seed**, not a product. Treat a novel as a property graph. Reuse code-graph tools by compiling literature into the shapes those tools already query.

## Do

- Public-domain examples only in this tree (Cervantes is fine; living authors are not).
- Stable string `id` on every node. `MATCH` by `id` before creating relationships (cypher-shell is one statement per transaction).
- One spine file wins for chapter order (`examples/*/spine.json`).
- One canon ledger wins for names, aliases, era. Naming drift is the usual failure.
- Keep research notes out of the reader spine.

## Do not

- Commit bind-mounted `data/` databases.
- Copy copyrighted novels into `examples/`.
- Put private book titles, cast, or plot from other local projects into this public repo.
- Invent SaaS reviews or marketing copy about graph vendors.

## First useful work

1. Load `examples/quixote/graph/load.cypher`.
2. Compile another public-domain chapter into `as-code/` and try a code-graph indexer on it.
3. Extractor: paragraph → (agent, act, patient) → Cypher. Start with a name list + verb lexicon.
