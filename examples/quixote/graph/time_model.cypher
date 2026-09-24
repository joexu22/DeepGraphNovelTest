// Don Quixote, Part I — time and revelation model (playhead demo)
// Requires: graph/load.cypher first (quixote, sancho, dulcinea, windmills, enchantment, ch08).
// Wipe key: source = 'quixote-time'. Safe to re-run.
// cypher-shell is one statement per transaction: MATCH by id before every rel.
//
// Four kinds of node carry time (see docs/TIME_MODEL.md):
//   Fact    — true in the world, with a validity window on the chapter clock
//   Belief  — what one character holds; may contradict a Fact
//   Reveal  — the moment a Fact reaches the reader or a character
//   Vision  — promised or imagined; never world-actual inside Part I
// Chapter clock: n = chapter number. worldFromChapter 0 = already true before the book opens.

MATCH (n) WHERE n.source = 'quixote-time' DETACH DELETE n;
MATCH (n) WHERE size(labels(n)) = 0 DETACH DELETE n;

CREATE CONSTRAINT fact_id   IF NOT EXISTS FOR (f:Fact)   REQUIRE f.id IS UNIQUE;
CREATE CONSTRAINT belief_id IF NOT EXISTS FOR (b:Belief) REQUIRE b.id IS UNIQUE;
CREATE CONSTRAINT reveal_id IF NOT EXISTS FOR (r:Reveal) REQUIRE r.id IS UNIQUE;
CREATE CONSTRAINT vision_id IF NOT EXISTS FOR (v:Vision) REQUIRE v.id IS UNIQUE;
CREATE CONSTRAINT object_id IF NOT EXISTS FOR (o:Object) REQUIRE o.id IS UNIQUE;

// ========== CHAPTER CLOCK ==========
// ch08 already exists as a TextSpan from load.cypher; give it the Chapter label and a number.
MATCH (c:TextSpan {id:'ch08'}) SET c:Chapter, c.n = 8;

CREATE (:TextSpan:Chapter {id:'ch01', n:1,  section:'Part I ch. 1',  label:'the hidalgo reads himself into knighthood', source:'quixote-time'});
CREATE (:TextSpan:Chapter {id:'ch02', n:2,  section:'Part I ch. 2',  label:'first sally; the inn',                      source:'quixote-time'});
CREATE (:TextSpan:Chapter {id:'ch03', n:3,  section:'Part I ch. 3',  label:'the innkeeper dubs him',                    source:'quixote-time'});
CREATE (:TextSpan:Chapter {id:'ch06', n:6,  section:'Part I ch. 6',  label:'the scrutiny of the library',              source:'quixote-time'});
CREATE (:TextSpan:Chapter {id:'ch07', n:7,  section:'Part I ch. 7',  label:'the walled-up room; Sancho signs on',       source:'quixote-time'});
CREATE (:TextSpan:Chapter {id:'ch21', n:21, section:'Part I ch. 21', label:'the helmet of Mambrino',                    source:'quixote-time'});
CREATE (:TextSpan:Chapter {id:'ch25', n:25, section:'Part I ch. 25', label:'Sierra Morena; who Dulcinea is',            source:'quixote-time'});

MATCH (w {id:'don-quixote'}), (c:Chapter) WHERE c.source = 'quixote-time' CREATE (w)-[:HAS_SECTION {source:'quixote-time'}]->(c);
MATCH (c:Chapter) WITH c ORDER BY c.n WITH collect(c) AS cs
  UNWIND range(0, size(cs) - 2) AS i
  WITH cs[i] AS a, cs[i + 1] AS b
  CREATE (a)-[:NEXT {source:'quixote-time'}]->(b);

// ========== NEW CAST, PLACES, OBJECTS ==========
CREATE (:Person {id:'niece',       name:'the niece',       role:'household',  source:'quixote-time'});
CREATE (:Person {id:'housekeeper', name:'the housekeeper', role:'household',  source:'quixote-time'});
CREATE (:Person {id:'curate',      name:'the curate',      fullName:'Pero Pérez', role:'village priest', source:'quixote-time'});
CREATE (:Person {id:'barber',      name:'the barber',      fullName:'Master Nicholas', role:'village barber', source:'quixote-time'});
CREATE (:Person {id:'innkeeper',   name:'the innkeeper',   quixoteLabel:'the castellan', source:'quixote-time'});

CREATE (:Place  {id:'first-inn', name:'the roadside inn', kind:'inn', quixoteLabel:'a castle', source:'quixote-time'});
CREATE (:Object {id:'library',   name:'the library of chivalry books', source:'quixote-time'});
CREATE (:Object {id:'basin',     name:'a barber’s brass basin', quixoteLabel:'the helmet of Mambrino', source:'quixote-time'});

