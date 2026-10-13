-- Example 10: Route with intermediate waypoints
-- Visit multiple stops in optimal order

-- Create waypoints
CREATE TABLE IF NOT EXISTS waypoints (
    seq INTEGER PRIMARY KEY,
    name VARCHAR(100),
    node_id INTEGER
);

INSERT INTO waypoints (seq, name, node_id) VALUES
(1, 'Start', 1),
(2, 'Pickup A', 3),
(3, 'Pickup B', 5),
(4, 'Destination', 4);

-- Route through all waypoints in sequence
WITH route AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT id, source, target, cost, reverse_cost FROM ways',
        (SELECT node_id FROM waypoints WHERE seq = 1),
        (SELECT node_id FROM waypoints WHERE seq = 2),
        false
    )
    UNION ALL
    SELECT * FROM pgr_dijkstra(
        'SELECT id, source, target, cost, reverse_cost FROM ways',
        (SELECT node_id FROM waypoints WHERE seq = 2),
        (SELECT node_id FROM waypoints WHERE seq = 3),
        false
    )
    UNION ALL
    SELECT * FROM pgr_dijkstra(
        'SELECT id, source, target, cost, reverse_cost FROM ways',
        (SELECT node_id FROM waypoints WHERE seq = 3),
        (SELECT node_id FROM waypoints WHERE seq = 4),
        false
    )
)
SELECT seq, node, edge, cost, agg_cost
FROM route
ORDER BY seq, agg_cost;

-- Optimize waypoint order (TSP)
SELECT * FROM pgr_TSP(
    'SELECT seq as id, node_id as x, 0 as y FROM waypoints',
    1
);
