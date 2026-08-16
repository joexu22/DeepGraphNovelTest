# Novel as codebase

Code-graph tools will not read Don Quixote. They will index a tree that *looks like code*. The compile step is the project. The indexer is borrowed.

## Why bother

Indexers already ship:

- blast radius (`impact`)
- shortest path (`trace`)
- communities / clusters
- hybrid search
- Cypher
- MCP tools for agents

Those verbs are useful on a novel if the nouns have been renamed.

## Dictionary

| Software (what the tool sees) | Novel (what you mean) |
|---|---|
| `File` / `Module` | Chapter or scene file |
| `Folder` | Part / volume |
| `Class` | Named character |
| `Interface` / `Trait` | Role (Knight, Squire, Priest) |
| `EXTENDS` | Lineage, rank, “is a kind of” |
| `IMPLEMENTS` | Takes on a role |
| `Function` / `Method` | Scene or deed |
| `CALLS` | Speaks to, acts on, causes |
| `IMPORTS` | Chapter cites another; flashback |
| `CONTAINS` | Chapter contains scenes |
| `HAS_PROPERTY` | Trait (madness, loyalty) |
| `ACCESSES` | Mentions / thinks of (weaker than CALLS) |
| `Community` | Faction, traveling company |
| `Process` | Quest / plot arc |
| `STEP_IN_PROCESS` | Beat inside that quest |
| `WRAPS` | Narrator frames a tale |
| `TAINTED` | Rumor, enchantment, madness spreading |
| `CFG` | Branching plot |

Tools with the names left on:

| Tool | In the book |
|---|---|
| `impact Quixote` | Blast radius if the knight is removed |
| `trace Sancho Dulcinea` | How the squire reaches the unseen lady |
| `context DonQuixote` | Dossier: scenes, roles, objects, arcs |
| `clusters` | Companies and factions |
| `processes` | Quests |
| `detect_changes` | If I rewrite ch. 8, what else shifts? |

## Two compile targets

### A. Fake TypeScript (let an indexer parse it)

TypeScript is the richest common target (imports, heritage, types, constructors). See `examples/quixote/as-code/`.

```ts
export class Hidalgo {}
export interface KnightErrant {}
export class DonQuixote extends Hidalgo implements KnightErrant {
  attacks(target: Windmill | Giant) {}
}
```

`npx <indexer> analyze` on that folder is not a hack. It is the tool doing its job.

### B. Schema impersonation

Extract a literary graph (spaCy / LLM / this repo’s Cypher), then emit nodes labeled `Class` / `Function` and edges labeled `CALLS` so MCP tools work unchanged. More accurate on messy Gutenberg text; more wiring.

## What is worth pointing at (GitHub, stars as of 2026-08)

Closest to “drop a tree, get a graph”:

| Repo | ~Stars | Use here |
|---|---:|---|
| [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | 107k | Local AST → queryable graph; agent skill |
| [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) | 67k | Local pre-index for agents |
| [abhigyanpatwari/GitNexus](https://github.com/abhigyanpatwari/GitNexus) | 45k | Browser or CLI; Tree-sitter + markdown headings/links only |

Older, honest visualizers (no “knowledge graph” pitch):

| Repo | ~Stars | Graph type |
|---|---:|---|
| [pahen/madge](https://github.com/pahen/madge) | 10k | JS/TS module deps |
| [sverweij/dependency-cruiser](https://github.com/sverweij/dependency-cruiser) | 7k | JS/TS deps + rules |
| [scottrogowski/code2flow](https://github.com/scottrogowski/code2flow) | 4.6k | Call graphs |

Queryable structure (not pretty pictures):

| Repo | ~Stars | Why |
|---|---:|---|
| [github/codeql](https://github.com/github/codeql) | 10k | Repo as a database |
| [joernio/joern](https://github.com/joernio/joern) | 3.4k | Code property graphs |

GitNexus markdown support is headings + local `[links]`. A novel as one `.txt` is empty. A novel as `as-code/*.ts` is a graph.

## What not to reuse

Overload resolution, `tsconfig`, HTTP `shape_check`, Spring injection. Leave them off. The useful borrowed surface is **heritage, calls, imports, communities, paths**.
