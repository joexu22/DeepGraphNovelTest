# Graph model

Two overlays, one world.

1. **Literary overlay** — what you mean. Loaded into Neo4j as-is.
2. **Code overlay** — the same facts labeled so a code-graph tool will index them. See [CODE_AS_NOVEL.md](CODE_AS_NOVEL.md).

## Literary nodes

| Label | Meaning | Required properties |
|---|---|---|
| `Work` | The book | `id`, `title`, `author` |
| `TextSpan` | Section or quoted sentence | `id`, `section`, `source` |
| `Person` | Character (or historical walk-on) | `id`, `name`; optional `fullName`, `aliases`, `role` |
| `Place` | Location | `id`, `name`, `kind` |
| `Force` | Personified non-person agent | `id`, `name` (may stack on `Place`) |
| `Group` | Crowd, order, house, faction | `id`, `name`, `kind` |
| `Event` | Thick fact (battle, funeral, charge) | `id`, `name`, `kind` |
| `LoadMeta` | Provenance of a load | `id`, `source`, `loadedAt` |

Every loadable node also gets `source` (e.g. `quixote-ch08`) so a chapter can be wiped and reloaded.

## Literary relationships

Structural

- `HAS_SECTION` Work → TextSpan
- `CONTAINS` section → sentence
- `APPEARS_IN` entity → section
- `LOCATED_IN` / `LOCATED_AT` / `LOCATED_ON`

Kin and role

- `CHILD_OF`, `SIBLING_OF`, `SPOUSE_OF`, `COUSIN_OF`, `MARRIED_TO`
- `SERVES`, `MEMBER_OF`, `PART_OF`
- `IMPLEMENTS_ROLE` (knight, squire) — optional; the code overlay uses `implements`

Action

- Direct verb edges: `ATTACKS`, `WARNS`, `KILLED`, `SAID_TO`, `RIDES`, …
- Event-mediated: `AGENT_OF`, `VICTIM_OF`, `PARTICIPATED_IN`, `ATTENDED`, `STATED_IN`

Epistemic / time (on the relationship or the Event)

- `figurative`, `narratorDoubts`, `claimedBy`
- `whenNote`, `order`, `fromSection`, `toSection`

## Constraints

```cypher
CREATE CONSTRAINT person_id IF NOT EXISTS FOR (p:Person) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT place_id  IF NOT EXISTS FOR (p:Place)  REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT group_id  IF NOT EXISTS FOR (g:Group)  REQUIRE g.id IS UNIQUE;
CREATE CONSTRAINT event_id  IF NOT EXISTS FOR (e:Event)  REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT text_id   IF NOT EXISTS FOR (t:TextSpan) REQUIRE t.id IS UNIQUE;
```

## Why both a direct edge and an Event

```
(quixote)-[:ATTACKS {believedTarget:'giants'}]->(windmills)
(quixote)-[:AGENT_OF]->(charge-windmills)<-[:TARGET_OF]-(windmills)
```

The short edge is the picture. The Event holds quote, time, and the sentence it was stated in. Draw one; query the other.

## Postgres later

Tables that want SQL more than traversal:

- `cast(id, name, aliases[])`
- `section(id, work_id, seq, path)`
- `mention(section_id, person_id, start_off, end_off)`

Same `id` strings as Neo4j. Dual-write is a next step, not a prerequisite.
