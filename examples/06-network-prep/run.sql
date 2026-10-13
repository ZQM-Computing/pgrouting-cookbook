-- Example 06: Network topology preparation
-- Prepare raw line data for pgRouting

-- 1. Create table with source/target columns
CREATE TABLE IF NOT EXISTS network_edges (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    geom GEOMETRY(LINESTRING, 4326)
);

-- 2. Insert sample data
INSERT INTO network_edges (name, geom) VALUES
('Road A', ST_GeomFromText('LINESTRING(-80.93 29.02, -80.92 29.03)', 4326)),
('Road B', ST_GeomFromText('LINESTRING(-80.92 29.03, -80.91 29.01)', 4326));

-- 3. Create topology (assigns source/target based on geometry intersection)
SELECT pgr_createTopology('network_edges', 0.0001, 'geom', 'id');

-- 4. Add cost columns
ALTER TABLE network_edges ADD COLUMN IF NOT EXISTS cost FLOAT;
ALTER TABLE network_edges ADD COLUMN IF NOT EXISTS reverse_cost FLOAT;
UPDATE network_edges SET cost = ST_Length(geom::geography);
UPDATE network_edges SET reverse_cost = ST_Length(geom::geography);

-- 5. Verify topology
SELECT pgr_analyzeGraph('network_edges', 0.0001, 'geom', 'id');

-- 6. Check for isolated nodes
SELECT * FROM pgr_analyzeOneway('network_edges', 'geom', 'id');
