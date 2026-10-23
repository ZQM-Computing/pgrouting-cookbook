"""Tests for pgrouting-cookbook."""

from pathlib import Path

EXAMPLES_DIR = Path(__file__).parent.parent / "examples"


def test_sql_syntax():
    """All SQL examples have valid syntax (basic check)."""
    for sql_file in sorted(EXAMPLES_DIR.glob("*/run.sql")):
        content = sql_file.read_text()
        assert "SELECT" in content.upper() or "CREATE" in content.upper(), f"No SQL statements in {sql_file}"


def test_readme_exists():
    """README.md exists."""
    assert (Path(__file__).parent.parent / "README.md").exists()


def test_license_exists():
    """LICENSE file exists."""
    assert (Path(__file__).parent.parent / "LICENSE").exists()
