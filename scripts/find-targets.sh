#!/bin/bash
# find-targets.sh — Find businesses with outdated websites using Brave Search API
# Usage: ./find-targets.sh "dentist" "chicago" 15

set -e

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

NICHE="${1:-dentist}"
CITY="${2:-chicago}"
LIMIT="${3:-15}"

# Load Brave Search API key
SECRETS_DIR="$HOME/.openclaw/workspace/.secrets"
if [ -f "$SECRETS_DIR/brave-search-api-key.txt" ]; then
  BRAVE_API_KEY=$(cat "$SECRETS_DIR/brave-search-api-key.txt" | tr -d '[:space:]')
fi

if [ -z "$BRAVE_API_KEY" ]; then
  echo "❌ BRAVE_API_KEY not found in $SECRETS_DIR/brave-search-api-key.txt"
  exit 1
fi

OUTPUT_FILE="targets_${NICHE// /_}_${CITY// /_}.json"
RESULTS_FILE="targets_${NICHE// /_}_${CITY// /_}_results.md"

echo "🔍 Searching for $NICHE businesses in $CITY..."
echo ""

# Search queries to find businesses (multiple queries for more results)
QUERIES=(
  "$NICHE $CITY"
  "best $NICHE in $CITY"
  "$NICHE near $CITY site:yelp.com OR site:yellowpages.com"
)

ALL_URLS=()

for QUERY in "${QUERIES[@]}"; do
  echo "  → Query: $QUERY"

  RESPONSE=$(curl -s "https://api.search.brave.com/res/v1/web/search?q=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote('$QUERY'))")&count=10&country=us" \
    -H "Accept: application/json" \
    -H "Accept-Encoding: gzip" \
    -H "X-Subscription-Token: $BRAVE_API_KEY")

  # Extract URLs and titles
  RESULTS=$(echo "$RESPONSE" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    results = d.get('web', {}).get('results', [])
    for r in results:
        url = r.get('url', '')
        title = r.get('title', '')
        desc = r.get('description', '')
        # Skip directories — we want actual business sites
        skip = any(s in url for s in ['yelp.com', 'yellowpages.com', 'google.com', 'facebook.com', 'instagram.com', 'linkedin.com', 'bbb.org', 'angi.com', 'homeadvisor.com', 'thumbtack.com'])
        if not skip and url.startswith('http'):
            print(f'{url}|||{title}|||{desc}')
except Exception as e:
    print(f'ERROR: {e}', file=sys.stderr)
" 2>/dev/null || echo "")

  while IFS= read -r line; do
    [ -n "$line" ] && ALL_URLS+=("$line")
  done <<< "$RESULTS"

  sleep 1
done

echo ""
echo "📋 Found ${#ALL_URLS[@]} potential targets. Analyzing..."
echo ""

# Write results
ANALYZED=0
{
echo "# Website Remake Targets — $NICHE in $CITY"
echo "Generated: $(date)"
echo ""
echo "| # | Business | URL | Notes |"
echo "|---|----------|-----|-------|"

for entry in "${ALL_URLS[@]}"; do
  [ $ANALYZED -ge $LIMIT ] && break

  URL=$(echo "$entry" | cut -d'|||' -f1)
  TITLE=$(echo "$entry" | cut -d'|||' -f2)
  DESC=$(echo "$entry" | cut -d'|||' -f3)

  ANALYZED=$((ANALYZED + 1))
  echo "| $ANALYZED | $TITLE | $URL | $DESC |"
done
} > "$RESULTS_FILE"

echo "✅ $ANALYZED targets saved to: $RESULTS_FILE"
echo ""
cat "$RESULTS_FILE"
echo ""
echo "🚀 Next steps:"
echo "  1. Open each URL and score it (design quality, mobile, animations)"
echo "  2. Run: ./scrape-site.sh 'https://WEBSITE_URL' for the best prospects"
echo "  3. Build remake with Claude Code using SKILL.md prompts"
echo "  4. Deploy to Netlify, then: ./send-email.sh --to owner@email.com --url https://PREVIEW.netlify.app"
echo ""
