// Playhead queries — "as of chapter $N, from the point of view of $who"
// Requires: load.cypher + time_model.cypher.
// Neo4j Browser:  :param N => 8   and   :param who => 'quixote'   (or 'sancho')

// ============================================================
// 1) WORLD STATE as of chapter N — facts true in the world
// ============================================================
MATCH (f:Fact)
WHERE f.worldFromChapter <= $N
  AND (f.worldToChapter IS NULL OR f.worldToChapter > $N)
RETURN f.id, f.statement, f.worldFromChapter
ORDER BY f.worldFromChapter, f.id;

// ============================================================
// 2) WHAT $who BELIEVES as of chapter N
// ============================================================
MATCH (:Person {id:$who})-[:BELIEVES]->(b:Belief)
WHERE b.heldFromChapter <= $N
  AND (b.heldToChapter IS NULL OR b.heldToChapter >= $N)
RETURN b.id, b.statement, b.heldFromChapter
ORDER BY b.heldFromChapter;

// ============================================================
// 3) WHERE $who IS WRONG as of chapter N — belief vs. world
// ============================================================
MATCH (:Person {id:$who})-[:BELIEVES]->(b:Belief)-[:CONTRADICTS]->(f:Fact)
WHERE b.heldFromChapter <= $N
  AND (b.heldToChapter IS NULL OR b.heldToChapter >= $N)
  AND f.worldFromChapter <= $N
OPTIONAL MATCH (b)-[:EXPLAINED_BY]->(force)
OPTIONAL MATCH (b)-[:PLANTED_BY]->(planter)
RETURN b.statement AS believes, f.statement AS actually,
       force.name AS blames, planter.name AS plantedBy;

// ============================================================
// 4) READER KNOWLEDGE as of chapter N
// ============================================================
MATCH (c:Chapter)-[:CONTAINS_REVEAL]->(r:Reveal)-[:REVEALS]->(f:Fact)
WHERE c.n <= $N AND 'reader' IN r.audience
RETURN c.n AS chapter, r.mode, f.statement AS learned
ORDER BY c.n;

// ============================================================
// 5) DRAMATIC IRONY as of chapter N
//    the reader knows it; $who has not been told and has not seen it
// ============================================================
MATCH (c:Chapter)-[:CONTAINS_REVEAL]->(r:Reveal)-[:REVEALS]->(f:Fact)
WHERE c.n <= $N AND 'reader' IN r.audience
  AND f.worldFromChapter <= $N
  AND NOT EXISTS {
    MATCH (c2:Chapter)-[:CONTAINS_REVEAL]->(r2:Reveal)-[:REVEALS]->(f)
    WHERE c2.n <= $N AND $who IN r2.audience
  }
RETURN DISTINCT f.statement AS readerKnowsButNot, c.n AS readerLearnedIn;

// ============================================================
// 6) OPEN PROMISES as of chapter N — visions not yet realized
// ============================================================
MATCH (promiser)-[p:PROMISES]->(v:Vision)<-[:AWAITS]-(waiter)
WHERE p.chapter <= $N AND v.realized = false
RETURN promiser.name, v.statement, waiter.name, p.chapter;

// ============================================================
// 7) CONTINUITY CONTEXT PACK — one row to hand an LLM before it
//    writes the next scene from $who's point of view
//    (scripts/playhead_context.py runs this and formats it)
// ============================================================
MATCH (me:Person {id:$who})
CALL (me) {
  MATCH (f:Fact) WHERE f.worldFromChapter <= $N AND (f.worldToChapter IS NULL OR f.worldToChapter > $N)
  RETURN collect(f.statement) AS world
}
CALL (me) {
  MATCH (c:Chapter)-[:CONTAINS_REVEAL]->(r:Reveal)-[:REVEALS]->(f:Fact)
  WHERE c.n <= $N AND me.id IN r.audience
  RETURN collect(DISTINCT f.statement) AS knows
}
CALL (me) {
  OPTIONAL MATCH (me)-[:BELIEVES]->(b:Belief)
  WHERE b.heldFromChapter <= $N AND (b.heldToChapter IS NULL OR b.heldToChapter >= $N)
  RETURN collect(b.statement) AS believes
}
CALL (me) {
  MATCH (c:Chapter)-[:CONTAINS_REVEAL]->(r:Reveal)-[:REVEALS]->(f:Fact)
  WHERE c.n <= $N AND 'reader' IN r.audience AND f.worldFromChapter <= $N
    AND NOT EXISTS {
      MATCH (c2:Chapter)-[:CONTAINS_REVEAL]->(r2:Reveal)-[:REVEALS]->(f)
      WHERE c2.n <= $N AND me.id IN r2.audience
    }
  RETURN collect(DISTINCT f.statement) AS mustNotKnow
}
CALL (me) {
  OPTIONAL MATCH (me)-[:AWAITS|PROMISES]-(v:Vision) WHERE v.realized = false
  RETURN collect(DISTINCT v.statement) AS openPromises
}
RETURN me.name AS pov, $N AS asOfChapter, world, knows, believes, mustNotKnow, openPromises;
