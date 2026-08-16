# Novel Graph

Seed repo: treat a **novel as a graph**, the same way a code indexer treats a codebase as a graph.

A chapter is a file. A character is a class. A scene is a function. “Said / struck / rode to” is a call. Existing code-graph tools (`impact`, `trace`, clusters, Cypher) then work without being rewritten — **after** a compile step. They will not invent Sancho from prose.

```
prose  →  extract / encode  →  property graph  →  Neo4j or a code-graph indexer
```

## What is in here

| Path | Role |
|---|---|
| [docs/BREAKDOWN.md](docs/BREAKDOWN.md) | How to break a book: spine, cast, scenes, grammar→graph, time, reliability |
| [docs/MODEL.md](docs/MODEL.md) | Node and relationship types |
| [docs/CODE_AS_NOVEL.md](docs/CODE_AS_NOVEL.md) | Software relations → literary relations; which GitHub tools to reuse |
| [examples/quixote](examples/quixote) | Public-domain seed (Cervantes, windmills) — markdown, Cypher, fake TypeScript |
| `docker-compose.yml` | Local Postgres 16 + Neo4j 5 (bind-mounted under `data/`) |

There is no application yet. The example Cypher is the first executable artifact.

## Run the seed graph

```bash
docker compose up -d
open http://localhost:7474          # neo4j / novelgraph

docker exec -i novelgraph-neo4j cypher-shell -u neo4j -p novelgraph \
  < examples/quixote/graph/load.cypher
```

```cypher
MATCH path = (q {id:'quixote'})-[:ATTACKS]->(w {id:'windmills'})
RETURN path

MATCH path = (s:Person {id:'sancho'})-[*1..2]-(n)
RETURN path LIMIT 40
```

Postgres is there for tabular facts later (cast sheets, section offsets). Graph-shaped questions stay in Neo4j.

Dev-only passwords live in `.env.example`. Do not reuse them on a network.

## Provenance of the method

Shapes learned on private work, restated here without those texts:

1. **Fiction as a property graph** — model a sentence as subject–verb–object, load People / Places / Groups / Events / TextSpans into Neo4j, treat figurative agents as real nodes, flag narrator doubt, and never let cypher-shell create empty nodes.
2. **Long-form book pipeline** — one spine file owns chapter order; each character has a registry card; scenes are first-class files (not only chapters); a canon ledger locks names and era so titles do not leak backward; research notes stay off the reader spine.

This public repo only carries public-domain examples. The *shapes* are what transfer.

## Next work (in likely order)

- [ ] Extractor: paragraph → `(agent, verb, patient)` → Cypher, name-list + verb lexicon first
- [ ] Section spine + `fromSection` / `toSection` playhead (do not mutate one edge forever)
- [ ] Point a code-graph CLI at `examples/quixote/as-code/` and see `impact DonQuixote`
- [ ] Dual-write a few facts into Postgres for comparison
- [ ] Tiny reader: chapter slider → filtered subgraph

See [AGENTS.md](AGENTS.md) if you are an agent landing here.
