#!/bin/bash
# run-pipeline.sh — Master orchestrator: find targets → scrape → build → email
# Usage: ./run-pipeline.sh --niche "dentist" --city "chicago" --limit 3 --sender-name "Alex"

set -e

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

# ── Parse arguments ───────────────────────────────────────────────────────────
NICHE="dentist"
CITY="chicago"
LIMIT=3
SENDER_NAME="Alex"
SKIP_EMAIL=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --niche) NICHE="$2"; shift 2 ;;
    --city) CITY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --sender-name) SENDER_NAME="$2"; shift 2 ;;
    --no-email) SKIP_EMAIL=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="/tmp/pipeline-run-$(date +%Y%m%d-%H%M%S).log"

# Tee all output to log
exec > >(tee -a "$LOGFILE") 2>&1

echo "════════════════════════════════════════════════════════════════"
echo "🚀 WEBSITE REMAKE PIPELINE"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  Niche:       $NICHE"
echo "  City:        $CITY"
echo "  Limit:       $LIMIT"
echo "  Sender:      $SENDER_NAME"
echo "  Log:         $LOGFILE"
echo "  Started:     $(date)"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# ── Counters ──────────────────────────────────────────────────────────────────
BUILT=0
EMAILS_SENT=0
FAILED=0
RESULTS=()

# ── Step 1: Find targets ─────────────────────────────────────────────────────
echo "━━━ STEP 1: Finding targets ━━━"
echo ""

cd "$SCRIPT_DIR"
TARGETS_OUTPUT=$("$SCRIPT_DIR/find-targets.sh" "$NICHE" "$CITY" "$LIMIT" 2>&1) || {
  echo "❌ find-targets.sh failed"
  echo "$TARGETS_OUTPUT"
  exit 1
}

echo "$TARGETS_OUTPUT"
echo ""

# Extract URLs from the markdown table output
URLS=()
while IFS= read -r line; do
  # Parse table rows: | # | Business | URL | Notes |
  URL=$(echo "$line" | grep -oE 'https?://[^ |]+' | head -1)
  if [ -n "$URL" ]; then
    URLS+=("$URL")
  fi
done <<< "$TARGETS_OUTPUT"

