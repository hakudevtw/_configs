#!/usr/bin/env python3
"""Claude Code status line: model | dir | branch | context % | 5h limit %."""
from __future__ import annotations

import json
import os
import subprocess
import sys

DIM, RESET = "\033[2m", "\033[0m"


def color(pct: float) -> str:
    return "\033[31m" if pct >= 80 else "\033[33m" if pct >= 60 else ""


def git(cwd: str, *args: str) -> str:
    r = subprocess.run(["git", "-C", cwd, *args], capture_output=True, text=True, timeout=2)
    return r.stdout.strip() if r.returncode == 0 else ""


def main() -> None:
    d = json.load(sys.stdin)
    cwd = d.get("workspace", {}).get("current_dir") or d.get("cwd") or os.getcwd()
    parts = [d.get("model", {}).get("display_name", ""), os.path.basename(cwd.rstrip("/")) or "/"]

    branch = git(cwd, "branch", "--show-current") or git(cwd, "rev-parse", "--short", "HEAD")
    if branch:
        parts.append(branch + ("*" if git(cwd, "status", "--porcelain") else ""))

    ctx = (d.get("context_window") or {}).get("used_percentage")
    if ctx is not None:
        parts.append(f"{color(ctx)}ctx {ctx:.0f}%{RESET}")

    five = ((d.get("rate_limits") or {}).get("five_hour") or {}).get("used_percentage")
    if five is not None:
        parts.append(f"{color(five)}5h {five:.0f}%{RESET}")

    print(f"{DIM} │ {RESET}".join(p for p in parts if p))


if __name__ == "__main__":
    try:
        main()
    except Exception:  # a broken status line must not print tracebacks
        pass
