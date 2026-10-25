-- Build topology from raw linework. pgr_createTopology populates source/target.
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgrouting;
DROP TABLE IF EXISTS demo_network CASCADE;
CREATE TABLE demo_network (
  id serial PRIMARY KEY,
  cost double precision NOT NULL DEFAULT 1,
  reverse_cost double precision NOT NULL DEFAULT 1,
  source integer,
  target integer,
  geom geometry(LineString, 3857) NOT NULL
);
INSERT INTO demo_network (geom) VALUES
  (ST_GeomFromText('LINESTRING(0 0, 1 0)',3857)),
  (ST_GeomFromText('LINESTRING(1 0, 2 0)',3857)),
  (ST_GeomFromText('LINESTRING(1 0, 1 1)',3857)),
  (ST_GeomFromText('LINESTRING(1 1, 2 1)',3857));
SELECT pgr_createTopology('demo_network', 0.001, 'geom', 'id', 'source', 'target');
SELECT id, source, target, cost, reverse_cost
FROM demo_network
ORDER BY id;
DROP TABLE demo_network CASCADE;
