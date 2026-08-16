# Part I, Chapter 8 — the windmills

**Work:** Don Quixote · **Author:** Miguel de Cervantes  
**Translation:** John Ormsby (public domain)  
**Spine id:** `ch08`

## Extract (abridged)

At this point they came in sight of thirty or forty windmills that there are on that plain, and as soon as Don Quixote saw them he said to his squire, “Fortune is arranging matters for us better than we could have shaped our desires ourselves, for look there, friend Sancho Panza, where thirty or more monstrous giants present themselves, all of whom I mean to engage in battle and slay.”

“What giants?” said Sancho Panza.

“Those thou seest there,” answered his master, “with the long arms, and some have them nearly two leagues long.”

“Look, your worship,” said Sancho; “what we see there are not giants but windmills, and what seem to be their arms are the sails that turned by the wind make the millstone go.”

“It is easy to see,” replied Don Quixote, “that thou art not used to this business of adventures; those are giants; and if thou art afraid, away with thee out of this and betake thyself to prayer while I engage them in fierce and unequal combat.”

So saying, he gave the spur to Rocinante, heedless of the cries his squire sent after him, warning him that most certainly they were windmills and not giants he was going to attack. He, however, was so positive they were giants that he neither heard the cries of Sancho, nor perceived, near as he was, what they were, but made at them shouting, “Fly not, cowards and vile beings, for a single knight attacks you.”

A breeze sprang up, and the great sails began to move. He ran his lance into the sail; the wind whirled it with such force that it shivered the lance to pieces, sweeping horse and rider along with it. Sancho came to his help as fast as his ass could go, and found him unable to move.

“God bless me!” said Sancho, “did I not tell your worship to mind what you were about, for they were only windmills? And nobody could have made any mistake about it but one who had something of the same kind in his head.”

“Hush, friend Sancho,” replied Don Quixote, “the fortunes of war more than any other are liable to frequent fluctuations; and moreover I think, and it is the truth, that that same sage Friston who carried off my study and books, has turned these giants into mills in order to rob me of the glory of vanquishing them.”

## Modeling notes

| Span | Triple |
|---|---|
| “he said to his squire” | `(quixote)-[:SAID_TO]->(sancho)` |
| “I mean to engage in battle and slay” | intent; realized as `ATTACKS` + Event `charge-windmills` |
| “what we see there are not giants but windmills” | `(sancho)-[:WARNS]->(quixote)`; Sancho’s label on the Place is `windmills` |
| Quixote’s label on the same Place | `giants` (delusion — do not mint a second Place) |
| lance into the sail | `(quixote)-[:ATTACKS]->(windmills)` |
| Friston / sage | `(enchantment)-[:TRANSFORMS {claimedBy:'quixote'}]->(windmills)` |

`narrator` is Cervantes via Ormsby, not a character on the plain. Do not add a Person for the translator.
