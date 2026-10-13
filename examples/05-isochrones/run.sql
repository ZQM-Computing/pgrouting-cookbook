-- Example 05: Isochrone (reachability polygons)
-- Generate polygons showing what's reachable within a cost budget

-- Buffer by driving distance (10 minutes = 600 seconds)
SELECT * FROM pgr_drivingDistance(
    'SELECT id, source, target, cost, reverse_cost FROM ways',
    1, 600, false
);

-- Create isochrone polygon from reachable nodes
WITH reachable AS (
    SELECT * FROM pgr_drivingDistance(
        'SELECT id, source, target, cost, reverse_cost FROM ways',
        1, 600, false
    )
)
SELECT ST_ConvexHull(ST_Collect(ST_MakePoint(x1, y1))) AS isochrone
FROM ways w
JOIN reachable r ON w.id = r.edge;
