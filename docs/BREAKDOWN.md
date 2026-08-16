# Breaking a book into a graph

A novel is already a graph. The work is naming the nodes so they stay stable across chapters, and refusing to let “the knight,” “Don Quixote,” and “he” remain three people.

## 1. Split the object before you model it

| Layer | What it is | Lives as |
|---|---|---|
| **Work** | The book | one node + `spine.json` |
| **Section / chapter** | Ordered reading unit | `chapters/NN-slug.md` |
| **Scene** | One continuous action (may be smaller than a chapter) | `scenes/…md` if the chapter has more than one beat |
| **Cast card** | One person, aliases, era rules | `cast/<id>.md` + `cast/INDEX.md` |
| **Canon ledger** | Names, places, power, time that must not drift | `CANON.md` — this file wins |
| **Graph load** | Executable facts | `graph/load.cypher` |
| **As-code** | Same facts in a language a code indexer will parse | `as-code/*.ts` (optional) |

**One spine file wins.** Chapter order is not “whatever folders happen to contain.” If a chapter is added to the spine and not to the loader, it silently disappears — that failure has already happened on a real book.

**Canon wins on names.** The same character picking up five labels, or a later-era title leaking into an earlier chapter, is the usual continuity bug. Lock the allowed string; list the forbidden ones.

**Scenes are first-class.** A chapter can be a container. The graph’s useful grain is often the scene: who is on stage, what is done, where, and whether the narrator is lying.

**Cast is a registry, not flavor text.** Each person gets a stable `id`, display name, aliases, role, and the files that define them. Hierarchy (who commands whom, who is cousin of whom) is edges, not adjectives buried in prose.

**Keep research off the reader spine.** Notes, prompts, extraction QA, and market copy are not chapters.

## 2. Extract text so offsets stay honest

From a PDF or EPUB:

1. Export pages for one section.
2. Repair split first-letters and hard wraps (common PDF damage).
3. Keep a `TextSpan` for the section and for any sentence you actually assert as a fact.
4. Store `source` + `section` on every node you load so a reload can wipe one chapter without killing the book.

Opening lines are good seeds because they already *are* triples:

> they came in sight of thirty or forty windmills

Subject (they) → nodes already in cast. Verb + object → `ATTACKS` / Event. The *label* they give the object (giants vs mills) is a property, not a second Place.

## 3. Grammar → graph

Do this by hand on the first page. Automate only after the ids feel right.

```
[Don Quixote] --ATTACKS {believedTarget:'giants'}--> [Windmills]
[Sancho]      --WARNS--> [Don Quixote]
[Enchantment] --TRANSFORMS {claimedBy:'quixote'}--> [Windmills]
```

Rules that saved a prior load:

- **Figurative agents are valid nodes.** “Enchantment,” “Fame,” a personified landscape — they act. Give them `Force` so they do not pretend to be people.
- **Reify events when the fact is thick.** The windmill charge: an `Event` node plus `AGENT_OF` / `TARGET_OF` / `LOCATED_AT`, *and* a short direct edge if you want a one-hop picture.
- **Reliability is a property.** `narratorDoubts:true`, `claimedBy:'quixote'`. Do not delete the edge; mark it.
- **Stable `id`, then `MATCH`.** `cypher-shell` runs one statement per transaction. `CREATE (a)-[:R]->(b)` after separate creates makes **empty nodes**. Always `MATCH (a {id:'…'}), (b {id:'…'}) CREATE (a)-[:R]->(b)`.
- **Caption ≠ id.** In Neo4j Browser, caption on `name` / `fullName`.

## 4. Time

Do not mutate one edge forever.

- **Valid time** — when it is true in the world (`from` / `to` on the rel, or an Event).
- **Narrative time** — when the narrator tells it (section playhead).
- **Playhead** — a reader slider: show the subgraph whose `fromSection`/`toSection` contains the current chapter.

Fiction wants all three. A marriage with `order:1` then `order:2` is the cheap version. A section spine is the real one. Not implemented in this seed yet.

## 5. What to type vs what to infer

| Hand-authored (now) | Later extractor |
|---|---|
| Spine, cast ids, aliases | Candidate mentions |
| Opening-sentence triples | Verb lexicon (`said`, `struck`, `rode to`, `warned`) |
| Family / rank / role | Coreference (“the knight” → `quixote`) |
| Doubt flags you can see | Quote attribution |

An extractor that emits Cypher without a locked id list will mint three Quixotes. Start with the name list.

## 6. Public vs private text

This public repo only carries public-domain examples. Copyrighted extracts and private manuscripts stay in their own trees. Copy **method**, not **pages**.
