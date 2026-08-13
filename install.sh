#!/usr/bin/env bash
# install.sh — copy the skills in this repo into a project's agent skills dir.
#
# Usage:
#   ./install.sh <target-project>            # -> <target>/.claude/skills/
#   ./install.sh <target-project> --agents   # -> <target>/.agents/skills/  (also)
#   ./install.sh <target-project> --dir .agents   # pick the convention
#
# Idempotent: re-running replaces the skill folders in place. Every skill under
# skills/<name>/ (one containing SKILL.md) is copied.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

target="${1:-}"
if [ -z "$target" ]; then
  echo "usage: ./install.sh <target-project> [--dir .claude|.agents] [--agents]" >&2
  exit 2
fi
shift

dir=".claude"
also_agents=0
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) dir="${2:?--dir needs a value}"; shift 2 ;;
    --agents) also_agents=1; shift ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

[ -d "$target" ] || { echo "target not found: $target" >&2; exit 1; }

install_into() {
  local base="$1"
  local dst="$target/$base/skills"
  mkdir -p "$dst"
  local n=0
  for s in "$ROOT"/skills/*/; do
    [ -f "$s/SKILL.md" ] || continue
    local name; name="$(basename "$s")"
    rm -rf "$dst/$name"
    cp -R "$s" "$dst/$name"
    echo "installed: $base/skills/$name"
    n=$((n+1))
  done
  [ "$n" -gt 0 ] || { echo "no skills found under $ROOT/skills" >&2; exit 1; }
}

install_into "$dir"
[ "$also_agents" -eq 1 ] && install_into ".agents"

echo "done -> $target"
