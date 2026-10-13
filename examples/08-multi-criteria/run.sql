-- Example 08: Multi-criteria routing (time + distance + safety)

-- Add safety score to edges
ALTER TABLE ways ADD COLUMN IF NOT EXISTS safety_score FLOAT DEFAULT 1.0;
UPDATE ways SET safety_score = CASE
    WHEN name LIKE '%Main%' THEN 0.9
    WHEN name LIKE '%Highway%' THEN 0.7
    WHEN name LIKE '%Residential%' THEN 0.95
    ELSE 0.85
END;

-- Add speed limit
ALTER TABLE ways ADD COLUMN IF NOT EXISTS speed_limit INT DEFAULT 30;
UPDATE ways SET speed_limit = CASE
    WHEN name LIKE '%Main%' THEN 45
    WHEN name LIKE '%Highway%' THEN 65
    WHEN name LIKE '%Residential%' THEN 25
    ELSE 35
END;

-- Calculate travel time (minutes)
ALTER TABLE ways ADD COLUMN IF NOT EXISTS travel_time FLOAT;
UPDATE ways SET travel_time = (length_m / 1000.0) / speed_limit * 60;

-- Multi-criteria cost: time + distance penalty + safety penalty
SELECT * FROM pgr_dijkstra(
    'SELECT id, source, target,
            travel_time + (length_m * 0.001) + ((1 - safety_score) * 10) AS cost,
            travel_time + (length_m * 0.001) + ((1 - safety_score) * 10) AS reverse_cost
     FROM ways',
    1, 4, false
);

-- Compare: fastest vs safest vs shortest
SELECT 'fastest' as criteria, * FROM pgr_dijkstra(
    'SELECT id, source, target, travel_time AS cost, travel_time AS reverse_cost FROM ways',
    1, 4, false
)
UNION ALL
SELECT 'shortest' as criteria, * FROM pgr_dijkstra(
    'SELECT id, source, target, length_m AS cost, length_m AS reverse_cost FROM ways',
    1, 4, false
)
UNION ALL
SELECT 'safest' as criteria, * FROM pgr_dijkstra(
    'SELECT id, source, target,
            (1 - safety_score) * 100 AS cost,
            (1 - safety_score) * 100 AS reverse_cost
     FROM ways',
    1, 4, false
);
