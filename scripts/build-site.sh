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
OVERRIDE_BUSINESS_NAME=""
OVERRIDE_PHONE=""
OVERRIDE_ADDRESS=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --domain) DOMAIN="$2"; shift 2 ;;
    --scrape-dir) SCRAPE_DIR="$2"; shift 2 ;;
    --niche) NICHE="$2"; shift 2 ;;
    --city) CITY="$2"; shift 2 ;;
    --business-name) OVERRIDE_BUSINESS_NAME="$2"; shift 2 ;;
    --phone) OVERRIDE_PHONE="$2"; shift 2 ;;
    --address) OVERRIDE_ADDRESS="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$DOMAIN" ] || [ -z "$SCRAPE_DIR" ] || [ -z "$NICHE" ] || [ -z "$CITY" ]; then
  echo "❌ Usage: ./build-site.sh --domain 'brightsmile.com' --scrape-dir '/path' --niche 'dentist' --city 'chicago' [--business-name 'Name'] [--phone '(555) 000-0000'] [--address '123 Main St']"
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
# Business name: from <title> line or first H1 in scraped markdown (most reliable)
BUSINESS_NAME=$(python3 -c "
import re, sys
try:
    content = open('$SCRAPE_DIR/content.md').read()
    lines = [l.strip() for l in content.splitlines() if l.strip()]

    # Garbage patterns to strip from extracted names
    # Catches icon class names, CSS artifacts, social media references, HTML fragments
    GARBAGE_RE = re.compile(
        r'(tiktok|facebook|instagram|twitter|youtube|linkedin|pinterest|snapchat|'
        r'_fill|_outline|_rounded|_sharp|_twotone|icon[-_]|svg[-_]|fa[-_]|'
        r'class=|style=|href=|<[^>]+>|&[a-z]+;|\\\\[a-z]|'
        r'material[-_]?symbols?|lucide|heroicon|phosphor|feather)',
        re.IGNORECASE
    )

    def clean_name(raw):
        \"\"\"Strip garbage artifacts from extracted business name.\"\"\"
        if not raw:
            return ''
        # Remove any garbage pattern matches
        cleaned = GARBAGE_RE.sub('', raw).strip()
        # Remove leftover underscores, double spaces, leading/trailing punctuation
        cleaned = re.sub(r'[_]', ' ', cleaned)
        cleaned = re.sub(r'\s{2,}', ' ', cleaned)
        cleaned = cleaned.strip(' .,;:-–—|/')
        # Reject if mostly non-alpha (icon class names, CSS selectors)
        alpha_ratio = sum(1 for c in cleaned if c.isalpha()) / max(len(cleaned), 1)
        if alpha_ratio < 0.5:
            return ''
        return cleaned

    # Strategy 1: First non-heading line with | separator (Firecrawl title line)
    for line in lines[:3]:
        if not line.startswith('#') and not line.startswith('http') and '|' in line:
            parts = re.split(r'\s*[\|]\s*', line)
            # Try last segment first, then first segment
            for segment in [parts[-1], parts[0]]:
                name = clean_name(segment)
                if 3 < len(name) < 80:
                    print(name); sys.exit(0)

    # Strategy 2: First non-heading line with no | — treat as title
    for line in lines[:3]:
        if not line.startswith('#') and not line.startswith('http') and 3 < len(line) < 80:
            name = clean_name(re.split(r'\s*[\|\-–—]\s*', line)[0])
            if 3 < len(name) < 80:
                print(name); sys.exit(0)

    # Strategy 3: First H1 heading
    m = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
    if m:
        name = clean_name(re.split(r'\s*[\|\-–—]\s*', m.group(1).strip())[0])
        if 3 < len(name) < 80:
            print(name); sys.exit(0)
except: pass
print('')
" 2>/dev/null)
# If extraction failed, use domain as fallback (will be overridden by NAP inject if Stitch picks a name)
[ -z "$BUSINESS_NAME" ] && BUSINESS_NAME=$(echo "$DOMAIN" | sed 's/\.[^.]*$//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
PHONE=$(grep -oE '\(?\b[0-9]{3}\)?[-. ][0-9]{3}[-. ][0-9]{4}\b' "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 || echo "")
ADDRESS=$(grep -oE '[0-9]+\s+[NSEW]?\s*[A-Za-z]+(?:\s+[A-Za-z]+)?\s+(Ave|St|Blvd|Dr|Rd|Ln|Way|Ct|Pl|Pkwy)\.?' "$SCRAPE_DIR/content.md" 2>/dev/null | head -1 || echo "")

# Apply overrides from caller (run-pipeline.sh passes pre-extracted values — these win)
[ -n "$OVERRIDE_BUSINESS_NAME" ] && BUSINESS_NAME="$OVERRIDE_BUSINESS_NAME"
[ -n "$OVERRIDE_PHONE" ] && PHONE="$OVERRIDE_PHONE"
[ -n "$OVERRIDE_ADDRESS" ] && ADDRESS="$OVERRIDE_ADDRESS"

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

// ── DICE ROLLS — vary layout every build ──
const NAV_STYLES = [
  'Full-width bar: dark background, logo text left, page links centered, phone number and CTA button on the right. Always visible.',
  'Off-canvas drawer: minimal wordmark top-left with hamburger icon. Tapping hamburger opens a full-screen dark overlay menu with large centered links, phone number at bottom. Desktop shows full nav bar instead.',
  'Sticky shrink: starts tall (80px) with large logo and spread-out links. On scroll, compresses to a slim 48px bar with smaller text. Phone number always visible in both states.',
  'Floating island: no nav visible on load. After scrolling 200px, a small rounded pill/capsule bar fades in at top-center with compact logo + links + phone. Dark with subtle blur backdrop.',
];
const HERO_STYLES = [
  'Split-screen: left half is dark panel with headline, subtext, and dual CTAs stacked vertically. Right half is a large background-image placeholder (16:9 aspect) with dark overlay at edges. Clean division.',
  'Full-bleed editorial: single large background-image placeholder fills entire hero. Dark gradient overlay (bottom 60%) for text readability. Headline and CTAs centered or bottom-left over the image.',
  'Asymmetric offset: hero text block positioned top-left with generous whitespace. A large angled or clipped image placeholder sits bottom-right, overlapping into the next section slightly. Feels editorial, not template-y.',
  'Stacked cinematic: narrow letterbox image strip across full width (250px tall) at the very top, then below it a dark panel with large headline, subtext, and CTAs. Feels like a movie title card.',
];
const SECTION_SEQUENCES = [
  'Hero → Services (tabbed interface or accordion, NOT a plain grid) → Trust signals/stats horizontal bar → Testimonials carousel → FAQ accordion → Contact form with map',
  'Hero → About/story section (split: text left, image right) → Services (alternating: odd rows = image left + text right, even rows = flipped) → Testimonials → Contact',
  'Hero → Trust badges strip (logos or certification icons) → Services bento grid (mixed card sizes, not uniform) → Media/portfolio section → Testimonials → FAQ → Contact',
  'Hero → Services lead (large bento grid with one featured card 2x size) → Stats counter bar → About split-screen → Testimonials masonry → Contact',
];

const navRoll = Math.floor(Math.random() * NAV_STYLES.length);
const heroRoll = Math.floor(Math.random() * HERO_STYLES.length);
const sectionRoll = Math.floor(Math.random() * SECTION_SEQUENCES.length);
console.log(\`🎲 Dice rolls — Nav: \${navRoll} | Hero: \${heroRoll} | Sections: \${sectionRoll}\`);

const prompt = \`
Homepage for ${BUSINESS_NAME}, a ${NICHE} business in ${CITY}.

DESIGN RULES (MANDATORY):
- \${instruction}
- Dark background MANDATORY — background #131313 or darker. NEVER white or near-white.
- NO emojis anywhere on the page
- NO purple, violet, lavender, or indigo anywhere
- Mobile-first responsive layout
- No JavaScript animation libraries. No GSAP. No ScrollTrigger. CSS transitions only.
- No external JS dependencies. All elements opacity:1 by default. Never use opacity:0.

REAL BUSINESS DATA — use verbatim:
- Business name: ${BUSINESS_NAME}
- Phone: ${PHONE:-"<!-- TODO: INSERT PHONE -->"}
- Address: ${ADDRESS:-"<!-- TODO: INSERT ADDRESS -->"}
- City: ${CITY}
- Niche: ${NICHE}

NAVIGATION STYLE (follow this exactly):
\${NAV_STYLES[navRoll]}

HERO SECTION STYLE (follow this exactly):
\${HERO_STYLES[heroRoll]}

PAGE SECTION SEQUENCE (follow this order exactly, do NOT use the generic hero-grid-stats-testimonials-contact pattern):
\${SECTION_SEQUENCES[sectionRoll]}

Each section must look visually distinct — different background shade, different layout structure. Avoid repeating the same card-grid pattern in multiple sections. Vary between: grids, split layouts, horizontal scrolling strips, accordion/tab panels, and full-width bands.

OUTPUT: Clean semantic HTML with embedded style and script tags. No GSAP. No external JS dependencies. Vanilla JS only. All content visible without JavaScript — opacity must be 1 on all elements by default. No framework. Production-ready.
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

# ── (Redirect handler removed — subpages are real files, no JS routing needed) ──

# ── Post-process: Inject real NAP data — Stitch invents placeholder names/phones ─
# Stitch ignores real business data in the prompt and generates its own creative values.
# We must find+replace all Stitch-invented data with the real scraped values.
echo "Injecting real NAP data (Stitch generates placeholder names/phones)..."

python3 << NAP_INJECT_EOF
import re, sys

with open("${BUILD_DIR}/index.html", "r") as f:
    html = f.read()

REAL_NAME    = """${BUSINESS_NAME}"""
REAL_PHONE   = """${PHONE}"""
REAL_ADDRESS = """${ADDRESS}"""
REAL_CITY    = """${CITY}"""

if not REAL_NAME:
    print("⚠️  BUSINESS_NAME empty — phone/address inject will still run")
    # Don't exit — still fix phone and address

# ── 1. Find what Stitch called the business ──────────────────────────────────
# Stitch puts the invented name in <title>, <h1>, and nav logo. Extract from <title>.
title_match = re.search(r'<title[^>]*>([^<]+)</title>', html, re.IGNORECASE)
stitch_name = None
if title_match:
    raw = title_match.group(1)
    # Title is usually "Stitch Name | tagline" or "Stitch Name – tagline"
    stitch_name = re.split(r'[|\-–—]', raw)[0].strip()
    if len(stitch_name) > 60 or len(stitch_name) < 3:
        stitch_name = None

if stitch_name and stitch_name.lower() != REAL_NAME.lower():
    count = html.lower().count(stitch_name.lower())
    # Case-insensitive replace preserving surrounding context
    html = re.sub(re.escape(stitch_name), REAL_NAME, html, flags=re.IGNORECASE)
    print(f"✅ Replaced Stitch name '{stitch_name}' with '{REAL_NAME}' ({count} occurrences)")
else:
    print(f"ℹ️  Name already correct or not found in title: '{stitch_name}'")

# ── 2. Replace any US phone numbers that aren't the real one ─────────────────
if REAL_PHONE:
    # Pattern: (XXX) XXX-XXXX, XXX-XXX-XXXX, XXX.XXX.XXXX, +1XXXXXXXXXX
    phone_pattern = r'\(?\d{3}\)?[\s.\-]\d{3}[\s.\-]\d{4}'
    fake_phones = re.findall(phone_pattern, html)
    replaced_phones = set()
    for fake in fake_phones:
        # Normalize: strip non-digits
        digits = re.sub(r'\D', '', fake)
        real_digits = re.sub(r'\D', '', REAL_PHONE)
        if digits != real_digits and fake not in replaced_phones:
            html = html.replace(fake, REAL_PHONE)
            replaced_phones.add(fake)
    if replaced_phones:
        print(f"✅ Replaced phones {replaced_phones} → {REAL_PHONE}")
    else:
        print(f"ℹ️  No placeholder phones found (real phone: {REAL_PHONE})")

# ── 3. Replace Stitch-invented address lines ──────────────────────────────────
if REAL_ADDRESS:
    # Match common address patterns Stitch uses: "123 Main St", "456 N Michigan Ave", etc.
    addr_pattern = r'\d+\s+[NSEW]?\s*\w+(?:\s+\w+)?\s+(?:Ave|St|Blvd|Dr|Rd|Ln|Way|Ct|Pl|Pkwy)\.?(?:\s*,\s*[A-Za-z\s]+,\s*[A-Z]{2}\s*\d{5})?'
    fake_addrs = re.findall(addr_pattern, html, flags=re.IGNORECASE)
    replaced_addrs = set()
    for fake in fake_addrs:
        fake_stripped = fake.strip()
        real_stripped = REAL_ADDRESS.strip()
        # Normalize for comparison
        if fake_stripped.lower() != real_stripped.lower() and fake_stripped not in replaced_addrs:
            html = html.replace(fake_stripped, real_stripped)
            replaced_addrs.add(fake_stripped)
    if replaced_addrs:
        print(f"✅ Replaced addresses: {replaced_addrs}")
    else:
        print(f"ℹ️  No placeholder addresses found")

# ── 4. Replace tel: links with real phone ────────────────────────────────────
if REAL_PHONE:
    real_tel = re.sub(r'\D', '', REAL_PHONE)
    if not real_tel.startswith('1'):
        real_tel_link = f"+1{real_tel}"
    else:
        real_tel_link = f"+{real_tel}"
    # Replace any tel: href that isn't the real number
    html = re.sub(r'href="tel:[^"]*"', f'href="tel:{real_tel_link}"', html)
    print(f"✅ All tel: links updated to {real_tel_link}")

with open("${BUILD_DIR}/index.html", "w") as f:
    f.write(html)
print("✅ NAP injection complete")
NAP_INJECT_EOF

echo ""

# ── Post-process: Strip GSAP — content always visible, no animation hiding ────
# GSAP opacity:0 animations cause blank pages. We remove GSAP entirely.
# Content must be visible without JS. No exceptions.
echo "Stripping GSAP animations for always-visible content..."

python3 << PYFIX_EOF
import re

with open("$BUILD_DIR/index.html", "r") as f:
    html = f.read()

# 1. Remove GSAP <script> tags
html = re.sub(r'<script[^>]*gsap[^>]*></script>\s*', '', html)
html = re.sub(r'<script[^>]*ScrollTrigger[^>]*></script>\s*', '', html)

# 2. Fix any opacity:0 or opacity: 0 in <style> blocks — set to 1
def fix_style_block(m):
    style = m.group(0)
    # Replace opacity:0 / opacity: 0 with opacity:1 (skip :hover, .active, .open, .hamburger)
    lines = style.split('\n')
    result = []
    in_safe = False
    for line in lines:
        if any(x in line for x in [':hover', '.active', '.open', '.hamburger', 'nav-drawer']):
            in_safe = True
        if '}' in line and in_safe:
            in_safe = False
            result.append(line)
            continue
        if not in_safe:
            line = re.sub(r'opacity:\s*0(?!\.)', 'opacity: 1', line)
            line = re.sub(r'opacity:0(?!\.)', 'opacity:1', line)
        result.append(line)
    return '\n'.join(result)

html = re.sub(r'<style[^>]*>.*?</style>', fix_style_block, html, flags=re.DOTALL)

# 3. Strip GSAP from any external css/styles.css link (add version to bust cache)
# (handled separately in multi-file builds)

with open("$BUILD_DIR/index.html", "w") as f:
    f.write(html)
print("✅ GSAP stripped — content always visible")
PYFIX_EOF

# ── Fix nav links to use .html extensions (GitHub Pages serves real files) ────
# Stitch generates href="#", href="/about", href="about" — all broken on GitHub Pages.
# We fix all patterns: #, /about, about → about.html (by matching visible link text)
echo "Fixing nav links to use .html extensions..."
python3 << FIX_NAV_EOF
import re

with open("${BUILD_DIR}/index.html", "r") as f:
    html = f.read()

# Strategy 1: Fix explicit path hrefs: /about → about.html, /services → services.html
pages = ['about', 'services', 'contact']
for page in pages:
    html = re.sub(r'href=["\']/' + page + r'/?["\']', f'href="{page}.html"', html)
    html = re.sub(r'href=["\']' + page + r'["\']', f'href="{page}.html"', html)

# Strategy 2: Fix href="#" by matching visible anchor text (Stitch's most common pattern)
# <a class="..." href="#">About</a> → <a class="..." href="about.html">About</a>
text_to_page = {
    'about': 'about.html',
    'services': 'services.html',
    'our services': 'services.html',
    'contact': 'contact.html',
    'contact us': 'contact.html',
}

def fix_hash_link(m):
    full = m.group(0)
    # Extract visible text (strip inner tags)
    inner = re.sub(r'<[^>]+>', '', full).strip().lower()
    for key, target in text_to_page.items():
        if inner == key or inner.startswith(key):
            return full.replace('href="#"', f'href="{target}"')
    return full

html = re.sub(r'<a\b[^>]*href="#"[^>]*>.*?</a>', fix_hash_link, html, flags=re.DOTALL|re.IGNORECASE)

# Strategy 3: Fix anchor hrefs that match subpage names
# href="#about" → about.html, href="#services" → services.html, href="#contact" → contact.html
anchor_to_page = {
    '#about': 'about.html',
    '#services': 'services.html',
    '#contact': 'contact.html',
    '#contact-us': 'contact.html',
    '#our-services': 'services.html',
}
for anchor, page in anchor_to_page.items():
    html = re.sub(r'href=["\']' + re.escape(anchor) + r'["\']', f'href="{page}"', html)

# Also fix subpage nav links — they copy the same anchor pattern
for subpage in ['about.html', 'services.html', 'contact.html']:
    subpath = '${BUILD_DIR}/' + subpage
    import os
    if os.path.exists(subpath):
        with open(subpath, 'r') as sf:
            shtml = sf.read()
        for anchor, page in anchor_to_page.items():
            shtml = re.sub(r'href=["\']' + re.escape(anchor) + r'["\']', f'href="{page}"', shtml)
        # Fix self-referencing anchors on subpages to point back to index
        shtml = re.sub(r'href=["\']#home["\']', 'href="index.html"', shtml)
        shtml = re.sub(r'href=["\']#stats["\']', 'href="index.html#stats"', shtml)
        shtml = re.sub(r'href=["\']#testimonials["\']', 'href="index.html#testimonials"', shtml)
        shtml = re.sub(r'href=["\']#faq["\']', 'href="index.html#faq"', shtml)
        with open(subpath, 'w') as sf:
            sf.write(shtml)

# Report what was fixed
fixed = re.findall(r'href="(about\.html|services\.html|contact\.html)"', html)
with open("${BUILD_DIR}/index.html", "w") as f:
    f.write(html)
print(f"✅ Nav links fixed: {fixed}")
FIX_NAV_EOF

echo ""

# ── Step 3: Generate hero image with Gemini ─────────────────────────────────
echo "━━━ STEP 3: Generating hero image with Gemini ━━━"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/gen-image.py" "$NICHE" "$CITY" "$BUILD_DIR/assets/hero-main.jpg" || echo "⚠️ Hero image gen failed — using placeholder"
echo ""

# ── Step 4: Generate multi-page site with Python subpage generator ────────────
echo "━━━ STEP 4: Generating styled subpages ━━━"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/gen-subpages.py" "$BUILD_DIR" "$BUSINESS_NAME" "$NICHE" "$CITY" "$SLUG" "${PHONE:-}" "${ADDRESS:-}"

# Generate 404.html — simple redirect to home
cat > "$BUILD_DIR/404.html" << 'NOTFOUND_EOF'
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Page Not Found</title>
<meta http-equiv="refresh" content="0; url=index.html">
</head>
<body>
<p>Page not found. <a href="index.html">Return home</a></p>
</body>
</html>
NOTFOUND_EOF
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

# ── Step 4b: Inject random theme CSS into all HTML files ─────────────────────
echo "━━━ STEP 4B: Injecting random design theme ━━━"
python3 << THEME_INJECT_EOF
import random, re

# Pick random theme
THEME_NUM = random.randint(0, 7)

THEMES = {
    0: {"primary": "#0D2818", "bg": "#111111", "accent": "#4CAF50", "font": "'DM Sans', system-ui, sans-serif", "name": "midnight-forest", "text_color": "#e8e8e8"},
    1: {"primary": "#0A1628", "bg": "#0F1923", "accent": "#5BA4E6", "font": "'Inter', system-ui, sans-serif", "name": "deep-navy", "text_color": "#e2e8f0"},
    2: {"primary": "#1A0F0A", "bg": "#151010", "accent": "#D4956A", "font": "'Playfair Display', Georgia, serif", "name": "dark-espresso", "text_color": "#ede0d4"},
    3: {"primary": "#0D2B35", "bg": "#0E1A1F", "accent": "#4DB6AC", "font": "'Work Sans', system-ui, sans-serif", "name": "deep-ocean", "text_color": "#d4e8e4"},
    4: {"primary": "#1C0B0B", "bg": "#131010", "accent": "#E63329", "font": "'Oswald', system-ui, sans-serif", "name": "chalk-iron", "text_color": "#eee"},
    5: {"primary": "#0F1114", "bg": "#131313", "accent": "#B87333", "font": "'Inter', system-ui, sans-serif", "name": "slate-copper", "text_color": "#c8c8c8"},
    6: {"primary": "#111111", "bg": "#0E0E0E", "accent": "#A8B48B", "font": "'DM Serif Display', Georgia, serif", "name": "monochrome-sage", "text_color": "#d4d4d4"},
    7: {"primary": "#0D0D1A", "bg": "#111118", "accent": "#C9A84C", "font": "'Clash Display', system-ui, sans-serif", "name": "midnight-gold", "text_color": "#f0e8d4"},
}

theme = THEMES[THEME_NUM]
print(f"✅ Selected theme {THEME_NUM}: {theme['name']}")

theme_css = f"""<style id="forge-theme">
:root {{
  --primary: {theme['primary']};
  --bg: {theme['bg']};
  --accent: {theme['accent']};
  --text: {theme['text_color']};
  --text-light: {theme['text_color']}cc;
  --header-font: {theme['font']};
}}
/* Dark theme overrides — all backgrounds dark, all text light */
body, body[style], html {{ background-color: {theme['bg']} !important; color: {theme['text_color']} !important; }}
header[style], nav[style], .header[style], .navbar[style] {{ background-color: {theme['primary']} !important; }}
footer[style], .footer[style] {{ background-color: {theme['primary']} !important; color: {theme['text_color']} !important; }}
section, section[style], div[style*="background"] {{ background-color: {theme['bg']} !important; color: {theme['text_color']} !important; }}
h1, h2, h3, h4, h1[style], h2[style], h3[style], h4[style] {{ color: {theme['text_color']} !important; font-family: {theme['font']} !important; }}
p, span, li, td, th, label, blockquote {{ color: {theme['text_color']} !important; }}
[class*="hero"][style], [class*="hero"] div[style] {{ background-color: {theme['primary']} !important; }}
[class*="hero"] h1, [class*="hero"] h2 {{ color: #fff !important; }}
a:not(button a) {{ color: {theme['accent']} !important; }}
button, .btn, [class*="btn"], input[type="submit"] {{ background-color: {theme['accent']} !important; color: #fff !important; border-color: {theme['accent']} !important; }}
/* Card surfaces — slightly lighter than body bg for depth */
[class*="card"], [class*="testimonial"], [class*="service"] {{ background-color: color-mix(in srgb, {theme['bg']} 85%, white) !important; }}
</style>
<script id="forge-theme-js">
(function() {{
  function applyTheme() {{
    var primary = '{theme['primary']}';
    var bg = '{theme['bg']}';
    var accent = '{theme['accent']}';
    var textColor = '{theme['text_color']}';
    // Override body background + text
    document.body.style.setProperty('background-color', bg, 'important');
    document.body.style.setProperty('color', textColor, 'important');
    // Override ALL text elements to light color
    document.querySelectorAll('p, span, li, td, th, label, blockquote, h1, h2, h3, h4, h5, h6').forEach(function(el) {{
      el.style.setProperty('color', textColor, 'important');
    }});
    // Override header/nav
    document.querySelectorAll('header, nav, .header, .navbar, [class*="header"], [class*="navbar"]').forEach(function(el) {{
      el.style.setProperty('background-color', primary, 'important');
    }});
    // Override sections
    document.querySelectorAll('section, [class*="section"]').forEach(function(el) {{
      el.style.setProperty('background-color', bg, 'important');
      el.style.setProperty('color', textColor, 'important');
    }});
    // Override footer
    document.querySelectorAll('footer, .footer, [class*="footer"]').forEach(function(el) {{
      el.style.setProperty('background-color', primary, 'important');
      el.style.setProperty('color', textColor, 'important');
    }});
    // Override hero sections
    document.querySelectorAll('[class*="hero"], [id*="hero"]').forEach(function(el) {{
      el.style.setProperty('background-color', primary, 'important');
    }});
    // Override buttons
    document.querySelectorAll('button, .btn, [class*="btn"], input[type="submit"]').forEach(function(el) {{
      el.style.setProperty('background-color', accent, 'important');
      el.style.setProperty('border-color', accent, 'important');
      el.style.setProperty('color', '#fff', 'important');
    }});
    // Override links (not inside buttons)
    document.querySelectorAll('a:not(button a)').forEach(function(el) {{
      if (!el.closest('button') && !el.classList.toString().includes('btn')) {{
        el.style.setProperty('color', accent, 'important');
      }}
    }});
  }}
  if (document.readyState === 'loading') {{
    document.addEventListener('DOMContentLoaded', applyTheme);
  }} else {{
    applyTheme();
  }}
}})();
</script>"""

for page in ["index.html", "about.html", "services.html", "contact.html"]:
    path = f"${BUILD_DIR}/" + page
    try:
        with open(path, "r") as f:
            html = f.read()
        # Insert before </head>
        html = re.sub(r'</head>', theme_css + '\n</head>', html, count=1)
        with open(path, "w") as f:
            f.write(html)
        print(f"  ✅ {page} themed")
    except Exception as e:
        print(f"  ⚠️  {page} error: {e}")
THEME_INJECT_EOF

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
