# EXAMPLES-TODO — pgrouting-cookbook

> **Status: GAP, NOT DONE.** This file is a tracker, not a substitute for
> examples. The 12 examples below are promised by README.md, docs/index.md,
> and the repository layout tree, but `examples/` does **not exist** in this
> repo as of the 2026-10-24 investigation. The quickstart command
> `psql -h localhost -U gis -d gis -f examples/01-dijkstra/run.sql`
> currently fails, and `docker-compose.yml` mounts `./examples:/examples`
> from a directory that does not exist, so the compose file is also
> broken by this gap. The "Production-tested" claim in README/docs is
> currently false for that reason. Do not delete this file until every
> item below exists and the test suite passes with examples present.
>
> `tests/test_patterns.py::test_examples_present` intentionally fails
> while this gap is open. It asserts only that `examples/` exists and is
> non-empty; tighten it to exactly 12 files once all 12 below land.

## Promised examples (all MISSING)

| # | Directory | Entry point | What README/docs say it demonstrates |
|---|-----------|-------------|---------------------------------------|
| 01 | `01-dijkstra` | `run.sql` | Shortest path by cost with `pgr_dijkstra` on a synthetic grid network |
| 02 | `02-astar` | `run.sql` | Heuristic shortest path with `pgr_aStar` (Euclidean distance heuristic) |
| 03 | `03-tsp` | `run.sql` | Traveling Salesman: visit all nodes and return with minimum cost |
| 04 | `04-driving-distance` | `run.sql` | Cost matrix from one origin to all reachable nodes (`pgr_drivingDistance`) |
| 05 | `05-isochrones` | `run.sql` | Reachability polygons — what is reachable within a cost budget |
| 06 | `06-network-prep` | `run.sql` | Preparing raw line data: source/target columns and `pgr_createTopology` |
| 07 | `07-turn-restrictions` | `run.sql` | Turn restriction table: no-left-turn / no-u-turn penalties |
| 08 | `08-multi-criteria` | `run.sql` | Routing on time + distance + safety with speed limits and safety scores |
| 09 | `09-service-area` | `run.sql` | Facility coverage: which facilities are reachable within X minutes |
| 10 | `10-waypoint-routing` | `run.sql` | Multi-stop routes through intermediate waypoints in optimal order |
| 11 | `11-traffic-routing` | `run.sql` | Time-dependent costs with a synthetic traffic multiplier table |
| 12 | `12-geometry-export` | `run.sql` | Exporting route geometry as GeoJSON |

## Suggested order

1. `01-dijkstra/run.sql` first — it is the README quickstart example,
   so landing it alone makes the first command a visitor tries actually run.
2. The remaining 11, in table order. Each example is, per README, a single
   self-contained `run.sql`: build a small synthetic network, run the
   pgRouting function, print the result.
3. Then tighten `test_examples_present` to assert exactly 12 `*/run.sql`
   files, and delete this file. A follow-up worth doing separately (not
   in this pass): run the SQL against the docker-compose database in CI
   instead of only grepping for SELECT/CREATE.
