#!/usr/bin/env python3
"""PreToolUse hook for Bash: deny or ask before destructive commands.

deny: recursive rm of /, ~ or $HOME; force push to main/master
ask:  git reset --hard, git clean -f, force push to other branches
Reads the hook JSON on stdin; prints a permissionDecision JSON to block or ask.
"""
from __future__ import annotations

import json
import os
import re
import shlex
import subprocess
import sys

PROTECTED = {"main", "master"}
OPERATORS = {";", "&&", "||", "|", "&", "|&", "(", ")", "{", "}", "\n"}
WRAPPERS = {"sudo", "command", "builtin", "nohup", "time", "env", "exec", "nice"}
SHELLS = {"bash", "sh", "zsh", "dash"}
HOME = os.path.expanduser("~")
DANGEROUS_RM_TARGETS = {
    "/", "/*", "~", "~/", "~/*", "$HOME", "$HOME/", "$HOME/*",
    "${HOME}", "${HOME}/", "${HOME}/*", HOME, HOME + "/", HOME + "/*",
}


def tokenize(cmd: str) -> list[str]:
    try:
        lex = shlex.shlex(cmd, posix=True, punctuation_chars=True)
        lex.whitespace_split = True
        return list(lex)
    except ValueError:  # unbalanced quotes: still inspect what we can
        return re.sub(r"(&&|\|\||[;|&()])", r" \1 ", cmd).split()


def segments(tokens: list[str]) -> list[list[str]]:
    out, cur = [], []
    for t in tokens:
        if t in OPERATORS:
            if cur:
                out.append(cur)
            cur = []
        else:
            cur.append(t)
    if cur:
        out.append(cur)
    return out


def short_flags(args: list[str]) -> str:
    return "".join(a[1:] for a in args if re.fullmatch(r"-[A-Za-z]+", a))


def current_branch(cwd: str, git_dir: str | None) -> str:
    try:
        r = subprocess.run(
            ["git", "-C", git_dir or cwd, "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True, text=True, timeout=5,
        )
        return r.stdout.strip()
    except Exception:
        return ""


def check_rm(args: list[str]):
    flags = short_flags(args)
    recursive = "r" in flags or "R" in flags or "--recursive" in args
    if recursive and any(a in DANGEROUS_RM_TARGETS for a in args if not a.startswith("-")):
        return "deny", "recursive rm of /, ~ or $HOME"
    return None


def check_git(args: list[str], cwd: str):
    git_dir, i = None, 0
    while i < len(args) and args[i].startswith("-"):  # skip global options
        if args[i] == "-C" and i + 1 < len(args):
            git_dir = args[i + 1]
        i += 2 if args[i] in ("-C", "-c", "--git-dir", "--work-tree", "--namespace") else 1
    if i >= len(args):
        return None
    sub, rest = args[i], args[i + 1:]
    flags = short_flags(rest)

    if sub == "reset" and "--hard" in rest:
        return "ask", "git reset --hard discards uncommitted work"
    if sub == "clean" and ("f" in flags or "--force" in rest):
        return "ask", "git clean -f deletes untracked files"
    if sub == "push":
        forced = "f" in flags or any(
            a in ("--force", "--force-if-includes") or a.startswith("--force-with-lease")
            for a in rest
        )
        positional = [a for a in rest if not a.startswith("-")]
        refspecs = positional[1:]  # first positional is the remote
        forced = forced or any(r.startswith("+") for r in refspecs)
        if not forced:
            return None
        if "--all" in rest or "--mirror" in rest:
            return "deny", "force push with --all/--mirror includes main/master"
        targets = {re.sub(r"^refs/heads/", "", r.lstrip("+").split(":")[-1]) for r in refspecs}
        if not targets:
            targets = {current_branch(cwd, git_dir)}
        if targets & PROTECTED:
            return "deny", "force push to main/master"
        return "ask", "force push rewrites remote history"
    return None


def check(cmd: str, cwd: str, depth: int = 0):
    """Return (decision, reason) for the strictest finding, or None."""
    findings = []
    if depth > 3:
        return None
    for inner in re.findall(r"\$\(([^()]*)\)|`([^`]*)`", cmd):
        for sub in inner:
            if sub:
                findings.append(check(sub, cwd, depth + 1))
    for seg in segments(tokenize(cmd)):
        while seg and (re.fullmatch(r"[A-Za-z_]\w*=.*", seg[0]) or seg[0] in WRAPPERS):
            seg = seg[1:]
        if not seg:
            continue
        prog, args = os.path.basename(seg[0]), seg[1:]
        if prog in SHELLS and "-c" in args and args.index("-c") + 1 < len(args):
            findings.append(check(args[args.index("-c") + 1], cwd, depth + 1))
        elif prog == "eval":
            findings.append(check(" ".join(args), cwd, depth + 1))
        elif prog == "rm":
            findings.append(check_rm(args))
        elif prog == "git":
            findings.append(check_git(args, cwd))
    findings = [f for f in findings if f]
    for level in ("deny", "ask"):
        for f in findings:
            if f[0] == level:
                return f
    return None


def main() -> None:
    try:
        data = json.load(sys.stdin)
        cmd = data.get("tool_input", {}).get("command", "")
        result = check(cmd, data.get("cwd", os.getcwd()))
    except Exception as e:  # a crashing hook would silently allow everything
        result = ("ask", f"hook error ({type(e).__name__}: {e}); review manually")
    if result:
        decision, reason = result
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": decision,
            "permissionDecisionReason": f"guard-bash: {reason}",
        }}))


if __name__ == "__main__":
    main()
