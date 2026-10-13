-- Example 09: Service area analysis (which facilities can be reached in X minutes)

-- Create facilities table
CREATE TABLE IF NOT EXISTS facilities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    geom GEOMETRY(POINT, 4326)
);

INSERT INTO facilities (name, type, geom) VALUES
('Hospital', 'health', ST_SetSRID(ST_MakePoint(-80.93, 29.02), 4326)),
('Fire Station', 'safety', ST_SetSRID(ST_MakePoint(-80.92, 29.03), 4326)),
('School', 'education', ST_SetSRID(ST_MakePoint(-80.91, 29.01), 4326));

-- Find all nodes within 5 minutes of Hospital
SELECT * FROM pgr_drivingDistance(
    'SELECT id, source, target, travel_time AS cost, travel_time AS reverse_cost FROM ways',
    (SELECT source FROM ways ORDER BY ways.geom <-> (SELECT geom FROM facilities WHERE name = 'Hospital') LIMIT 1),
    5.0,  -- 5 minutes
    false
);

-- Count reachable nodes by facility
WITH hospital_reach AS (
    SELECT * FROM pgr_drivingDistance(
        'SELECT id, source, target, travel_time AS cost, travel_time AS reverse_cost FROM ways',
        1, 5.0, false
    )
),
fire_reach AS (
    SELECT * FROM pgr_drivingDistance(
        'SELECT id, source, target, travel_time AS cost, travel_time AS reverse_cost FROM ways',
        2, 5.0, false
    )
)
SELECT
    'Hospital' as facility,
    COUNT(*) as nodes_within_5min
FROM hospital_reach
UNION ALL
SELECT
    'Fire Station',
    COUNT(*)
FROM fire_reach;
