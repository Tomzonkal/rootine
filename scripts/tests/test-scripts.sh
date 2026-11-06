#!/usr/bin/env bash
# Testy skryptów z scripts/: link-meta.sh i check-meta-run.sh.
# Buduje tymczasowe repo z worktree i sprawdza zachowanie z kryteriów akceptacji issue #1.
set -euo pipefail

SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

failures=0
pass() { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; failures=$((failures + 1)); }

# Repo główne z .gitignore jak w projekcie i worktree obok.
git init -q "$TMP/main"
cd "$TMP/main"
printf 'meta/\nmeta\n' > .gitignore
git add .gitignore
git -c user.name=t -c user.email=t@t commit -qm init
git worktree add -q "$TMP/wt" -b wt

# --- check-meta-run.sh ---------------------------------------------------------
cd "$TMP/wt"
if bash "$SCRIPTS/check-meta-run.sh" 7 >/dev/null 2>&1; then
  pass "check-meta-run: 0 bez meta/"
else
  fail "check-meta-run: 0 bez meta/"
fi

mkdir -p "$TMP/main/meta/runs"

# --- link-meta.sh --------------------------------------------------------------
cd "$TMP/main"
bash "$SCRIPTS/link-meta.sh" >/dev/null
if [ -d meta ] && [ ! -L meta ]; then
  pass "link-meta: w głównym checkoucie nic nie zmienia"
else
  fail "link-meta: w głównym checkoucie nic nie zmienia"
fi

cd "$TMP/wt"
bash "$SCRIPTS/link-meta.sh" >/dev/null
if [ -L meta ] && [ "$(cd meta && pwd -P)" = "$(cd "$TMP/main/meta" && pwd -P)" ]; then
  pass "link-meta: tworzy symlink w worktree"
else
  fail "link-meta: tworzy symlink w worktree"
fi

bash "$SCRIPTS/link-meta.sh" >/dev/null
if [ -L meta ] && [ ! -e meta/meta ]; then
  pass "link-meta: drugie wywołanie idempotentne"
else
  fail "link-meta: drugie wywołanie idempotentne"
fi

if [ -z "$(git status --porcelain)" ]; then
  pass "git status czysty z symlinkiem meta"
else
  fail "git status czysty z symlinkiem meta"
fi

if bash "$SCRIPTS/check-meta-run.sh" 7 >/dev/null 2>&1; then
  fail "check-meta-run: 1 gdy meta/ bez wpisu"
else
  pass "check-meta-run: 1 gdy meta/ bez wpisu"
fi

touch "$TMP/main/meta/runs/2026-11-06-issue-17-x.md"
if bash "$SCRIPTS/check-meta-run.sh" 7 >/dev/null 2>&1; then
  fail "check-meta-run: wpis issue-17 nie zalicza issue 7"
else
  pass "check-meta-run: wpis issue-17 nie zalicza issue 7"
fi

touch "$TMP/main/meta/runs/2026-11-06-issue-7-x.md"
if bash "$SCRIPTS/check-meta-run.sh" 7 >/dev/null 2>&1; then
  pass "check-meta-run: 0 z wpisem issue-7"
else
  fail "check-meta-run: 0 z wpisem issue-7"
fi

if bash "$SCRIPTS/check-meta-run.sh" >/dev/null 2>&1; then
  fail "check-meta-run: brak argumentu to błąd"
else
  pass "check-meta-run: brak argumentu to błąd"
fi

echo
if [ "$failures" -gt 0 ]; then
  echo "$failures test(s) failed"
  exit 1
fi
echo "all script tests passed"
