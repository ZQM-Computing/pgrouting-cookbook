-- Example 07: Turn restrictions and costs
-- Setup: docker-compose up -d

-- Add turn restriction table
CREATE TABLE IF NOT EXISTS turn_restrictions (
    id SERIAL PRIMARY KEY,
    source_edge INTEGER,
    target_edge INTEGER,
    restriction_type VARCHAR(20),  -- 'no_left_turn', 'no_right_turn', 'no_u_turn'
    cost_penalty FLOAT DEFAULT 1000.0
);

-- Insert sample restrictions
INSERT INTO turn_restrictions (source_edge, target_edge, restriction_type, cost_penalty)
VALUES
    (1, 3, 'no_left_turn', 500.0),
    (2, 4, 'no_u_turn', 1000.0),
    (3, 1, 'no_right_turn', 300.0);

-- Find path avoiding no-left-turn
SELECT * FROM pgr_dijkstra(
    'SELECT id, source, target, cost, reverse_cost FROM ways',
    1, 4, false
);

-- Find path with turn penalties (higher cost for restricted turns)
SELECT * FROM pgr_dijkstra(
    'SELECT w.id, w.source, w.target,
            w.cost + COALESCE(tr.cost_penalty, 0) AS cost,
            w.reverse_cost + COALESCE(tr.cost_penalty, 0) AS reverse_cost
     FROM ways w
     LEFT JOIN turn_restrictions tr ON w.id = tr.target_edge',
    1, 4, false
);
