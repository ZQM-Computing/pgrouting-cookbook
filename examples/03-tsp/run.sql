-- Example 03: Traveling Salesman Problem
-- Visit all nodes and return to start with minimum cost

-- Create a small set of nodes
CREATE TABLE IF NOT EXISTS tsp_points (
    id SERIAL PRIMARY KEY,
    x FLOAT,
    y FLOAT
);

INSERT INTO tsp_points (x, y) VALUES
(-80.93, 29.02), (-80.92, 29.03), (-80.91, 29.01), (-80.90, 29.00);

-- Solve TSP (uses nearest neighbor + 2-opt improvement)
SELECT * FROM pgr_TSP(
    'SELECT id, x, y FROM tsp_points',
    1
);
