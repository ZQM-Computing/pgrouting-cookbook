-- Compare nodes reachable from two facilities under the same budget.
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
  (1, 1, 2, 1.0, 1.0, 0, 0, 1, 0, ST_SetSRID(ST_MakeLine(ST_Point(0,0), ST_Point(1,0)),3857),
  (2, 2, 3, 1.0, 1.0, 1, 0, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(1,0), ST_Point(2,0)),3857),
  (3, 1, 4, 1.4, 1.4, 0, 0, 0, 1, ST_SetSRID(ST_MakeLine(ST_Point(0,0), ST_Point(0,1)),3857),
  (4, 4, 3, 1.0, 1.0, 0, 1, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(0,1), ST_Point(2,0)),3857),
  (5, 2, 5, 1.0, 1.0, 1, 0, 1, 1, ST_SetSRID(ST_MakeLine(ST_Point(1,0), ST_Point(1,1)),3857),
  (6, 5, 6, 1.0, 1.0, 1, 1, 2, 1, ST_SetSRID(ST_MakeLine(ST_Point(1,1), ST_Point(2,1)),3857),
  (7, 6, 3, 1.0, 1.0, 2, 1, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(2,1), ST_Point(2,0)),3857),
  (8, 4, 5, 1.0, 1.0, 0, 1, 1, 1, ST_SetSRID(ST_MakeLine(ST_Point(0,1), ST_Point(1,1)),3857);

WITH facilities(facility_id, start_vid) AS (
  VALUES (1, 1), (2, 6)
)
SELECT f.facility_id, reach.node, reach.agg_cost AS accumulated_cost
FROM facilities f
CROSS JOIN LATERAL pgr_drivingDistance(
  'SELECT id, source, target, cost, reverse_cost FROM edges',
  f.start_vid, 2.5, directed := true
) AS reach
ORDER BY f.facility_id, reach.agg_cost, reach.node;
