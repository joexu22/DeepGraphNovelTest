-- Sanity check for local Postgres (DBeaver or psql)

SELECT version();

SELECT current_database() AS db,
       current_user       AS "user",
       now()              AS connected_at;

CREATE TABLE IF NOT EXISTS hello (
  id   serial PRIMARY KEY,
  note text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO hello (note)
VALUES ('hello from novel-graph')
ON CONFLICT DO NOTHING;

SELECT * FROM hello ORDER BY id;
