// Don Quixote — Part I ch. 8 (windmills)
// Source: examples/quixote/chapters/08-windmills.md
// cypher-shell is one statement per transaction: MATCH by id before every rel.

MATCH (n) WHERE n.source = 'quixote-ch08' DETACH DELETE n;
MATCH (n) WHERE size(labels(n)) = 0 DETACH DELETE n;

CREATE CONSTRAINT person_id IF NOT EXISTS FOR (p:Person) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT place_id  IF NOT EXISTS FOR (p:Place)  REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT group_id  IF NOT EXISTS FOR (g:Group)  REQUIRE g.id IS UNIQUE;
CREATE CONSTRAINT event_id  IF NOT EXISTS FOR (e:Event)  REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT text_id   IF NOT EXISTS FOR (t:TextSpan) REQUIRE t.id IS UNIQUE;

CREATE (:Work {id:'don-quixote', title:'Don Quixote', author:'Miguel de Cervantes', source:'quixote-ch08'});
CREATE (:TextSpan {id:'ch08', section:'Part I ch. 8', work:'Don Quixote', source:'quixote-ch08', title:'the windmills'});
CREATE (:TextSpan {id:'ch08-s1', section:'Part I ch. 8', source:'quixote-ch08', quote:'they came in sight of thirty or forty windmills that there are on that plain'});

CREATE (:Person {id:'quixote', name:'Don Quixote', fullName:'Don Quixote of La Mancha', aliases:['the knight','his master'], role:'knight-errant', source:'quixote-ch08', section:'Part I ch. 8'});
CREATE (:Person {id:'sancho', name:'Sancho', fullName:'Sancho Panza', aliases:['the squire'], role:'squire', source:'quixote-ch08', section:'Part I ch. 8'});
CREATE (:Person {id:'dulcinea', name:'Dulcinea', fullName:'Dulcinea del Toboso', role:'lady', onStage:false, source:'quixote-ch08', section:'Part I ch. 8'});

CREATE (:Place {id:'plain', name:'the plain', kind:'plain', source:'quixote-ch08', section:'Part I ch. 8'});
CREATE (:Place {id:'windmills', name:'windmills', kind:'mills', countNote:'thirty or forty', quixoteLabel:'giants', sanchoLabel:'windmills', source:'quixote-ch08', section:'Part I ch. 8'});

CREATE (:Force {id:'enchantment', name:'Enchantment', aliases:['sage Friston'], source:'quixote-ch08', section:'Part I ch. 8', note:'Quixote’s agent when giants become mills'});

CREATE (:Event {id:'charge-windmills', name:'the charge at the windmills', kind:'combat', figurative:false, source:'quixote-ch08', section:'Part I ch. 8'});
CREATE (:Event {id:'fall-from-rocinante', name:'horse and rider swept along', kind:'defeat', source:'quixote-ch08', section:'Part I ch. 8'});

CREATE (:LoadMeta {id:'load-quixote-ch08', source:'quixote-ch08', section:'Part I ch. 8', loadedAt:datetime()});

MATCH (a {id:'don-quixote'}), (b {id:'ch08'}) CREATE (a)-[:HAS_SECTION]->(b);
MATCH (a {id:'ch08'}), (b {id:'ch08-s1'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a {id:'windmills'}), (b {id:'plain'}) CREATE (a)-[:LOCATED_IN]->(b);

MATCH (a {id:'sancho'}), (b {id:'quixote'}) CREATE (a)-[:SERVES]->(b);
MATCH (a {id:'quixote'}), (b {id:'dulcinea'}) CREATE (a)-[:LOVES]->(b);
MATCH (a {id:'quixote'}), (b {id:'sancho'}) CREATE (a)-[:SAID_TO {about:'giants'}]->(b);
MATCH (a {id:'sancho'}), (b {id:'quixote'}) CREATE (a)-[:WARNS {claim:'those are windmills'}]->(b);
MATCH (a {id:'quixote'}), (b {id:'windmills'}) CREATE (a)-[:ATTACKS {weapon:'lance', believedTarget:'giants'}]->(b);
MATCH (a {id:'quixote'}), (b {id:'charge-windmills'}) CREATE (a)-[:AGENT_OF]->(b);
MATCH (a {id:'windmills'}), (b {id:'charge-windmills'}) CREATE (a)-[:TARGET_OF]->(b);
MATCH (a {id:'charge-windmills'}), (b {id:'plain'}) CREATE (a)-[:LOCATED_AT]->(b);
MATCH (a {id:'charge-windmills'}), (b {id:'fall-from-rocinante'}) CREATE (a)-[:LEADS_TO]->(b);
MATCH (a {id:'quixote'}), (b {id:'fall-from-rocinante'}) CREATE (a)-[:VICTIM_OF]->(b);
MATCH (a {id:'sancho'}), (b {id:'fall-from-rocinante'}) CREATE (a)-[:ATTENDED]->(b);
MATCH (a {id:'enchantment'}), (b {id:'windmills'}) CREATE (a)-[:TRANSFORMS {claimedBy:'quixote', fromLabel:'giants', toLabel:'mills'}]->(b);
MATCH (a {id:'quixote'}), (b {id:'enchantment'}) CREATE (a)-[:BLAMES]->(b);

MATCH (a {id:'quixote'}), (b {id:'ch08'}) CREATE (a)-[:APPEARS_IN]->(b);
MATCH (a {id:'sancho'}), (b {id:'ch08'}) CREATE (a)-[:APPEARS_IN]->(b);
MATCH (a {id:'windmills'}), (b {id:'ch08'}) CREATE (a)-[:APPEARS_IN]->(b);
MATCH (a {id:'charge-windmills'}), (b {id:'ch08'}) CREATE (a)-[:APPEARS_IN]->(b);
MATCH (a {id:'enchantment'}), (b {id:'ch08'}) CREATE (a)-[:APPEARS_IN]->(b);
