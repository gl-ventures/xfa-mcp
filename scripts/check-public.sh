#!/usr/bin/env bash
# Fails when a tracked file mentions words that belong to internal tooling.
# This repository is public; see AGENTS.md.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
allow=scripts/check-public-allowlist.txt
pattern='staff|system_admin|system admin|internal|athena|analytics_'
hits=$(git grep -n -I -i -E "$pattern" -- . ':!scripts/check-public.sh' ':!scripts/check-public-allowlist.txt' ':!AGENTS.md' || true)
if [ -n "$hits" ] && [ -s "$allow" ]; then
  hits=$(printf '%s\n' "$hits" | grep -v -F -f "$allow" || true)
fi
if [ -n "$hits" ]; then
  echo "Public-repo check failed. Remove these mentions (see AGENTS.md):" >&2
  printf '%s\n' "$hits" >&2
  exit 1
fi
echo "Public-repo check passed."
