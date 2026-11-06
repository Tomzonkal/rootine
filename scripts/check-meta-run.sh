#!/usr/bin/env bash
# Sprawdza, czy agent zapisał wpis przebiegu w meta/runs/ dla danego issue.
# Użycie: scripts/check-meta-run.sh <numer-issue>
# Exit 0: brak meta/ (kontrybutor z zewnątrz) albo istnieje meta/runs/*-issue-<nr>-*.md.
set -euo pipefail

if [ $# -ne 1 ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "użycie: $0 <numer-issue>" >&2
  exit 2
fi
issue="$1"

root="$(git rev-parse --show-toplevel)"
if [ ! -d "$root/meta" ]; then
  echo "check-meta-run: brak meta/, pomijam"
  exit 0
fi

shopt -s nullglob
entries=("$root"/meta/runs/*-issue-"$issue"-*.md)
if [ ${#entries[@]} -eq 0 ]; then
  echo "check-meta-run: brak wpisu meta/runs/*-issue-$issue-*.md — zapisz przebieg wg meta/_templates/run.md" >&2
  exit 1
fi
echo "check-meta-run: ok (${entries[0]##*/})"
