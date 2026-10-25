-- Demonstrate a prohibited turn using an explicit edge-transition restriction.
-- pgr_trsp accepts restriction rows (to_cost, target_id, via_path); the
-- via_path sequence identifies the prohibited transition through edge IDs.
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgrouting;

CREATE TEMP TABLE edges (
  id bigint PRIMARY KEY,
  source bigint NOT NULL,
  target bigint NOT NULL,
  cost double precision NOT NULL,
  reverse_cost double precision NOT NULL,
  x1 double precision NOT NULL,
  y1 double precision NOT NULL,
  x2 double precision NOT NULL,
  y2 double precision NOT NULL,
  geom geometry(LineString, 3857) NOT NULL
);

INSERT INTO edges (id, source, target, cost, reverse_cost, x1, y1, x2, y2, geom) VALUES
  (1, 1, 2, 1.0, 1.0, 0, 0, 1, 0, ST_SetSRID(ST_MakeLine(ST_Point(0,0), ST_Point(1,0))),
  (2, 2, 3, 1.0, 1.0, 1, 0, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(1,0), ST_Point(2,0))),
  (3, 1, 4, 1.4, 1.4, 0, 0, 0, 1, ST_SetSRID(ST_MakeLine(ST_Point(0,0), ST_Point(0,1))),
  (4, 4, 3, 1.0, 1.0, 0, 1, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(0,1), ST_Point(2,0))),
  (5, 2, 5, 1.0, 1.0, 1, 0, 1, 1, ST_SetSRID(ST_MakeLine(ST_Point(1,0), ST_Point(1,1))),
  (6, 5, 6, 1.0, 1.0, 1, 1, 2, 1, ST_SetSRID(ST_MakeLine(ST_Point(1,1), ST_Point(2,1))),
  (7, 6, 3, 1.0, 1.0, 2, 1, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(2,1), ST_Point(2,0))),
  (8, 4, 5, 1.0, 1.0, 0, 1, 1, 1, ST_SetSRID(ST_MakeLine(ST_Point(0,1), ST_Point(1,1)));

CREATE TEMP TABLE restrictions (
  to_cost double precision NOT NULL,
  target_id bigint NOT NULL,
  via_path text NOT NULL
);
-- For this synthetic graph, prohibit the transition from edge 1 to edge 2.
INSERT INTO restrictions VALUES (-1, 2, '1');
SELECT *
FROM pgr_trsp(
  'SELECT id, source, target, cost, reverse_cost FROM edges',
  1, 3, true, false,
  'SELECT to_cost, target_id, via_path FROM restrictions'
)
ORDER BY seq;
