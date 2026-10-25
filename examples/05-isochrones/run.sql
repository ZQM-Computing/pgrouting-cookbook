-- Approximate service envelope: hull of nodes reachable within a cost budget.
-- This is a visual envelope, not a road-network isochrone polygon.
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
  (1, 1, 2, 1.0, 1.0, 0, 0, 1, 0, ST_MakeLine(ST_Point(0,0), ST_Point(1,0))),
  (2, 2, 3, 1.0, 1.0, 1, 0, 2, 0, ST_MakeLine(ST_Point(1,0), ST_Point(2,0))),
  (3, 1, 4, 1.4, 1.4, 0, 0, 0, 1, ST_MakeLine(ST_Point(0,0), ST_Point(0,1))),
  (4, 4, 3, 1.0, 1.0, 0, 1, 2, 0, ST_MakeLine(ST_Point(0,1), ST_Point(2,0))),
  (5, 2, 5, 1.0, 1.0, 1, 0, 1, 1, ST_MakeLine(ST_Point(1,0), ST_Point(1,1))),
  (6, 5, 6, 1.0, 1.0, 1, 1, 2, 1, ST_MakeLine(ST_Point(1,1), ST_Point(2,1))),
  (7, 6, 3, 1.0, 1.0, 2, 1, 2, 0, ST_MakeLine(ST_Point(2,1), ST_Point(2,0))),
  (8, 4, 5, 1.0, 1.0, 0, 1, 1, 1, ST_MakeLine(ST_Point(0,1), ST_Point(1,1)));

WITH reachable AS (
  SELECT dd.node
  FROM pgr_drivingDistance(
    'SELECT id, source, target, cost, reverse_cost FROM edges',
    1, 2.5, directed := true
  ) AS dd
),
node_points AS (
  SELECT 1::bigint AS id, ST_SetSRID(ST_Point(0,0),3857) AS geom UNION ALL
  SELECT 2, ST_SetSRID(ST_Point(1,0),3857) UNION ALL
  SELECT 3, ST_SetSRID(ST_Point(2,0),3857) UNION ALL
  SELECT 4, ST_SetSRID(ST_Point(0,1),3857) UNION ALL
  SELECT 5, ST_SetSRID(ST_Point(1,1),3857) UNION ALL
  SELECT 6, ST_SetSRID(ST_Point(2,1),3857)
)
SELECT ST_AsText(ST_ConvexHull(ST_Collect(n.geom))) AS approximate_reachable_envelope
FROM reachable r
JOIN node_points n ON n.id = r.node;
