#!/usr/bin/env bash
# new-post.sh — Create a Hugo post directory from a JPG image.
# Usage: ./new-post.sh <image.jpg> [output-base-dir]

set -euo pipefail

# ── Arguments ────────────────────────────────────────────────────────────────
IMAGE="${1:-}"
BASE_DIR="${2:-.}"

if [[ -z "$IMAGE" ]]; then
    echo "Usage: $0 <image.jpg> [output-base-dir]" >&2
    exit 1
fi

if [[ ! -f "$IMAGE" ]]; then
    echo "Error: file not found: $IMAGE" >&2
    exit 1
fi

# ── Derive names ──────────────────────────────────────────────────────────────
FILENAME="$(basename "$IMAGE")"           # e.g. my-painting.jpg
STEM="${FILENAME%.*}"                     # e.g. my-painting

# Human-readable title: replace hyphens/underscores with spaces
TITLE="$(echo "$STEM" | sed 's/[-_]/ /g')"

# Slug: transliterate Cyrillic → Latin, then normalise.
SLUG="$(python3 - "$STEM" <<'PYEOF'
import sys, re

BG = {
    'а':'a',  'б':'b',  'в':'v',  'г':'g',  'д':'d',
    'е':'e',  'ж':'zh', 'з':'z',  'и':'i',  'й':'y',
    'к':'k',  'л':'l',  'м':'m',  'н':'n',  'о':'o',
    'п':'p',  'р':'r',  'с':'s',  'т':'t',  'у':'u',
    'ф':'f',  'х':'h',  'ц':'ts', 'ч':'ch', 'ш':'sh',
    'щ':'sht','ъ':'a',  'ь':'y',  'ю':'yu', 'я':'ya',
}
# Build a table that covers both lower and upper Cyrillic
TABLE = {ord(k): v for k, v in BG.items()}
TABLE.update({ord(k.upper()): v for k, v in BG.items()})

s = sys.argv[1]
s = s.translate(TABLE)                 # Cyrillic → Latin
s = s.lower()                          # lowercase the result
s = re.sub(r'[\s_]+', '-', s)         # spaces/underscores → hyphens
s = re.sub(r'[^a-z0-9-]', '', s)      # strip anything non-ASCII
s = re.sub(r'-+', '-', s).strip('-')  # collapse duplicate hyphens
print(s)
PYEOF
)"

# ── Create directory structure ────────────────────────────────────────────────
POST_DIR="$BASE_DIR/$STEM"
IMG_DIR="$POST_DIR/images"

mkdir -p "$IMG_DIR"

# Copy image as featured.jpg
cp "$IMAGE" "$IMG_DIR/featured.jpg"

# ── Write index.md ────────────────────────────────────────────────────────────
cat > "$POST_DIR/index.md" <<EOF
---
title: '$TITLE'
slug: '$SLUG'
tags: []
summary: 
description: # This is what will be displayed as meta description (the theme will automatically grab it from summary if left empty)
expiryDate: ''
translationKey:
draft: false
type: # This is here for future possible development, you can leave it blank
layout: 'single'
---
\`\`\`
$TITLE
\`\`\`
EOF

# ── Done ──────────────────────────────────────────────────────────────────────
echo "Created post:"
echo "  $POST_DIR/index.md"
echo "  $IMG_DIR/featured.jpg"
