// Sanity check for Neo4j Browser (http://localhost:7474)

MATCH (n:Hello) DETACH DELETE n;

CREATE (a:Hello:Person {name: 'Alice'})
CREATE (b:Hello:Person {name: 'Bob'})
CREATE (a)-[:KNOWS {since: 2026}]->(b)
RETURN a, b;