// ========== FACTS (world clock) ==========
CREATE (:Fact {id:'fact-hidalgo', statement:'Don Quixote is a country hidalgo who renamed himself after reading chivalry romances; his real surname is uncertain (Quixada, Quesada, or Quexana)', kind:'identity', status:'actual', worldFromChapter:0, narratorDoubts:true, source:'quixote-time'});
CREATE (:Fact {id:'fact-dulcinea-is-aldonza', statement:'Dulcinea del Toboso is Aldonza Lorenzo, a farm girl from El Toboso', kind:'identity', status:'actual', worldFromChapter:0, source:'quixote-time'});
CREATE (:Fact {id:'fact-inn-is-inn', statement:'The building he reaches at nightfall is an ordinary roadside inn', kind:'perception', status:'actual', worldFromChapter:0, source:'quixote-time'});
CREATE (:Fact {id:'fact-sham-dubbing', statement:'The innkeeper performs a mock dubbing, reading from his account book, to be rid of his guest', kind:'event', status:'actual', worldFromChapter:3, source:'quixote-time'});
CREATE (:Fact {id:'fact-library-destroyed', statement:'The curate, barber, niece, and housekeeper burned the books and walled up the room', kind:'event', status:'actual', worldFromChapter:7, source:'quixote-time'});
CREATE (:Fact {id:'fact-mills-are-mills', statement:'The thirty or forty shapes on the plain are windmills, and always were', kind:'perception', status:'actual', worldFromChapter:0, source:'quixote-time'});
CREATE (:Fact {id:'fact-basin-is-basin', statement:'The shining object on the rider’s head is a barber’s brass basin worn against the rain', kind:'perception', status:'actual', worldFromChapter:21, source:'quixote-time'});

MATCH (f:Fact {id:'fact-hidalgo'}), (p {id:'quixote'})            CREATE (f)-[:ABOUT]->(p);
MATCH (f:Fact {id:'fact-dulcinea-is-aldonza'}), (p {id:'dulcinea'}) CREATE (f)-[:ABOUT]->(p);
MATCH (f:Fact {id:'fact-inn-is-inn'}), (p {id:'first-inn'})       CREATE (f)-[:ABOUT]->(p);
MATCH (f:Fact {id:'fact-sham-dubbing'}), (p {id:'innkeeper'})     CREATE (p)-[:AGENT_OF]->(f);
MATCH (f:Fact {id:'fact-sham-dubbing'}), (p {id:'quixote'})       CREATE (f)-[:ABOUT]->(p);
MATCH (f:Fact {id:'fact-library-destroyed'}), (o {id:'library'})  CREATE (f)-[:ABOUT]->(o);
MATCH (f:Fact {id:'fact-library-destroyed'}), (p:Person) WHERE p.id IN ['curate','barber','niece','housekeeper'] CREATE (p)-[:AGENT_OF]->(f);
MATCH (f:Fact {id:'fact-mills-are-mills'}), (p {id:'windmills'})  CREATE (f)-[:ABOUT]->(p);
MATCH (f:Fact {id:'fact-basin-is-basin'}), (o {id:'basin'})       CREATE (f)-[:ABOUT]->(o);

// ========== BELIEFS (character graph ≠ world graph) ==========
CREATE (:Belief {id:'bel-inn-castle',     statement:'The inn is a castle and the innkeeper its castellan', heldFromChapter:2, heldToChapter:3, source:'quixote-time'});
CREATE (:Belief {id:'bel-true-knight',    statement:'He is a lawfully dubbed knight-errant',               heldFromChapter:3, source:'quixote-time'});
CREATE (:Belief {id:'bel-friston-library',statement:'The enchanter Friston carried off his library',        heldFromChapter:7, source:'quixote-time'});
CREATE (:Belief {id:'bel-giants',         statement:'The shapes on the plain are giants',                    heldFromChapter:8, heldToChapter:8, source:'quixote-time'});
CREATE (:Belief {id:'bel-friston-mills',  statement:'Friston turned the giants into windmills to rob him of the glory', heldFromChapter:8, source:'quixote-time'});
CREATE (:Belief {id:'bel-mambrino',       statement:'The basin is the enchanted golden helmet of Mambrino',  heldFromChapter:21, source:'quixote-time'});

MATCH (p {id:'quixote'}), (b:Belief) WHERE b.source = 'quixote-time' CREATE (p)-[:BELIEVES]->(b);

MATCH (b:Belief {id:'bel-inn-castle'}),      (f:Fact {id:'fact-inn-is-inn'})        CREATE (b)-[:CONTRADICTS]->(f);
MATCH (b:Belief {id:'bel-true-knight'}),     (f:Fact {id:'fact-sham-dubbing'})      CREATE (b)-[:CONTRADICTS]->(f);
MATCH (b:Belief {id:'bel-friston-library'}), (f:Fact {id:'fact-library-destroyed'}) CREATE (b)-[:CONTRADICTS]->(f);
MATCH (b:Belief {id:'bel-giants'}),          (f:Fact {id:'fact-mills-are-mills'})   CREATE (b)-[:CONTRADICTS]->(f);
MATCH (b:Belief {id:'bel-friston-mills'}),   (f:Fact {id:'fact-mills-are-mills'})   CREATE (b)-[:CONTRADICTS]->(f);
MATCH (b:Belief {id:'bel-mambrino'}),        (f:Fact {id:'fact-basin-is-basin'})    CREATE (b)-[:CONTRADICTS]->(f);

