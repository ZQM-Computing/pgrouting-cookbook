-- Weighted routing cost: travel time plus a configurable safety penalty.
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
  geom geometry(LineString, 3857) NOT NULL, speed_kph double precision NOT NULL, safety_penalty double precision NOT NULL
);

INSERT INTO edges (id, source, target, cost, reverse_cost, x1, y1, x2, y2, geom, speed_kph, safety_penalty) VALUES
  (1, 1, 2, 1.0, 1.0, 0, 0, 1, 0, ST_MakeLine(ST_Point(0,0), ST_Point(1,0)), 40, 0.1),
  (2, 2, 3, 1.0, 1.0, 1, 0, 2, 0, ST_MakeLine(ST_Point(1,0), ST_Point(2,0)), 30, 0.4),
  (3, 1, 4, 1.4, 1.4, 0, 0, 0, 1, ST_MakeLine(ST_Point(0,0), ST_Point(0,1)), 50, 0.2),
  (4, 4, 3, 1.0, 1.0, 0, 1, 2, 0, ST_MakeLine(ST_Point(0,1), ST_Point(2,0)), 25, 0.1),
  (5, 2, 5, 1.0, 1.0, 1, 0, 1, 1, ST_MakeLine(ST_Point(1,0), ST_Point(1,1)), 35, 0.2),
  (6, 5, 6, 1.0, 1.0, 1, 1, 2, 1, ST_MakeLine(ST_Point(1,1), ST_Point(2,1)), 45, 0.1),
  (7, 6, 3, 1.0, 1.0, 2, 1, 2, 0, ST_MakeLine(ST_Point(2,1), ST_Point(2,0)), 20, 0.5),
  (8, 4, 5, 1.0, 1.0, 0, 1, 1, 1, ST_MakeLine(ST_Point(0,1), ST_Point(1,1)), 30, 0.1);

WITH weighted_edges AS (
  SELECT id, source, target,
         (cost / GREATEST(speed_kph, 1.0)) * 60.0 + safety_penalty AS cost,
         (reverse_cost / GREATEST(speed_kph, 1.0)) * 60.0 + safety_penalty AS reverse_cost
  FROM edges
)
SELECT seq, path_seq, node, edge, cost, agg_cost
FROM pgr_dijkstra(
  'SELECT id, source, target, cost, reverse_cost FROM weighted_edges',
  1, 3, directed := true
)
ORDER BY seq;
