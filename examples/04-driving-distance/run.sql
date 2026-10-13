-- Example 04: Driving distance matrix
-- Calculate cost from one origin to all reachable nodes

-- Driving distance from node 1 to all nodes within 500 cost units
SELECT * FROM pgr_drivingDistance(
    'SELECT id, source, target, cost, reverse_cost FROM ways',
    1, 500, false
);

-- Cost matrix: all pairs shortest path
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost FROM ways',
    (SELECT array_agg(source) FROM ways)
);
