-- Apply a synthetic traffic multiplier to base edge costs before routing.
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
  (1, 1, 2, 1.0, 1.0, 0, 0, 1, 0, ST_SetSRID(ST_MakeLine(ST_Point(0,0), ST_Point(1,0)),3857)),
  (2, 2, 3, 1.0, 1.0, 1, 0, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(1,0), ST_Point(2,0)),3857)),
  (3, 1, 4, 1.4, 1.4, 0, 0, 0, 1, ST_SetSRID(ST_MakeLine(ST_Point(0,0), ST_Point(0,1)),3857)),
  (4, 4, 3, 1.0, 1.0, 0, 1, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(0,1), ST_Point(2,0)),3857)),
  (5, 2, 5, 1.0, 1.0, 1, 0, 1, 1, ST_SetSRID(ST_MakeLine(ST_Point(1,0), ST_Point(1,1)),3857)),
  (6, 5, 6, 1.0, 1.0, 1, 1, 2, 1, ST_SetSRID(ST_MakeLine(ST_Point(1,1), ST_Point(2,1)),3857)),
  (7, 6, 3, 1.0, 1.0, 2, 1, 2, 0, ST_SetSRID(ST_MakeLine(ST_Point(2,1), ST_Point(2,0)),3857)),
  (8, 4, 5, 1.0, 1.0, 0, 1, 1, 1, ST_SetSRID(ST_MakeLine(ST_Point(0,1), ST_Point(1,1)),3857));

CREATE TEMP TABLE traffic (edge_id bigint PRIMARY KEY, multiplier double precision NOT NULL);
INSERT INTO traffic VALUES (1, 1.0), (2, 2.5), (3, 1.0), (4, 1.8),
                          (5, 1.2), (6, 1.0), (7, 2.0), (8, 1.1);
CREATE TEMP TABLE traffic_edges AS 
  SELECT e.id, e.source, e.target,
         e.cost * t.multiplier AS cost,
         e.reverse_cost * t.multiplier AS reverse_cost
  FROM edges e JOIN traffic t ON t.edge_id = e.id;
SELECT seq, path_seq, node, edge, cost, agg_cost
FROM pgr_dijkstra(
  'SELECT id, source, target, cost, reverse_cost FROM traffic_edges',
  1, 3, directed := true
)
ORDER BY seq;
