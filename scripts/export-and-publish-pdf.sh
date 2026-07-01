#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PDF="public/slides.pdf"

echo "→ Exporting slides to ${PDF}..."
slidev export slides.md --output "$PDF"

echo "→ Staging ${PDF}..."
git add "$PDF"

if git diff --cached --quiet -- "$PDF"; then
  echo "✓ PDF unchanged - nothing to commit or push."
  exit 0
fi

echo "→ Committing PDF update..."
git commit -m "$(cat <<'EOF'
chore: update exported slides PDF

Regenerate public/slides.pdf from the current deck.
EOF
)"

echo "→ Pushing to origin..."
git push origin HEAD

echo "✓ Published ${PDF}"
