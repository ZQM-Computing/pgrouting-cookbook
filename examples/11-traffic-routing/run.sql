-- Example 11: Traffic-aware routing with time-dependent costs

-- Add traffic multiplier table
CREATE TABLE IF NOT EXISTS traffic_patterns (
    edge_id INTEGER,
    hour_of_day INTEGER,
    day_of_week INTEGER,  -- 0=Sunday, 6=Saturday
    multiplier FLOAT
);

-- Insert synthetic traffic data (rush hour = higher cost)
INSERT INTO traffic_patterns (edge_id, hour_of_day, day_of_week, multiplier)
SELECT
    id,
    h.hour,
    d.day,
    CASE
        WHEN h.hour BETWEEN 7 AND 9 THEN 2.0   -- morning rush
        WHEN h.hour BETWEEN 17 AND 19 THEN 2.5 -- evening rush
        WHEN h.hour BETWEEN 22 AND 6 THEN 0.8  -- night (faster)
        ELSE 1.0
    END
FROM ways w
CROSS JOIN generate_series(0, 23) AS h(hour)
CROSS JOIN generate_series(0, 6) AS d(day)
WHERE d.day BETWEEN 1 AND 5;  -- weekdays only

-- Query: route at 8 AM (rush hour)
SELECT * FROM pgr_dijkstra(
    'SELECT w.id, w.source, w.target,
            w.cost * COALESCE(tp.multiplier, 1.0) AS cost,
            w.reverse_cost * COALESCE(tp.multiplier, 1.0) AS reverse_cost
     FROM ways w
     LEFT JOIN traffic_patterns tp ON w.id = tp.edge_id
        AND tp.hour_of_day = 8 AND tp.day_of_day = 2',
    1, 4, false
);

-- Compare: 8 AM vs 10 AM
SELECT '8 AM (rush)' as time, SUM(cost) as total_cost
FROM pgr_dijkstra(
    'SELECT w.id, w.source, w.target,
            w.cost * COALESCE(tp.multiplier, 1.0) AS cost,
            w.reverse_cost * COALESCE(tp.multiplier, 1.0) AS reverse_cost
     FROM ways w
     LEFT JOIN traffic_patterns tp ON w.id = tp.edge_id
        AND tp.hour_of_day = 8 AND tp.day_of_day = 2',
    1, 4, false
)
UNION ALL
SELECT '10 AM (normal)', SUM(cost)
FROM pgr_dijkstra(
    'SELECT w.id, w.source, w.target,
            w.cost * COALESCE(tp.multiplier, 1.0) AS cost,
            w.reverse_cost * COALESCE(tp.multiplier, 1.0) AS reverse_cost
     FROM ways w
     LEFT JOIN traffic_patterns tp ON w.id = tp.edge_id
        AND tp.hour_of_day = 10 AND tp.day_of_day = 2',
    1, 4, false
);
