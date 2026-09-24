# Time, belief, and revelation

A novel graph that only stores "what is true" can't answer the questions a writer (or a model writing the next chapter) actually asks:

- What is true in the world **as of chapter N**?
- What does **this character** know by then, and what do they wrongly believe?
- What does the **reader** know that the character doesn't? That gap is dramatic irony, and it's also exactly what a model must not leak.

Mutating one edge as the story moves forward loses history. This model keeps three clocks instead, and asks every question against a **playhead**.

## Three clocks

| Clock | Question | Carried by |
|---|---|---|
| **World** | When is it true in the story? | `Fact.worldFromChapter`, optional `worldToChapter` |
| **Knowledge** | When does the reader, or a character, learn it? | `Reveal` nodes hung off a `Chapter` |
| **Mind** | What does a character hold to be true, right or wrong? | `Belief.heldFromChapter`, optional `heldToChapter` |

A fourth kind of node, `Vision`, carries things promised or imagined that are **not** world-actual (Sancho's island). They must never leak into world queries.

`worldFromChapter: 0` means "already true before the book opens." A missing `worldToChapter` or `heldToChapter` means "still true / still held."

## Nodes and edges

```
(:Fact    {id, statement, kind, status, worldFromChapter, worldToChapter?, narratorDoubts?})
(:Belief  {id, statement, heldFromChapter, heldToChapter?})
(:Reveal  {id, audience:[...], mode})          // audience: 'reader' and/or person ids
(:Vision  {id, statement, promisedInChapter, realized})
(:Chapter {id, n})                              // also a TextSpan

(Chapter)-[:CONTAINS_REVEAL]->(Reveal)-[:REVEALS]->(Fact)
(Person)-[:BELIEVES]->(Belief)-[:CONTRADICTS]->(Fact)
(Belief)-[:EXPLAINED_BY]->(Force)               // how the delusion survives contact
(Belief)-[:PLANTED_BY {chapter}]->(Person)      // where it came from
(Belief)-[:REPLACED_BY {chapter}]->(Belief)     // how it repairs itself
(Person)-[:PROMISES {chapter}]->(Vision)<-[:AWAITS]-(Person)
(Fact)-[:ABOUT]->(anything) · (Person)-[:AGENT_OF]->(Fact)
```

`Reveal.mode` is `narration` (the narrator tells the reader), `witnessed` (a character sees it), or `dialogue` (someone is told).

## Four kinds of change, four tools

| Change | Example (Quixote) | Model it as |
|---|---|---|
| The world changes | the books are burned (ch. 7) | a new `Fact` with `worldFromChapter: 7` |
| A mind opens | Sancho learns Dulcinea is Aldonza (ch. 25) | a `Reveal` to `sancho` in ch. 25; the Fact was true since 0 |
| A mind is wrong | giants, not windmills (ch. 8) | a `Belief` that `CONTRADICTS` a Fact |
| Something is promised | the island (ch. 7) | a `Vision`, never a Fact |

Using the wrong tool is the usual bug. For example, making "the mills are giants" a Fact with a validity window would claim the world itself changed.

## Playhead queries

[`examples/quixote/graph/playhead_queries.cypher`](../examples/quixote/graph/playhead_queries.cypher), parameters `$N` (chapter) and `$who` (person id):

1. World state at N
2. What `$who` believes at N
3. Where `$who` is wrong: each belief against the fact it contradicts, with who planted it and what it blames
4. Reader knowledge at N
5. Dramatic irony: reader knows, `$who` doesn't
6. Open promises
7. **Continuity context pack**: all of the above in one row, for a model about to write from `$who`'s point of view

## Why this matters for generation

Long-form LLM writing fails in predictable ways: characters know things they shouldn't, delusions quietly get "fixed," and promises are forgotten. The context pack turns the graph into a guardrail. The model is told what is true, what the POV character knows, what they believe (and must keep believing), what they must **not** realize yet, and what's still owed.

```bash
python3 scripts/playhead_context.py --pov quixote --chapter 21
```

## Rules

- Stable string ids; `MATCH` by id before creating a relationship.
- Wipe and reload by `source` (`quixote-time`). Loads are idempotent.
- A Fact never moves. If the world changes, close the old Fact (`worldToChapter`) and open a new one.
- Keep `Vision` out of world queries.
