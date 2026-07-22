#!/usr/bin/env python3
"""Bump or sync GoldenGreenFC version across VERSION, package.json, README, script.js, index.html."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read_version() -> str:
    return (ROOT / "VERSION").read_text(encoding="utf-8").strip()


def bump(version: str, kind: str) -> str:
    major, minor, patch = (int(x) for x in version.split("."))
    if kind == "major":
        return f"{major + 1}.0.0"
    if kind == "minor":
        return f"{major}.{minor + 1}.0"
    return f"{major}.{minor}.{patch + 1}"


def write_version(version: str) -> None:
    (ROOT / "VERSION").write_text(version + "\n", encoding="utf-8")

    pkg_path = ROOT / "package.json"
    pkg = json.loads(pkg_path.read_text(encoding="utf-8"))
    pkg["version"] = version
    pkg_path.write_text(json.dumps(pkg, indent=2) + "\n", encoding="utf-8")

    readme = ROOT / "README.md"
    text = readme.read_text(encoding="utf-8")
    text = re.sub(r"(\*\*Version:\*\*\s*)\d+\.\d+\.\d+", rf"\g<1>{version}", text, count=1)
    readme.write_text(text, encoding="utf-8")

    script = ROOT / "script.js"
    s = script.read_text(encoding="utf-8")
    s = re.sub(r'(const VERSION = ")[^"]+(")', rf"\g<1>{version}\g<2>", s, count=1)
    script.write_text(s, encoding="utf-8")

    index = ROOT / "index.html"
    html = index.read_text(encoding="utf-8")
    html = re.sub(r"(data-version)>v?\d+\.\d+\.\d+", rf"\1>v{version}", html)
    index.write_text(html, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "kind",
        nargs="?",
        default="patch",
        choices=("patch", "minor", "major"),
        help="Semver bump kind (ignored with --sync-only)",
    )
    parser.add_argument(
        "--sync-only",
        action="store_true",
        help="Rewrite versioned files from VERSION without bumping",
    )
    parser.add_argument(
        "--set",
        metavar="X.Y.Z",
        help="Set an explicit version instead of bumping",
    )
    args = parser.parse_args()

    current = read_version()
    if args.set:
        next_v = args.set
    elif args.sync_only:
        next_v = current
    else:
        next_v = bump(current, args.kind)

    write_version(next_v)
    print(next_v)


if __name__ == "__main__":
    main()
