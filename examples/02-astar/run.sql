-- Example 02: A* search (heuristic)
-- A* uses Euclidean distance heuristic for faster search

-- Same setup as dijkstra example

-- A* search from node 1 to node 4
SELECT * FROM pgr_astar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
    1, 4, false
);

-- A* with a bounding box (limits search area)
SELECT * FROM pgr_astar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
    1, 4, false,
    -80.95, 28.95, -80.90, 29.05
);
