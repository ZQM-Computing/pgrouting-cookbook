"""Tests for pgrouting-cookbook."""

from pathlib import Path

EXAMPLES_DIR = Path(__file__).parent.parent / "examples"


def test_examples_present():
    """Examples directory exists and contains at least one runnable example.

    This test exists because the example-syntax test below is vacuous when
    examples/ is absent (glob yields zero files). It intentionally asserts
    only existence + non-emptiness, NOT the full advertised count of 12:
    see EXAMPLES-TODO.md for the 12 promised examples, which do not exist
    yet. Tighten this to == 12 once they land.
    """
    assert EXAMPLES_DIR.is_dir(), "examples/ directory is missing"
    found = sorted(EXAMPLES_DIR.glob("*/run.sql"))
    assert found, "examples/ contains no */run.sql files"


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
