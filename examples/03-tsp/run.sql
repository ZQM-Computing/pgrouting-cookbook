-- A small complete cost matrix illustrates a TSP tour. Costs are synthetic.
CREATE EXTENSION IF NOT EXISTS pgrouting;
WITH cost_matrix AS (
  SELECT * FROM (VALUES
    (1::bigint, 2::bigint, 4.0::float8),
    (1, 3, 2.0), (1, 4, 5.0),
    (2, 1, 4.0), (2, 3, 3.0), (2, 4, 2.0),
    (3, 1, 2.0), (3, 2, 3.0), (3, 4, 4.0),
    (4, 1, 5.0), (4, 2, 2.0), (4, 3, 4.0)
  ) AS m(start_vid, end_vid, agg_cost)
)
SELECT seq, node, cost, agg_cost
FROM pgr_TSP(
  'SELECT start_vid, end_vid, agg_cost FROM (VALUES
    (1::bigint, 2::bigint, 4.0::float8),
    (1, 3, 2.0), (1, 4, 5.0),
    (2, 1, 4.0), (2, 3, 3.0), (2, 4, 2.0),
    (3, 1, 2.0), (3, 2, 3.0), (3, 4, 4.0),
    (4, 1, 5.0), (4, 2, 2.0), (4, 3, 4.0)
  ) AS m(start_vid, end_vid, agg_cost)',
  start_id := 1
)
ORDER BY seq;
