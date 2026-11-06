#!/usr/bin/env bash
# Udostępnia lokalną bazę wiedzy meta/ (gitignorowaną) w worktree Cezara.
# W worktree tworzy symlink `meta` -> <główny checkout>/meta. Idempotentny.
# W głównym checkoucie i gdy meta/ nie istnieje — nic nie robi.
set -euo pipefail

common_dir="$(git rev-parse --path-format=absolute --git-common-dir)"
main_checkout="$(dirname "$common_dir")"
here="$(git rev-parse --show-toplevel)"

if [ "$(cd "$here" && pwd -P)" = "$(cd "$main_checkout" && pwd -P)" ]; then
  echo "link-meta: główny checkout, pomijam"
  exit 0
fi

if [ ! -d "$main_checkout/meta" ]; then
  echo "link-meta: brak $main_checkout/meta, pomijam"
  exit 0
fi

if [ -L "$here/meta" ] || [ -e "$here/meta" ]; then
  echo "link-meta: $here/meta już istnieje"
  exit 0
fi

ln -s "$main_checkout/meta" "$here/meta"
echo "link-meta: $here/meta -> $main_checkout/meta"
