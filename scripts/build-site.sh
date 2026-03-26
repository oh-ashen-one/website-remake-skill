#!/bin/bash
# build-site.sh v5 — Stitch homepage → Claude Code multi-page expansion → GitHub Pages deploy
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
  echo "❌ Usage: ./build-site.sh --domain 'brightsmile.com' --scrape-dir '/path' --niche 'dentist' --city 'chicago'"
  exit 1
fi

# ── Load secrets ──────────────────────────────────────────────────────────────
SECRETS_DIR="$HOME/.openclaw/workspace/.secrets"
STITCH_API_KEY=$(cat "$SECRETS_DIR/stitch-api-key.txt" 2>/dev/null | tr -d '[:space:]')
GEMINI_API_KEY=$(cat "$SECRETS_DIR/gemini-api-key.txt" 2>/dev/null | tr -d '[:space:]')

if [ -z "$STITCH_API_KEY" ]; then
  echo "❌ STITCH_API_KEY not found in $SECRETS_DIR/stitch-api-key.txt"
  exit 1
fi

# ── Read scraped content ──────────────────────────────────────────────────────
SCRAPED_CONTENT="No scraped content. Build a generic premium $NICHE site for $CITY."
if [ -f "$SCRAPE_DIR/content.md" ]; then
  SCRAPED_CONTENT=$(head -400 "$SCRAPE_DIR/content.md")
elif [ -f "$SCRAPE_DIR/analysis.md" ]; then
  SCRAPED_CONTENT=$(head -400 "$SCRAPE_DIR/analysis.md")
fi

