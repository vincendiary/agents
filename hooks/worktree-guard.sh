#!/usr/bin/env bash
# PreToolUse guard: block Edit/Write that escape the session's git worktree
# into ANOTHER worktree/checkout of the SAME repository (e.g. a subagent in a
# temp worktree writing to the main checkout). Different repositories
# (dotfiles, nested planning stores, /tmp) are allowed — only same-repo
# cross-worktree writes are the failure mode this guards.
set -euo pipefail

input=$(cat)

read -r cwd file_path < <(python3 -c '
import json, sys
d = json.loads(sys.stdin.read() or "{}")
ti = d.get("tool_input") or {}
print(d.get("cwd") or "", ti.get("file_path") or "")
' <<<"$input") || exit 0

[[ -z "$cwd" || -z "$file_path" ]] && exit 0

cwd_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0
cwd_common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0

# Resolve the target's repo from its nearest existing ancestor dir
dir=$(dirname "$file_path")
while [[ ! -d "$dir" && "$dir" != "/" ]]; do dir=$(dirname "$dir"); done
target_root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || exit 0
target_common=$(git -C "$dir" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0

# Same repository (shared .git common dir) but a different worktree -> escape.
if [[ "$target_common" == "$cwd_common" && "$target_root" != "$cwd_root" ]]; then
  echo "BLOCKED: $file_path is in worktree $target_root of the same repository, but your working tree is $cwd_root. Write only inside your own worktree - use paths relative to cwd." >&2
  exit 2
fi
exit 0
