-- Example 01: Dijkstra shortest path
-- Requires: PostgreSQL + PostGIS + pgRouting
-- Setup: docker-compose up -d

-- Create sample network topology
CREATE TABLE IF NOT EXISTS ways (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    length_m FLOAT,
    cost FLOAT,
    reverse_cost FLOAT,
    geom GEOMETRY(LINESTRING, 4326)
);

-- Insert sample data (synthetic grid network)
INSERT INTO ways (name, length_m, cost, reverse_cost, geom) VALUES
('Main St', 100, 100, 100, ST_GeomFromText('LINESTRING(-80.93 29.02, -80.92 29.03)', 4326)),
('Oak Ave', 80, 80, 80, ST_GeomFromText('LINESTRING(-80.92 29.03, -80.91 29.01)', 4326)),
('Pine Rd', 120, 120, 120, ST_GeomFromText('LINESTRING(-80.93 29.02, -80.91 29.01)', 4326)),
('Elm St', 90, 90, 90, ST_GeomFromText('LINESTRING(-80.91 29.01, -80.90 29.00)', 4326));

-- Build topology
SELECT pgr_createTopology('ways', 0.0001, 'geom', 'id');

-- Find shortest path from node 1 to node 4
SELECT * FROM pgr_dijkstra(
    'SELECT id, source, target, cost, reverse_cost FROM ways',
    1, 4, false
);