if [ ${#URLS[@]} -eq 0 ]; then
  echo "❌ No target URLs found. Exiting."
  exit 1
fi

echo "📋 Found ${#URLS[@]} target URLs"
echo ""

# ── Step 2-4: Scrape → Build → Email for each target ─────────────────────────
COUNT=0
for URL in "${URLS[@]}"; do
  COUNT=$((COUNT + 1))
  [ $COUNT -gt $LIMIT ] && break

  DOMAIN=$(echo "$URL" | sed 's|https://||;s|http://||' | cut -d/ -f1)
  SLUG=$(echo "$DOMAIN" | tr '.' '_')
  SCRAPE_DIR="/tmp/website-remake-targets/$SLUG"

  echo ""
  echo "════════════════════════════════════════════════════════════════"
  echo "🎯 TARGET $COUNT/$LIMIT: $DOMAIN"
  echo "════════════════════════════════════════════════════════════════"
  echo ""

  # ── Step 2: Scrape ──────────────────────────────────────────────────────────
  echo "━━━ STEP 2: Scraping $URL ━━━"
  SCRAPE_OK=true
  "$SCRIPT_DIR/scrape-site.sh" "$URL" 2>&1 || {
    echo "⚠️  Scrape failed for $URL — continuing with minimal context"
    SCRAPE_OK=false
    mkdir -p "$SCRAPE_DIR"
    echo "No content scraped. Build a generic premium $NICHE website for $CITY." > "$SCRAPE_DIR/content.md"
  }
  echo ""

  # ── Step 2b: Extract NAP from scraped content (pass explicitly to build-site.sh) ──
  NAP_BUSINESS_NAME=$(python3 -c "
import re, sys
try:
    content = open('$SCRAPE_DIR/content.md').read()
    lines = [l.strip() for l in content.splitlines() if l.strip()]
    for line in lines[:10]:
        # Last segment after | separator (Firecrawl puts full page title on line 1)
        if '|' in line:
            name = line.split('|')[-1].strip()
            name = re.sub(r'^#+\s*', '', name)
            if 3 < len(name) < 80 and not name.startswith('http'):
                print(name); sys.exit(0)
        # First heading
        m = re.match(r'^#+\s+(.+)', line)
        if m:
            name = re.split(r'\s*[\|\-–—]\s*', m.group(1).strip())[0].strip()
            if 3 < len(name) < 80:
                print(name); sys.exit(0)
except: pass
print('')
" 2>/dev/null)
  NAP_PHONE=$(grep -oE '\(?\b[0-9]{3}\)?[-. ][0-9]{3}[-. ][0-9]{4}\b' "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 || echo "")
  NAP_ADDRESS=$(grep -oE '[0-9]+\s+[NSEW]?\s*[A-Za-z]+(?:\s+[A-Za-z]+)?\s+(Ave|St|Blvd|Dr|Rd|Ln|Way|Ct|Pl|Pkwy)\.?' "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 || echo "")
  echo "📋 NAP extracted — Name: ${NAP_BUSINESS_NAME:-"(fallback)"} | Phone: ${NAP_PHONE:-"not found"} | Address: ${NAP_ADDRESS:-"not found"}"

  # ── Step 3: Build ───────────────────────────────────────────────────────────
  echo "━━━ STEP 3: Building site for $DOMAIN ━━━"
  LIVE_URL=""
  BUILD_OK=true
  BUILD_OUTPUT=$("$SCRIPT_DIR/build-site.sh" \
    --domain "$DOMAIN" \
    --scrape-dir "$SCRAPE_DIR" \
    --niche "$NICHE" \
    --city "$CITY" \
    ${NAP_BUSINESS_NAME:+--business-name "$NAP_BUSINESS_NAME"} \
    ${NAP_PHONE:+--phone "$NAP_PHONE"} \
    ${NAP_ADDRESS:+--address "$NAP_ADDRESS"} 2>&1) || {
    echo "❌ Build failed for $DOMAIN"
    echo "$BUILD_OUTPUT" | tail -20
    BUILD_OK=false
    FAILED=$((FAILED + 1))
  }

  if [ "$BUILD_OK" = true ]; then
    echo "$BUILD_OUTPUT" | tail -10
    LIVE_URL=$(echo "$BUILD_OUTPUT" | grep "^LIVE_URL=" | tail -1 | cut -d= -f2-)
    BUILT=$((BUILT + 1))
    echo ""
    echo "✅ Built: $LIVE_URL"
  fi
  echo ""

  # ── Step 4: Send email ──────────────────────────────────────────────────────
  if [ "$BUILD_OK" = true ] && [ -n "$LIVE_URL" ]; then
    echo "━━━ STEP 4: Sending outreach email ━━━"

    # Try to extract email from scraped content
    BIZ_EMAIL=""
    if [ -f "$SCRAPE_DIR/content.md" ]; then
      BIZ_EMAIL=$(grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$SCRAPE_DIR/content.md" | head -1 || echo "")
    fi

    if [ -n "$BIZ_EMAIL" ] && [ "$SKIP_EMAIL" = false ]; then
      EMAIL_OUTPUT=$("$SCRIPT_DIR/send-email.sh" \
        --to "$BIZ_EMAIL" \
        --url "$LIVE_URL" \
        --business-name "$DOMAIN" \
        --sender-name "$SENDER_NAME" 2>&1) || {
        echo "⚠️  Email send failed for $BIZ_EMAIL"
        echo "$EMAIL_OUTPUT" | tail -5
      }

      if echo "$EMAIL_OUTPUT" | grep -q "Email sent"; then
        EMAILS_SENT=$((EMAILS_SENT + 1))
        echo "✅ Email sent to $BIZ_EMAIL"
      fi
    else
      echo "⚠️  No email found for $DOMAIN — skipping outreach"
    fi
  fi

  RESULTS+=("$DOMAIN | $LIVE_URL | $BUILD_OK")
  echo ""
done

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "📊 PIPELINE SUMMARY"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "  Niche:         $NICHE"
echo "  City:          $CITY"
echo "  Targets:       $COUNT"
echo "  ✅ Built:      $BUILT"
echo "  📧 Emails:     $EMAILS_SENT"
echo "  ❌ Failed:     $FAILED"
echo "  Finished:      $(date)"
echo "  Log:           $LOGFILE"
echo ""
echo "────────────────────────────────────────────────────────────────"
echo "  Results:"
echo ""
for RESULT in "${RESULTS[@]}"; do
  echo "    $RESULT"
done
echo ""
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "Pipeline complete: $BUILT built, $EMAILS_SENT emails sent, $FAILED failed"
echo ""
