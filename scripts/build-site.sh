#!/bin/bash
# build-site.sh — Build a complete website from scraped content using Claude Code, deploy to Netlify
# Usage: ./build-site.sh --domain "brightsmile.com" --scrape-dir "/tmp/website-remake-targets/brightsmile_com" --niche "dentist" --city "chicago"

set -e

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

# ── Parse arguments ───────────────────────────────────────────────────────────
DOMAIN=""
SCRAPE_DIR=""
NICHE=""
CITY=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --domain) DOMAIN="$2"; shift 2 ;;
    --scrape-dir) SCRAPE_DIR="$2"; shift 2 ;;
    --niche) NICHE="$2"; shift 2 ;;
    --city) CITY="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$DOMAIN" ] || [ -z "$SCRAPE_DIR" ] || [ -z "$NICHE" ] || [ -z "$CITY" ]; then
  echo "❌ Usage: ./build-site.sh --domain 'brightsmile.com' --scrape-dir '/tmp/website-remake-targets/brightsmile_com' --niche 'dentist' --city 'chicago'"
  exit 1
fi

# ── Load secrets ──────────────────────────────────────────────────────────────
SECRETS_DIR="$HOME/.openclaw/workspace/.secrets"

if [ -f "$SECRETS_DIR/netlify-token.txt" ]; then
  NETLIFY_TOKEN=$(cat "$SECRETS_DIR/netlify-token.txt" | tr -d '[:space:]')
fi
if [ -f "$SECRETS_DIR/agentmail-api-key.txt" ]; then
  AGENTMAIL_API_KEY=$(cat "$SECRETS_DIR/agentmail-api-key.txt" | tr -d '[:space:]')
fi
if [ -f "$SECRETS_DIR/brave-search-api-key.txt" ]; then
  BRAVE_API_KEY=$(cat "$SECRETS_DIR/brave-search-api-key.txt" | tr -d '[:space:]')
fi

if [ -z "$NETLIFY_TOKEN" ]; then
  echo "❌ NETLIFY_TOKEN not found in $SECRETS_DIR/netlify-token.txt"
  exit 1
fi

# ── Read scraped content ──────────────────────────────────────────────────────
SCRAPED_CONTENT=""
if [ -f "$SCRAPE_DIR/content.md" ]; then
  SCRAPED_CONTENT=$(cat "$SCRAPE_DIR/content.md" | head -500)
elif [ -f "$SCRAPE_DIR/analysis.md" ]; then
  SCRAPED_CONTENT=$(cat "$SCRAPE_DIR/analysis.md" | head -500)
else
  echo "⚠️  No content.md or analysis.md found in $SCRAPE_DIR — building with minimal context"
  SCRAPED_CONTENT="No scraped content available. Build a generic premium $NICHE website for $CITY."
fi

# ── Load full-site-rebuild prompt ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REBUILD_PROMPT=""
if [ -f "$SCRIPT_DIR/../prompts/full-site-rebuild.md" ]; then
  REBUILD_PROMPT=$(cat "$SCRIPT_DIR/../prompts/full-site-rebuild.md")
fi

# ── Create fresh build directory + git repo ───────────────────────────────────
SLUG=$(echo "$DOMAIN" | tr '.' '_' | tr '[:upper:]' '[:lower:]')
BUILD_DIR="/tmp/website-rebuilds/$SLUG"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
git init
git checkout -b main

echo "🏗️  Building website for $DOMAIN ($NICHE in $CITY)"
echo "📁 Build dir: $BUILD_DIR"
echo ""

# ── Build system prompt ───────────────────────────────────────────────────────
SYSTEM_PROMPT="You are a premium web designer building a $10K website rebuild.

BUSINESS INFO:
- Domain: $DOMAIN
- Niche: $NICHE
- City: $CITY

SCRAPED CONTENT FROM EXISTING SITE:
$SCRAPED_CONTENT

ANTI-SLOP RULES:
- NO generic stock photos or placeholder images — use CSS gradients, SVG patterns, or icon libraries instead
- NO boring sans-serif body text walls — use distinctive Google Fonts with clear hierarchy
- NO cookie-cutter layouts — use asymmetric grids, overlapping elements, creative whitespace
- NO default blue links or generic buttons — style every interactive element
- NO lazy testimonial sections — make them visually striking with cards, avatars, ratings
- NO basic contact forms — add floating labels, validation animations, success states
- NO static headers — sticky nav with backdrop blur, scroll-triggered color changes
- Every section must have at least one animation (GSAP scroll trigger, parallax, or hover effect)
- Color palette must feel intentional — max 3 colors + 1 accent, applied consistently
- Typography must have contrast — big bold headlines vs clean body text

BUILD INSTRUCTIONS:
$REBUILD_PROMPT

CRITICAL REQUIREMENTS:
1. Build ALL files in the current directory (index.html + any CSS/JS files)
2. Single-page site with: Hero, About, Services, Testimonials, Contact, Footer
3. Use GSAP + ScrollTrigger from CDN for animations
4. Google Fonts (distinctive choices, not just Roboto/Open Sans)
5. Mobile responsive (375px to 1920px)
6. Include JSON-LD schema markup for LocalBusiness
7. Lighthouse-ready: optimize for Core Web Vitals
8. All assets inline or from CDN — no local image files needed
9. Make it look like a \$10,000 website — premium, polished, impressive

Build the complete website now. Create all necessary files."

# ── Run Claude Code ───────────────────────────────────────────────────────────
echo "🤖 Running Claude Code..."
echo ""

claude --permission-mode bypassPermissions --print "$SYSTEM_PROMPT"

echo ""
echo "✅ Claude Code finished building"

# ── Git commit the build ──────────────────────────────────────────────────────
git add -A
git commit -m "feat: premium website rebuild for $DOMAIN ($NICHE in $CITY)" || true

# ── Deploy to Netlify ─────────────────────────────────────────────────────────
echo ""
echo "🚀 Deploying to Netlify..."

DEPLOY_DIR="."
if [ -d "./dist" ]; then
  DEPLOY_DIR="./dist"
elif [ -d "./build" ]; then
  DEPLOY_DIR="./build"
fi

DEPLOY_OUTPUT=$(npx netlify-cli deploy --dir="$DEPLOY_DIR" --auth="$NETLIFY_TOKEN" --prod 2>&1) || {
  echo "❌ Netlify deploy failed:"
  echo "$DEPLOY_OUTPUT"
  exit 1
}

# Extract the live URL from deploy output
LIVE_URL=$(echo "$DEPLOY_OUTPUT" | grep -i "website url" | head -1 | awk '{print $NF}' || echo "")
if [ -z "$LIVE_URL" ]; then
  LIVE_URL=$(echo "$DEPLOY_OUTPUT" | grep -oE 'https://[a-zA-Z0-9_-]+\.netlify\.app' | head -1 || echo "")
fi

echo ""
echo "✅ Deployed!"
echo "$DEPLOY_OUTPUT" | tail -5
echo ""

# ── Write build report ────────────────────────────────────────────────────────
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat > "$BUILD_DIR/build-report.md" <<EOF
# Build Report

- **Domain**: $DOMAIN
- **Niche**: $NICHE
- **City**: $CITY
- **Live URL**: $LIVE_URL
- **Timestamp**: $TIMESTAMP
- **Build Dir**: $BUILD_DIR
- **Scrape Dir**: $SCRAPE_DIR
EOF

git add build-report.md
git commit -m "docs: add build report for $DOMAIN" || true

echo "📋 Build report: $BUILD_DIR/build-report.md"
echo ""
echo "LIVE_URL=$LIVE_URL"