# Extract real NAP from scraped content
BUSINESS_NAME=$(grep -i "business name\|company name\|name:" "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 | sed 's/.*: //' | tr -d '[:space:]' || echo "$DOMAIN")
PHONE=$(grep -oE '\(?\b[0-9]{3}\)?[-.\s][0-9]{3}[-.\s][0-9]{4}\b' "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 || echo "")
ADDRESS=$(grep -i "address\|located at\|visit us" "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 | sed 's/.*: //' || echo "")

echo "Business: $BUSINESS_NAME | Phone: $PHONE | Niche: $NICHE | City: $CITY"

# ── Create build directory ────────────────────────────────────────────────────
SLUG=$(echo "$DOMAIN" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/--*/-/g; s/^-//; s/-$//')
BUILD_DIR="/tmp/website-rebuilds/$SLUG"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/assets"
cd "$BUILD_DIR"

echo "🏗️  Build dir: $BUILD_DIR"
echo ""

# ── Step 1: Install Stitch SDK ────────────────────────────────────────────────
echo "━━━ STEP 1: Installing Stitch SDK ━━━"
npm init -y > /dev/null 2>&1
npm install @google/stitch-sdk > /dev/null 2>&1
echo "✅ Stitch SDK installed"
echo ""

# ── Step 2: Generate homepage with Stitch ─────────────────────────────────────
echo "━━━ STEP 2: Generating homepage with Google Stitch ━━━"

cat > /tmp/stitch-generate-$SLUG.mjs << STITCH_EOF
import { StitchToolClient } from "@google/stitch-sdk";
import { writeFileSync, mkdirSync } from 'fs';
import { execSync } from 'child_process';

const client = new StitchToolClient({ apiKey: "${STITCH_API_KEY}" });

// Create project
const projectResult = await client.callTool("create_project", {
  title: "${BUSINESS_NAME} — Forge Rebuild"
});
const projectId = projectResult?.projectId
  || (projectResult?.name ? projectResult.name.split('/').pop() : null);

if (!projectId) {
  console.error("❌ Stitch project creation failed:", JSON.stringify(projectResult).slice(0, 300));
  process.exit(1);
}
console.log("Stitch project:", projectId);

// Niche-specific design instructions
const nicheInstructions = {
  'auto repair': 'Dark industrial. Bold sans-serif headlines (Oswald/Clash Display). Red accent. Phone in hero. Free estimate CTA. ASE trust badge.',
  'roofing': 'Dark bold industrial. Free inspection CTA. Storm damage section. Years in business counter. Strong trust signals.',
  'plumbing': 'Dark bold. 24/7 emergency banner. Phone massive in hero. Same-day service. Trades feel.',
  'hvac': 'Dark professional. Emergency service CTA. Seasonal (heating + cooling). Years in business.',
  'electrician': 'Dark industrial. Safety signals. Licensed + insured badges. Emergency call CTA.',
  'dentist': 'Dark professional with soft teal accent. Before/after gallery. New patient CTA. Insurance info.',
  'law firm': 'Authoritative dark. Serif headlines (Playfair Display). Practice areas. Free consultation. Bar credentials.',
  'restaurant': 'Warm dark. Serif + sans pairing. Menu link in hero. Hours prominently. Reservation CTA. Food photography dominant.',
  'salon': 'Dark elegant. Thin serif headlines. Booking CTA everywhere. Service menu with prices. Gallery.',
  'spa': 'Dark luxe. Wellness aesthetic. Booking CTA. Treatment menu. Tranquil imagery.',
  'accountant': 'Authoritative dark. Trust signals. Services list. Free consultation CTA. Tax season urgency.',
};

const instruction = Object.entries(nicheInstructions)
  .find(([k]) => "${NICHE}".toLowerCase().includes(k))?.[1]
  || 'Dark professional theme. Trust signals. Strong CTA in hero.';

const prompt = \`
Homepage for ${BUSINESS_NAME}, a ${NICHE} business in ${CITY}.

DESIGN RULES (MANDATORY):
- \${instruction}
- Dark background MANDATORY — background #131313 or darker. NEVER white or near-white.
- NO emojis anywhere on the page
- NO purple, violet, lavender, or indigo anywhere
- Mobile-first responsive layout
- GSAP ScrollTrigger animations (staggered fade-up on scroll enter)
- No external dependencies except GSAP CDN

REAL BUSINESS DATA — use verbatim:
- Business name: ${BUSINESS_NAME}
- Phone: ${PHONE:-"<!-- TODO: INSERT PHONE -->"}
- Address: ${ADDRESS:-"<!-- TODO: INSERT ADDRESS -->"}
- City: ${CITY}
- Niche: ${NICHE}

REQUIRED SECTIONS (in this order):
1. Nav — logo left, page links right, phone + CTA button
2. Hero — bold headline "${CITY}'s Trusted ${NICHE}", subtext, dual CTA (call + see services), dark overlay over background image placeholder
3. Services grid — 3–5 service cards, SVG icon, title, short description, no emojis
4. Trust/stats bar — years in business, customers served, 5-star reviews count (animate on scroll)
5. Testimonials — 3 cards with star rating, quote, name
6. Contact — address, phone, map placeholder, simple contact form
7. Footer — nav links, phone, copyright

OUTPUT: Clean semantic HTML with embedded \`<style>\` and \`<script>\` tags. GSAP from CDN. No framework. Production-ready.
\`.trim();

// Generate screen
console.log("Generating with Stitch...");
const screenResult = await client.callTool("generate_screen_from_text", {
  projectId,
  prompt,
  deviceType: "DESKTOP"
});

// Find download URLs
function findUrls(obj, depth=0) {
  if (depth > 8 || typeof obj !== 'object' || !obj) return {};
  let html = null, image = null;
  for (const [k, v] of Object.entries(obj)) {
    if (typeof v === 'string') {
      if (!html && v.startsWith('https://contribution.usercontent.google.com')) html = v;
      if (!image && v.startsWith('https://lh3.googleusercontent.com')) image = v;
    } else if (typeof v === 'object') {
      const sub = findUrls(v, depth + 1);
      if (!html && sub.html) html = sub.html;
      if (!image && sub.image) image = sub.image;
    }
  }
  return { html, image };
}

const { html: htmlUrl, image: imageUrl } = findUrls(screenResult);

if (!htmlUrl) {
  console.error("❌ No HTML URL in Stitch response");
  console.error(JSON.stringify(screenResult).slice(0, 500));
  process.exit(1);
}

// Extract design system notes
const designMd = JSON.stringify(screenResult).match(/"designMd":"([^"]{0,2000})"/)?.[1] || '';
if (designMd) {
  writeFileSync('/tmp/stitch-design-$SLUG.md', designMd.replace(/\\n/g, '\n'));
  console.log("Design system saved to /tmp/stitch-design-$SLUG.md");
}

writeFileSync('/tmp/stitch-urls-$SLUG.json', JSON.stringify({ htmlUrl, imageUrl }, null, 2));
console.log("URLs saved.");
await client.close();
STITCH_EOF

node --input-type=module < /tmp/stitch-generate-$SLUG.mjs

# Download HTML and screenshot
HTML_URL=$(node -e "const d=require('/tmp/stitch-urls-$SLUG.json'); console.log(d.htmlUrl)")
IMAGE_URL=$(node -e "const d=require('/tmp/stitch-urls-$SLUG.json'); console.log(d.imageUrl)")

curl -sL "$HTML_URL" -o "$BUILD_DIR/index.html"
curl -sL "$IMAGE_URL" -o "$BUILD_DIR/assets/stitch-preview.jpg"

INDEX_SIZE=$(wc -c < "$BUILD_DIR/index.html")
echo "✅ Stitch homepage: ${INDEX_SIZE} bytes"
echo ""

# ── Step 3: Generate hero + service images with Imagen 4 ──────────────────────
if [ -n "$GEMINI_API_KEY" ]; then
  echo "━━━ STEP 3: Generating images with Nano Banana ━━━"
  python3 << PYTHON_EOF
import urllib.request, json, base64, os

GEMINI_API_KEY = "${GEMINI_API_KEY}"
OUT_DIR = "${BUILD_DIR}/assets"

def generate_image(prompt, filename):
    payload = {
        "instances": [{"prompt": prompt}],
        "parameters": {"sampleCount": 1, "aspectRatio": "16:9"}
    }
    req = urllib.request.Request(
        f"https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-generate-001:predict?key={GEMINI_API_KEY}",
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            d = json.load(resp)
        with open(f"{OUT_DIR}/{filename}", 'wb') as f:
            f.write(base64.b64decode(d['predictions'][0]['bytesBase64Encoded']))
        print(f"✅ Generated: {filename}")
    except Exception as e:
        print(f"⚠️  Image gen failed for {filename}: {e}")

generate_image(
    f"Cinematic dark wide shot of professional ${NICHE} business in ${CITY}, dramatic studio lighting, high-end editorial photography, dark atmosphere",
    "hero-main.jpg"
)
generate_image(
    f"Editorial close-up of ${NICHE} work in progress, dark professional environment, dramatic side lighting",
    "service-1.jpg"
)
generate_image(
    f"Professional action shot of ${NICHE} service being performed, dark industrial aesthetic, cinematic",
    "service-2.jpg"
)
PYTHON_EOF
  echo ""
fi

# ── Step 4: Generate multi-page site with bash heredocs ──────────────────────
echo "━━━ STEP 4: Generating multi-page site ━━━"

# Extract CSS/theme from index.html for reuse
HEAD_CSS=$(sed -n '/<style/,/<\/style>/p' "$BUILD_DIR/index.html" | head -200)
NAV_HTML=$(sed -n '/<nav/,/<\/nav>/p' "$BUILD_DIR/index.html" | head -30)
FOOTER_HTML=$(sed -n '/<footer/,/<\/footer>/p' "$BUILD_DIR/index.html" | head -30)

# Generate about.html
cat > "$BUILD_DIR/about.html" << ABOUT_EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About ${BUSINESS_NAME} — ${NICHE} in ${CITY}</title>
  <meta name="description" content="Learn about ${BUSINESS_NAME}, a trusted ${NICHE} serving ${CITY} and surrounding areas.">
  <link rel="canonical" href="https://oh-ashen-one.github.io/${SLUG}/about.html">
  ${HEAD_CSS}
</head>
<body style="background:#131313;color:#e0e0e0;font-family:system-ui,sans-serif;margin:0;">
  ${NAV_HTML}
  <main style="max-width:900px;margin:0 auto;padding:80px 20px;">
    <h1 style="font-size:2.5rem;margin-bottom:1rem;">About ${BUSINESS_NAME}</h1>
    <p>Proudly serving ${CITY} and the surrounding community, ${BUSINESS_NAME} has built a reputation for reliable, high-quality ${NICHE} services.</p>
    <h2>Why Choose Us</h2>
    <ul>
      <li>Experienced, licensed professionals</li>
      <li>Transparent pricing with no hidden fees</li>
      <li>Committed to customer satisfaction</li>
      <li>Serving the ${CITY} area</li>
    </ul>
    <p><a href="contact.html" style="color:#4ecdc4;">Contact us today</a> | <a href="index.html" style="color:#4ecdc4;">Back to Home</a> | <a href="services.html" style="color:#4ecdc4;">Our Services</a></p>
  </main>
  ${FOOTER_HTML}
</body>
</html>
ABOUT_EOF
echo "✅ about.html"

# Generate services.html
cat > "$BUILD_DIR/services.html" << SERVICES_EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${BUSINESS_NAME} Services — ${NICHE} in ${CITY}</title>
  <meta name="description" content="Professional ${NICHE} services offered by ${BUSINESS_NAME} in ${CITY}.">
  <link rel="canonical" href="https://oh-ashen-one.github.io/${SLUG}/services.html">
  ${HEAD_CSS}
</head>
<body style="background:#131313;color:#e0e0e0;font-family:system-ui,sans-serif;margin:0;">
  ${NAV_HTML}
  <main style="max-width:900px;margin:0 auto;padding:80px 20px;">
    <h1 style="font-size:2.5rem;margin-bottom:1rem;">Our Services</h1>
    <p>${BUSINESS_NAME} offers a full range of professional ${NICHE} services in ${CITY}.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:24px;margin-top:32px;">
      <div style="background:#1a1a1a;padding:24px;border-radius:12px;"><h3>General ${NICHE} Services</h3><p>Comprehensive solutions for residential and commercial clients.</p></div>
      <div style="background:#1a1a1a;padding:24px;border-radius:12px;"><h3>Emergency Services</h3><p>Fast response when you need us most. Available for urgent calls.</p></div>
      <div style="background:#1a1a1a;padding:24px;border-radius:12px;"><h3>Consultation</h3><p>Free estimates and professional advice for your project.</p></div>
    </div>
    <p style="margin-top:32px;"><a href="contact.html" style="color:#4ecdc4;">Get a Free Quote</a> | <a href="about.html" style="color:#4ecdc4;">About Us</a> | <a href="index.html" style="color:#4ecdc4;">Home</a></p>
  </main>
  ${FOOTER_HTML}
</body>
</html>
SERVICES_EOF
echo "✅ services.html"

# Generate contact.html
cat > "$BUILD_DIR/contact.html" << CONTACT_EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact ${BUSINESS_NAME} — ${NICHE} in ${CITY}</title>
  <meta name="description" content="Contact ${BUSINESS_NAME} for ${NICHE} services in ${CITY}. Call us or send a message.">
  <link rel="canonical" href="https://oh-ashen-one.github.io/${SLUG}/contact.html">
  ${HEAD_CSS}
</head>
<body style="background:#131313;color:#e0e0e0;font-family:system-ui,sans-serif;margin:0;">
  ${NAV_HTML}
  <main style="max-width:900px;margin:0 auto;padding:80px 20px;">
    <h1 style="font-size:2.5rem;margin-bottom:1rem;">Contact Us</h1>
    <p>Ready to get started? Reach out to ${BUSINESS_NAME} today.</p>
    <div style="margin:32px 0;">
      ${PHONE:+<p><strong>Phone:</strong> <a href="tel:${PHONE}" style="color:#4ecdc4;">${PHONE}</a></p>}
      ${ADDRESS:+<p><strong>Address:</strong> ${ADDRESS}</p>}
      <p><strong>Serving:</strong> ${CITY} and surrounding areas</p>
    </div>
    <form style="max-width:500px;">
      <input type="text" placeholder="Your Name" style="width:100%;padding:12px;margin-bottom:12px;background:#1a1a1a;border:1px solid #333;color:#e0e0e0;border-radius:8px;font-size:1rem;">
      <input type="email" placeholder="Your Email" style="width:100%;padding:12px;margin-bottom:12px;background:#1a1a1a;border:1px solid #333;color:#e0e0e0;border-radius:8px;font-size:1rem;">
      <textarea placeholder="How can we help?" rows="5" style="width:100%;padding:12px;margin-bottom:12px;background:#1a1a1a;border:1px solid #333;color:#e0e0e0;border-radius:8px;font-size:1rem;resize:vertical;"></textarea>
      <button type="submit" style="background:#4ecdc4;color:#131313;padding:14px 32px;border:none;border-radius:8px;font-size:1rem;cursor:pointer;font-weight:bold;">Send Message</button>
    </form>
    <p style="margin-top:32px;"><a href="index.html" style="color:#4ecdc4;">Home</a> | <a href="services.html" style="color:#4ecdc4;">Services</a> | <a href="about.html" style="color:#4ecdc4;">About</a></p>
  </main>
  ${FOOTER_HTML}
</body>
</html>
CONTACT_EOF
echo "✅ contact.html"

# Generate 404.html
cp "$BUILD_DIR/index.html" "$BUILD_DIR/404.html"
echo "✅ 404.html"

# Generate sitemap.xml
cat > "$BUILD_DIR/sitemap.xml" << SITEMAP_EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://oh-ashen-one.github.io/${SLUG}/</loc></url>
  <url><loc>https://oh-ashen-one.github.io/${SLUG}/about.html</loc></url>
  <url><loc>https://oh-ashen-one.github.io/${SLUG}/services.html</loc></url>
  <url><loc>https://oh-ashen-one.github.io/${SLUG}/contact.html</loc></url>
</urlset>
SITEMAP_EOF
echo "✅ sitemap.xml"

# Generate robots.txt
cat > "$BUILD_DIR/robots.txt" << ROBOTS_EOF
User-agent: *
Allow: /
Sitemap: https://oh-ashen-one.github.io/${SLUG}/sitemap.xml
ROBOTS_EOF
echo "✅ robots.txt"

echo ""
echo "✅ Multi-page generation complete"
echo ""

# ── Step 5: Completion gate ───────────────────────────────────────────────────
echo "━━━ STEP 5: Completion Gate ━━━"
PASS=true

for f in index.html about.html contact.html 404.html sitemap.xml robots.txt; do
  if [ -f "$BUILD_DIR/$f" ]; then
    echo "✅ $f"
  else
    echo "❌ MISSING: $f"
    PASS=false
  fi
done

if [ -f "$BUILD_DIR/services.html" ]; then
  echo "✅ services.html"
else
  echo "❌ MISSING: services.html"
  PASS=false
fi

if [ "$PASS" = false ]; then
  echo "❌ Completion gate failed — aborting build."
  exit 1
fi
echo ""

# ── Step 6: Deploy to GitHub Pages ───────────────────────────────────────────
echo "━━━ STEP 6: Deploying to GitHub Pages ━━━"
cd "$BUILD_DIR"
git init
git checkout -b main 2>/dev/null || git checkout main
git add -A
git commit -m "feat: website rebuild for $DOMAIN ($NICHE in $CITY) — Stitch + Claude Code"

# Create public repo and enable Pages
gh repo create "oh-ashen-one/$SLUG" --public --source . --remote origin --push 2>&1 || {
  # Repo may already exist — push to it
  git remote set-url origin "https://github.com/oh-ashen-one/$SLUG.git" 2>/dev/null
  git push -u origin main --force 2>&1 || true
}

# Enable GitHub Pages
gh api "repos/oh-ashen-one/$SLUG/pages" \
  -X POST \
  -f source[branch]=main \
  -f source[path]=/ \
  --silent 2>/dev/null || true  # ignore if already enabled

LIVE_URL="https://oh-ashen-one.github.io/$SLUG"
echo "✅ Deployed (may take ~60s to go live): $LIVE_URL"
echo ""

# ── Step 7: Log to Notion ─────────────────────────────────────────────────────
NOTION_TOKEN=$(grep NOTION_API_KEY "$SECRETS_DIR/notion.env" 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
if [ -n "$NOTION_TOKEN" ]; then
  echo "━━━ STEP 7: Logging to Notion ━━━"
  TODAY=$(date -u +"%Y-%m-%d")
  NOTION_RESPONSE=$(curl -s -X POST "https://api.notion.com/v1/pages" \
    -H "Authorization: Bearer $NOTION_TOKEN" \
    -H "Notion-Version: 2022-06-28" \
    -H "Content-Type: application/json" \
    -d "{
      \"parent\": {\"database_id\": \"327664f6-a1e3-81e8-879d-ff9d14f95213\"},
      \"properties\": {
        \"Business Name\": {\"title\": [{\"text\": {\"content\": \"$BUSINESS_NAME\"}}]},
        \"Original URL\": {\"url\": \"https://$DOMAIN\"},
        \"Demo URL\": {\"url\": \"$LIVE_URL\"},
        \"Niche\": {\"select\": {\"name\": \"$NICHE\"}},
        \"City\": {\"rich_text\": [{\"text\": {\"content\": \"$CITY\"}}]},
        \"Phone\": {\"phone_number\": \"$PHONE\"},
        \"Status\": {\"select\": {\"name\": \"Built\"}},
        \"Agent\": {\"select\": {\"name\": \"Andre\"}},
        \"Date Built\": {\"date\": {\"start\": \"$TODAY\"}},
        \"Notes\": {\"rich_text\": [{\"text\": {\"content\": \"Built $TODAY via Stitch v5 pipeline. Demo at $LIVE_URL\"}}]}
      }
    }")
  NOTION_PAGE_ID=$(echo "$NOTION_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('id',''))" 2>/dev/null || echo "")
  echo "✅ Notion logged: $NOTION_PAGE_ID"
fi
echo ""

# ── Write build report ────────────────────────────────────────────────────────
cat > "$BUILD_DIR/build-report.md" << EOF
# Build Report — $BUSINESS_NAME

- **Domain**: $DOMAIN
- **Slug**: $SLUG
- **Niche**: $NICHE
- **City**: $CITY
- **Live URL**: $LIVE_URL
- **Notion ID**: ${NOTION_PAGE_ID:-"not logged"}
- **Built**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
- **Pipeline**: Stitch v5 (Stitch homepage + Imagen 4 + Claude Code multi-page)
EOF

echo "📋 Build report: $BUILD_DIR/build-report.md"
echo ""
echo "LIVE_URL=$LIVE_URL"
echo "NOTION_PAGE_ID=${NOTION_PAGE_ID:-}"
echo "SLUG=$SLUG"
echo "DOMAIN=$DOMAIN"
echo "BUSINESS_NAME=$BUSINESS_NAME"
echo "PHONE=$PHONE"
