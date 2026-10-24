# pgRouting Patterns

<!-- ZQM-START -->
<!-- markdownlint-disable MD033 -->
<p align="center">
  <strong>ZQM Computing — Geospatial Engineering & Scientific Computing</strong><br>
  <a href="https://github.com/ZQM-Computing">ZQM Computing</a> •
  <a href="https://github.com/ZQM-Labs">ZQM Labs</a>
</p>
<!-- markdownlint-enable MD033 -->
<!-- ZQM-END -->

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg) ![GitHub](https://img.shields.io/github/stars/ZQM-Computing/pgrouting-cookbook?style=social)
[![CI](https://github.com/ZQM-Computing/pgrouting-cookbook/actions/workflows/ci.yml/badge.svg)](https://github.com/ZQM-Computing/pgrouting-cookbook/actions/workflows/ci.yml)

Production-tested pgRouting patterns for PostGIS network analysis — shortest paths, driving distances, isochrones, and traffic-aware routing, all on synthetic data you can run locally.

## Repository role and status

**Status:** Active, public.

**What this repository is:** pgRouting patterns for PostGIS network analysis — shortest path, driving distance, isochrones, turn restrictions, and traffic-aware routing, all on synthetic data.

**What it contributes:** Part of the ZQM Computing public geospatial portfolio — production-grade pattern and reference repositories that document geospatial engineering practice across the stack. This repository is the reusable pattern library for its layer: working code and runbooks that practitioners can lift into their own pipelines, and portfolio evidence of the engineering practice behind ZQM Computing. The umbrella index for the series is [geospatial-cookbooks](https://github.com/ZQM-Computing/geospatial-cookbooks).

**Standing:** The portfolio program was completed and Tier-1 hardened on 2026-10-15, with prose CI enforced as required status checks. This repository is standalone — no other repository or deployment depends on it.

## Who this is for

GIS analysts, logistics planners, and anyone who needs routing answers out of a PostGIS database: pgRouting turns a table of road segments into a routable network, and these patterns show the queries that matter in production.

## Prerequisites

- Docker and Docker Compose (recommended — the repo ships a `docker-compose.yml` with PostgreSQL 15, PostGIS 3.4, and pgRouting 3.6.0), or
- Your own PostgreSQL 15+ with PostGIS 3.4+ and pgRouting 3.6+
- `psql` client

## Quickstart

```bash
# Start the database (credentials are in docker-compose.yml)
docker compose up -d

# Run the Dijkstra example against it
psql -h localhost -U gis -d gis -f examples/01-dijkstra/run.sql
```

Each example is a single self-contained `run.sql`: it builds a small synthetic network, runs the pgRouting function, and prints the result. Point `psql` at any example directory's `run.sql` to try it.

## Usage

Each pattern is a self-contained, runnable example. Start from the
[Quickstart](#quickstart), then open any entry in the [Patterns](#patterns)
list and run it end to end. Copy the pattern into your own project and
swap in your data — the patterns are reference implementations, not a
package to install.

## Patterns

| # | Example | What it demonstrates |
|---|---------|----------------------|
| 01 | `01-dijkstra` | Shortest path by cost with `pgr_dijkstra` on a synthetic grid network |
| 02 | `02-astar` | Heuristic shortest path with `pgr_aStar` (Euclidean distance heuristic) |
| 03 | `03-tsp` | Traveling Salesman: visit all nodes and return with minimum cost |
| 04 | `04-driving-distance` | Cost matrix from one origin to all reachable nodes (`pgr_drivingDistance`) |
| 05 | `05-isochrones` | Reachability polygons — what is reachable within a cost budget |
| 06 | `06-network-prep` | Preparing raw line data: source/target columns and `pgr_createTopology` |
| 07 | `07-turn-restrictions` | Turn restriction table: no-left-turn / no-u-turn penalties |
| 08 | `08-multi-criteria` | Routing on time + distance + safety with speed limits and safety scores |
| 09 | `09-service-area` | Facility coverage: which facilities are reachable within X minutes |
| 10 | `10-waypoint-routing` | Multi-stop routes through intermediate waypoints in optimal order |
| 11 | `11-traffic-routing` | Time-dependent costs with a synthetic traffic multiplier table |
| 12 | `12-geometry-export` | Exporting route geometry as GeoJSON |

## Repository layout

```text
pgrouting-cookbook/
├── examples/
│   ├── 01-dijkstra/run.sql
│   ├── 02-astar/run.sql
│   └── ... (one run.sql per pattern, 12 total)
├── tests/
│   └── test_patterns.py     # syntax/structure checks for the SQL examples
├── docker-compose.yml       # PostgreSQL 15 + PostGIS 3.4 + pgRouting 3.6.0
├── pyproject.toml
├── README.md
├── LICENSE
└── CONTRIBUTING.md
```

## Validation

```bash
pip install pytest
pytest            # checks every example SQL file for valid syntax
```

CI runs `ruff check` / `ruff format --check` on Python files and the pytest suite on every push and pull request.

## Roadmap

- Contraction hierarchies (`pgr_contraction`) for large-network speedups
- K-shortest paths (`pgr_KSP`) for alternative-route generation
- Real OSM extract walkthrough (download → osm2pgrouting → topology)

## Contributing

See [CONTRIBUTING.md](https://github.com/ZQM-Computing/pgrouting-cookbook/blob/main/CONTRIBUTING.md). Report security issues to <zqmcomputing@gmail.com> — please do not open a public issue for those.

## Related repositories

- [postgis-cookbook](https://github.com/ZQM-Computing/postgis-cookbook) — Production PostGIS patterns: spatial indexing, joins & KNN, SRID management, vector tiles, data quality, partitioning
- [duckdb-spatial-cookbook](https://github.com/ZQM-Computing/duckdb-spatial-cookbook) — DuckDB Spatial patterns for analytical geospatial SQL: GeoParquet, spatial joins, KNN, H3 aggregation — no server required
- [geopandas-cookbook](https://github.com/ZQM-Computing/geopandas-cookbook) — GeoPandas/Shapely patterns for Python geospatial workflows: spatial joins, CRS handling, overlays, interpolation, performance
- [gdal-cookbook](https://github.com/ZQM-Computing/gdal-cookbook) — GDAL/OGR command-line patterns: conversion, reprojection, clipping, mosaicking — production-tested, runnable examples
- [stac-cookbook](https://github.com/ZQM-Computing/stac-cookbook) — STAC patterns for geospatial data discovery: catalogs, item validation, search API, bulk operations, cloud deployment
- [maplibre-cookbook](https://github.com/ZQM-Computing/maplibre-cookbook) — MapLibre GL JS patterns for frontend vector tile rendering: custom layers, 3D terrain, performance tuning, interactive maps
- [cog-cookbook](https://github.com/ZQM-Computing/cog-cookbook) — Cloud Optimized GeoTIFF patterns: creation, validation, TiTiler serving, xarray integration, performance benchmarking
- [geoparquet-cookbook](https://github.com/ZQM-Computing/geoparquet-cookbook) — GeoParquet patterns for columnar geospatial analytics: partitioning, predicate pushdown, DuckDB/Spark integration
- [h3-cookbook](https://github.com/ZQM-Computing/h3-cookbook) — H3 hexagonal grid patterns: indexing, aggregation, visualization, grid comparisons, performance benchmarks
- [qgis-resources](https://github.com/ZQM-Computing/qgis-resources) — QGIS expressions, PyQGIS snippets, Processing scripts, styles, and QField field-collection guides
- [geospatial-api-reference](https://github.com/ZQM-Computing/geospatial-api-reference) — OGC API – Features reference implementation with FastAPI and PostGIS backends
- [ollama-fleet-patterns](https://github.com/ZQM-Computing/ollama-fleet-patterns) — Ollama fleet operations: model management, health checks, load-spreading, VRAM budgeting, dependency-light RAG
- [proxmox-ceph-operations](https://github.com/ZQM-Computing/proxmox-ceph-operations) — Proxmox VE + Ceph operations runbooks: health checks, backup discipline, OSD replacement, upgrade checklists
- [geospatial-cookbooks](https://github.com/ZQM-Computing/geospatial-cookbooks) — Umbrella index for all ZQM geospatial pattern repos

## Documentation and validation

For setup instructions, reproducible examples, data provenance, CRS/SRID assumptions, security guidance, and dependency labels, follow the [ZQM geospatial repository documentation standard](https://github.com/ZQM-Computing/geospatial-cookbooks/blob/main/docs/repository-documentation-standard.md).

The configured CI workflow is the source of truth for automated checks. A passing workflow establishes only that its checks passed for that commit; it does not certify production deployment or prove that every dependency and operating environment was covered.

## Installation

No package to install — the examples are SQL files run against the database in Docker (see Quickstart). The Python validation suite only needs pytest:

```bash
pip install pytest
pytest
```

*Part of [ZQM Computing](https://github.com/ZQM-Computing) — geospatial engineering, scientific computing, and infrastructure patterns; the geospatial arm of [ZQM Labs](https://zqmlabs.com), makers of Z's Quests & Mischief location games.*

## License

MIT — see [LICENSE](LICENSE).

<!-- ZQM-FOOTER-START -->
<!-- markdownlint-disable MD033 -->
---

<p align="center">
  <em>Play more. Plan less.</em><br>
  <a href="https://zqmlabs.com">zqmlabs.com</a> •
  <a href="https://github.com/ZQM-Labs">ZQM Labs</a> •
  <a href="https://github.com/ZQM-Computing">ZQM Computing</a>
</p>
<!-- markdownlint-enable MD033 -->
<!-- ZQM-FOOTER-END -->
