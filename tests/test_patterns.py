"""Repository and inventory checks for the pgRouting cookbook."""

from pathlib import Path

ROOT = Path(__file__).parent.parent
EXAMPLES_DIR = ROOT / "examples"
EXPECTED_EXAMPLES = {
    "01-dijkstra",
    "02-astar",
    "03-tsp",
    "04-driving-distance",
    "05-isochrones",
    "06-network-prep",
    "07-turn-restrictions",
    "08-multi-criteria",
    "09-service-area",
    "10-waypoint-routing",
    "11-traffic-routing",
    "12-geometry-export",
}


def test_examples_present():
    """Every example advertised in the README has a non-empty SQL entry point."""
    found = {path.parent.name for path in EXAMPLES_DIR.glob("*/run.sql")}
    assert found == EXPECTED_EXAMPLES, (
        f"Example inventory mismatch. Missing: {sorted(EXPECTED_EXAMPLES - found)}; "
        f"unexpected: {sorted(found - EXPECTED_EXAMPLES)}"
    )
    for name in sorted(EXPECTED_EXAMPLES):
        sql_file = EXAMPLES_DIR / name / "run.sql"
        assert sql_file.read_text(encoding="utf-8").strip(), f"{sql_file} is empty"


def test_sql_examples_contain_queries():
    """Catch empty or obviously non-SQL example files; runtime checks execute them in CI."""
    for sql_file in sorted(EXAMPLES_DIR.glob("*/run.sql")):
        content = sql_file.read_text(encoding="utf-8").upper()
        assert "SELECT" in content, f"No SELECT statement in {sql_file}"
        assert "PGROUTING" in content or "PGR_CREATE TOPOLOGY" in content, (
            f"No pgRouting operation in {sql_file}"
        )



def test_readme_runtime_and_waypoint_claims_match_examples():
    """Documented container versions and waypoint semantics match the source."""
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    compose = (ROOT / "docker-compose.yml").read_text(encoding="utf-8")
    assert "PostGIS 3.5 + pgRouting 3.7.3" in readme
    assert "PostGIS 3.4 + pgRouting 3.6.0" not in readme
    assert "pgrouting/pgrouting:15-3.5-3.7.3" in compose
    waypoint = next(line for line in readme.splitlines() if "`10-waypoint-routing`" in line)
    assert "prescribed waypoint sequence" in waypoint
    assert "optimal order" not in waypoint


def test_readme_exists():
    assert (ROOT / "README.md").exists()


def test_license_exists():
    assert (ROOT / "LICENSE").exists()
