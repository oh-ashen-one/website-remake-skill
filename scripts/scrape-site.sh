#!/bin/bash
# scrape-site.sh — Analyze a website with Firecrawl (falls back to web_fetch if key missing)
# Usage: ./scrape-site.sh "https://example.com"

set -e

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

URL="${1}"
if [ -z "$URL" ]; then
  echo "❌ Usage: ./scrape-site.sh 'https://example.com'"
  exit 1
fi

# Load secrets
SECRETS_DIR="$HOME/.openclaw/workspace/.secrets"
if [ -f "$SECRETS_DIR/firecrawl.env" ]; then
  source "$SECRETS_DIR/firecrawl.env"
fi
if [ -f "$SECRETS_DIR/firecrawl-api-key.txt" ]; then
  FIRECRAWL_API_KEY=$(cat "$SECRETS_DIR/firecrawl-api-key.txt" | tr -d '[:space:]')
fi

DOMAIN=$(echo "$URL" | sed 's/https\?:\/\///g' | cut -d/ -f1)
SLUG=$(echo "$DOMAIN" | tr '.' '_')
OUTPUT_DIR="/tmp/website-remake-targets/$SLUG"
mkdir -p "$OUTPUT_DIR"

echo "🔍 Analyzing: $URL"
echo ""

# ── Firecrawl scrape (if key available) ──────────────────────────────────────
if [ -n "$FIRECRAWL_API_KEY" ]; then
  echo "🔥 Using Firecrawl..."

  CRAWL_RESPONSE=$(curl -s -X POST "https://api.firecrawl.dev/v1/scrape" \
    -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"url\": \"$URL\",
      \"formats\": [\"markdown\", \"html\"],
      \"includeTags\": [\"title\", \"meta\", \"h1\", \"h2\", \"h3\", \"p\", \"a\", \"img\", \"section\"],
      \"actions\": []
    }")

  echo "$CRAWL_RESPONSE" > "$OUTPUT_DIR/firecrawl-raw.json"

  MARKDOWN=$(echo "$CRAWL_RESPONSE" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'data' in d and 'markdown' in d['data']:
    print(d['data']['markdown'])
else:
    print('Firecrawl error: ' + str(d))
" 2>/dev/null || echo "parse error")

  echo "$MARKDOWN" > "$OUTPUT_DIR/content.md"
  echo "✅ Firecrawl content saved: $OUTPUT_DIR/content.md"

else
  echo "⚠️  No FIRECRAWL_API_KEY — using curl fallback (less detail)"
  curl -sL "$URL" -o "$OUTPUT_DIR/raw.html" --max-time 15 2>/dev/null || echo "curl fetch failed"

  # Extract basic text
  cat "$OUTPUT_DIR/raw.html" | \
    python3 -c "
import sys, re
html = sys.stdin.read()
# Strip scripts/styles
html = re.sub(r'<(script|style)[^>]*>.*?</(script|style)>', '', html, flags=re.DOTALL|re.IGNORECASE)
# Strip tags
text = re.sub(r'<[^>]+>', ' ', html)
# Collapse whitespace
text = re.sub(r'\s+', ' ', text).strip()
print(text[:5000])
" > "$OUTPUT_DIR/content.md" 2>/dev/null || echo "parse failed"

  echo "✅ Raw content saved: $OUTPUT_DIR/content.md"
fi

# ── Load Netlify token for deploy commands ────────────────────────────────────
if [ -f "$SECRETS_DIR/netlify.env" ]; then
  source "$SECRETS_DIR/netlify.env"
fi
# Also check memory for known token
# Load Netlify token from secrets — never hardcode
if [ -f "$SECRETS_DIR/netlify-token.txt" ]; then
  NETLIFY_TOKEN=$(cat "$SECRETS_DIR/netlify-token.txt" | tr -d '[:space:]')
fi
if [ -z "$NETLIFY_TOKEN" ]; then
  echo "⚠️  NETLIFY_TOKEN not found in $SECRETS_DIR/netlify-token.txt — deploy step will need manual token"
fi

echo ""
echo "════════════════════════════════════════"
echo "📋 SITE ANALYSIS: $DOMAIN"
echo "════════════════════════════════════════"
echo ""
cat "$OUTPUT_DIR/content.md" | head -100
echo ""
echo "════════════════════════════════════════"
echo ""
echo "📁 Full content: $OUTPUT_DIR/content.md"
echo ""
echo "🚀 Next steps:"
echo "  1. Review content above — extract brand colors, copy, key sections"
echo "  2. Open Claude Code at claude.ai"
echo "  3. Use SKILL.md → 'Build Pipeline' → paste the full-site-rebuild prompt"
echo "  4. Deploy: netlify deploy --dir=./dist --auth=$NETLIFY_TOKEN --prod"
echo "  5. Send outreach: ./send-email.sh --to OWNER_EMAIL --url https://PREVIEW.netlify.app"
echo ""