// Where a belief came from, and how it is kept alive
MATCH (b:Belief {id:'bel-friston-library'}), (p {id:'niece'})     CREATE (b)-[:PLANTED_BY {chapter:7, note:'she says an enchanter came on a cloud'}]->(p);
MATCH (b:Belief {id:'bel-friston-library'}), (e {id:'enchantment'}) CREATE (b)-[:EXPLAINED_BY]->(e);
MATCH (b:Belief {id:'bel-friston-mills'}),   (e {id:'enchantment'}) CREATE (b)-[:EXPLAINED_BY]->(e);
MATCH (b:Belief {id:'bel-mambrino'}),        (e {id:'enchantment'}) CREATE (b)-[:EXPLAINED_BY]->(e);
MATCH (a:Belief {id:'bel-giants'}), (b:Belief {id:'bel-friston-mills'}) CREATE (a)-[:REPLACED_BY {chapter:8, note:'after the fall, delusion repairs itself'}]->(b);

// ========== REVEALS (when a mind opens) ==========
// audience: who learns it. mode: narration | witnessed | dialogue
// Quixote is in the audience for ch01 facts: he chose his own name and his lady's.
CREATE (:Reveal {id:'rev-hidalgo-reader',  audience:['reader','quixote'],           mode:'narration', source:'quixote-time'});
CREATE (:Reveal {id:'rev-aldonza-reader',  audience:['reader','quixote'],           mode:'narration', source:'quixote-time'});
CREATE (:Reveal {id:'rev-inn-reader',      audience:['reader'],           mode:'narration', source:'quixote-time'});
CREATE (:Reveal {id:'rev-dubbing-reader',  audience:['reader'],           mode:'narration', source:'quixote-time'});
CREATE (:Reveal {id:'rev-library-reader',  audience:['reader'],           mode:'narration', source:'quixote-time'});
CREATE (:Reveal {id:'rev-hidalgo-sancho',  audience:['sancho'],           mode:'witnessed', note:'a neighbour; he knows the man', source:'quixote-time'});
CREATE (:Reveal {id:'rev-mills-sancho',    audience:['reader','sancho'],  mode:'witnessed', source:'quixote-time'});
CREATE (:Reveal {id:'rev-basin-sancho',    audience:['reader','sancho'],  mode:'witnessed', source:'quixote-time'});
CREATE (:Reveal {id:'rev-aldonza-sancho',  audience:['sancho'],           mode:'dialogue', toldBy:'quixote', source:'quixote-time'});

MATCH (c:Chapter {id:'ch01'}), (r:Reveal {id:'rev-hidalgo-reader'}), (f:Fact {id:'fact-hidalgo'})              CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch01'}), (r:Reveal {id:'rev-aldonza-reader'}), (f:Fact {id:'fact-dulcinea-is-aldonza'})  CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch02'}), (r:Reveal {id:'rev-inn-reader'}),     (f:Fact {id:'fact-inn-is-inn'})           CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch03'}), (r:Reveal {id:'rev-dubbing-reader'}), (f:Fact {id:'fact-sham-dubbing'})         CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch07'}), (r:Reveal {id:'rev-library-reader'}), (f:Fact {id:'fact-library-destroyed'})    CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch07'}), (r:Reveal {id:'rev-hidalgo-sancho'}), (f:Fact {id:'fact-hidalgo'})             CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch08'}), (r:Reveal {id:'rev-mills-sancho'}),   (f:Fact {id:'fact-mills-are-mills'})      CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch21'}), (r:Reveal {id:'rev-basin-sancho'}),   (f:Fact {id:'fact-basin-is-basin'})       CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);
MATCH (c:Chapter {id:'ch25'}), (r:Reveal {id:'rev-aldonza-sancho'}), (f:Fact {id:'fact-dulcinea-is-aldonza'})  CREATE (c)-[:CONTAINS_REVEAL]->(r)-[:REVEALS]->(f);

// ========== VISIONS (promised, never world-actual in Part I) ==========
CREATE (:Vision {id:'vis-island', statement:'Sancho will be made governor of an island won in some adventure', promisedInChapter:7, realized:false, note:'the promise that keeps Sancho on the road', source:'quixote-time'});
MATCH (q {id:'quixote'}), (v:Vision {id:'vis-island'}) CREATE (q)-[:PROMISES {chapter:7}]->(v);
MATCH (s {id:'sancho'}),  (v:Vision {id:'vis-island'}) CREATE (s)-[:AWAITS]->(v);

CREATE (:LoadMeta {id:'load-quixote-time', source:'quixote-time', section:'Part I ch. 1–25 (selected)', loadedAt:datetime()});
