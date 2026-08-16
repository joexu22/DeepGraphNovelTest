# Cast registry — Quixote seed

| id | Name | Role | Notes |
|---|---|---|---|
| `quixote` | Don Quixote | Knight-errant (self-declared) | `extends` Hidalgo; `implements` KnightErrant |
| `sancho` | Sancho Panza | Squire | `SERVES` quixote |
| `dulcinea` | Dulcinea del Toboso | Unseen lady | Named, not on stage in ch. 8 |
| `rocinante` | Rocinante | Horse | Mount, not a Person |
| `enchantment` | Enchantment | Force | Quixote’s explanation of the mills |

Hierarchy for this chapter:

```
quixote  --SERVES--  sancho
quixote  --LOVES-->  dulcinea     (offstage)
quixote  --RIDES-->  rocinante
quixote  --BLAMES--> enchantment  (after the fall)
```
