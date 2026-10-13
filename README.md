# pgRouting Patterns

Production-tested pgRouting patterns for PostGIS network analysis.

## Who this is for

GIS analysts, logistics planners, and urban planners.

## What's inside

- `examples/` — Runnable SQL scripts with Docker setup
- `tests/` — Validation tests for each pattern

## Patterns

| # | Pattern | Description |
|---|---------|-------------|
| 1 | Dijkstra | Shortest path by cost |
| 2 | A* | Heuristic shortest path |
| 3 | TSP | Traveling Salesman Problem |
| 4 | Driving distance | Cost matrix generation |
| 5 | Isochrone | Reachability polygons |
| 6 | Network prep | Topology preparation |
| 7 | Turn restrictions | No-left-turn, no-u-turn penalties |
| 8 | Multi-criteria | Time + distance + safety routing |
| 9 | Service area | Reachable nodes in X minutes |
| 10 | Waypoint routing | Multi-stop routes |
| 11 | Traffic routing | Time-dependent costs |
| 12 | Geometry export | GeoJSON route export |

## Requirements

- PostgreSQL 15+
- PostGIS 3.4+
- pgRouting 3.6+
- Docker (for examples)

## Quick start

```bash
cd examples/01-dijkstra
docker-compose up -d
psql -f setup.sql
psql -f query.sql
```

## License

MIT — see LICENSE file.
