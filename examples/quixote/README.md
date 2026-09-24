# Example: Don Quixote, chapter 8 (windmills)

Public domain. Miguel de Cervantes, *Don Quixote*, Part I, chapter 8 (Ormsby translation, US public domain).

This is the smallest complete seed:

| File | Role |
|---|---|
| [spine.json](spine.json) | Chapter order (this file wins) |
| [CANON.md](CANON.md) | Locked names and aliases |
| [cast/INDEX.md](cast/INDEX.md) | Registry |
| [chapters/08-windmills.md](chapters/08-windmills.md) | Short extract + modeling notes |
| [graph/load.cypher](graph/load.cypher) | Neo4j load, ch. 8 (wipe by `source`) |
| [graph/time_model.cypher](graph/time_model.cypher) | Facts, beliefs, reveals, visions across Part I (run after `load.cypher`) |
| [graph/playhead_queries.cypher](graph/playhead_queries.cypher) | "As of chapter N, for character X" queries |
| [as-code/](as-code/) | Same facts as TypeScript |

Load:

```bash
docker compose up -d
docker exec -i novelgraph-neo4j cypher-shell -u neo4j -p novelgraph \
  < examples/quixote/graph/load.cypher
docker exec -i novelgraph-neo4j cypher-shell -u neo4j -p novelgraph \
  < examples/quixote/graph/time_model.cypher

# every playhead query at chapter 8, Sancho's point of view
docker exec -i novelgraph-neo4j cypher-shell -u neo4j -p novelgraph \
  -P 'N => 8' -P "who => 'sancho'" < examples/quixote/graph/playhead_queries.cypher
```

See [docs/TIME_MODEL.md](../../docs/TIME_MODEL.md).
