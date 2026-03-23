---
name: website-remake
description: Autonomous pipeline — find businesses with outdated websites, rebuild to $10K quality using Google Stitch for UI generation (multi-page architecture, GSAP scroll effects, AI hero images), deploy demos to GitHub Pages, log to Notion, send cold outreach. Netlify for production handoff only. Runs end-to-end without human intervention.
tags:
  - business-development
  - web-design
  - sales
  - ai-automation
  - lead-generation
version: 5.0.0
agent_model: sonnet
notes: "All subagent spawns for this skill MUST use Sonnet. Haiku is too weak for multi-page site builds. Stitch SDK generates the homepage HTML/CSS — Claude Code expands it into full multi-page architecture."
metadata:
  openclaw:
    requires:
      env:
        - STITCH_API_KEY
        - NETLIFY_TOKEN
        - GEMINI_API_KEY
        - AGENTMAIL_API_KEY
---

# Website Remake — Master Skill v4

---

## ⛔ HARD RULES — READ FIRST

1. **NO EMOJIS** in the built site. Ever. Use SVG icons or icon fonts (Lucide, Heroicons, Phosphor).
2. **DARK MODE MANDATORY.** Background must never be `#FFFFFF`, `#F5F5F5`, `#FAFAFA`, or any near-white. Use rich dark tones: charcoal, dark navy, deep forest, dark teal, espresso. White/cream is text/accent only.
3. **MOBILE-FIRST MANDATORY.** CSS written mobile-first (`min-width` media queries to scale up). Touch targets ≥ 44px. `clamp()` for headlines. Grid/flex collapse at 768px. Hamburger nav required. `max-width: 100%` on all images. Test at 375px, 390px, 768px.
4. **NO PURPLE.** No violet, indigo, lavender — not as gradient, not as accent, not anywhere. This is the #1 AI slop tell.
5. **NO FAKE DATA.** Never invent phone numbers, addresses, or business names. Extract verbatim from the original site or leave `<!-- TODO: INSERT REAL [FIELD] -->`.
6. **MULTI-PAGE ARCHITECTURE MANDATORY.** Every build produces multiple HTML files. A single `index.html` is a FAILED BUILD. See Completion Gate below.
7. **NEVER use Vercel or Wix.** Deploy demos to GitHub Pages (free). Netlify is for production handoff after client payment only.
8. **DISCORD: WRAP ALL URLS IN `<angle brackets>`.** Always post links as `<https://example.com>` — never bare URLs. Bare URLs generate large link previews that pollute #announcements.
9. **DISCORD: ONE MESSAGE, SILENT RUN.** No narration during the run. No "spawning", "yielding", "pipeline running" messages. Post one clean components card to #announcements only when all builds are done.

---

## 🔄 PIPELINE EXECUTION CHECKLIST — RUN TOP TO BOTTOM

This is the autonomous execution flow. Run each step in order. No human approval needed. No skipping steps.

```
┌─────────────────────────────────────────────────┐
│  PIPELINE EXECUTION — MANDATORY SEQUENCE        │
├─────────────────────────────────────────────────┤
│  1. FIND TARGET         → Brave Search          │
│  2. SCRAPE NAP          → curl + Firecrawl      │
│  3. STITCH HOMEPAGE     → Google Stitch SDK     │
│  4. GENERATE IMAGES     → Nano Banana (Imagen)  │
│  5. EXPAND TO MULTI-PAGE → Claude Code          │
│  6. RUN COMPLETION GATE → verify files on disk  │
│  7. DEPLOY TO GITHUB PAGES → gh repo create + push  │
│  8. LOG TO NOTION       → API call to tracker DB    │
│  9. SEND COLD EMAIL     → AgentMail API              │
│ 10. POST TO #announcements → old URL + new URL + email│
└─────────────────────────────────────────────────┘
```

### Step 1: Find Target

**TARGET DIVERSITY — MANDATORY. Read this before searching.**

Before picking a niche and city, check the target memory log:
```bash
tail -10 /Users/andreofastora/.openclaw/workspace/target-memory.log 2>/dev/null || echo "No log yet"
```

**Re-pick rules (enforced, not suggested):**
- If last build was in Chicago → pick a different city this time
- If last build was auto repair → pick a different niche this time
- If last 2 builds were in the same state → pick a different state
- If last 2 builds were trades (auto, roofing, plumbing, HVAC) → pick a service business (dentist, law, salon, restaurant)
- Never pick the same niche+city combination twice in a row

**Approved city rotation (do NOT repeat the same city within 5 builds — use the log to check):**

Northeast: Boston, Philadelphia, New York, Baltimore, Pittsburgh, Providence, Hartford, Buffalo
Southeast: Miami, Atlanta, Tampa, Charlotte, Nashville, Orlando, Raleigh, Jacksonville, New Orleans, Richmond
Midwest: Chicago, Houston, Dallas, San Antonio, Columbus, Indianapolis, Detroit, Kansas City, Milwaukee, Minneapolis, Cincinnati, Cleveland, Louisville, St. Louis, Oklahoma City
West: Phoenix, Denver, Seattle, Las Vegas, Portland, Salt Lake City, Tucson, Albuquerque, Sacramento, Fresno, Colorado Springs, Bakersfield
Southwest: San Diego, El Paso, Fort Worth, Corpus Christi, Lubbock, Amarillo, Brownsville, Laredo

Pick at random from the full list above. Use the log to avoid repeating a city used in the last 5 builds.

**Approved niche rotation (alternate between categories):**
- Trades: auto repair, roofing, plumbing, HVAC, electrician, landscaping
- Medical/Professional: dentist, chiropractor, optometrist, law firm, accountant
- Food/Hospitality: restaurant, cafe, catering, food truck, bakery
- Beauty/Wellness: hair salon, nail salon, spa, gym, yoga studio
- Retail/Service: florist, pet groomer, dry cleaner, locksmith, moving company

After selecting target, append to log:
```bash
echo "[$(date +%Y-%m-%d)] [BUSINESS_NAME] | City:[CITY] State:[STATE] Niche:[NICHE]" \
  >> /Users/andreofastora/.openclaw/workspace/target-memory.log
```

```bash
# Search for outdated local business sites
# Use web_search with queries like: "[niche] [city]" based on rotation above
# Pick a business with: 4+ star Google reviews, website exists but looks pre-2018, local focus
# Signs of a weak site: Wix/Squarespace free subdomain, no HTTPS, copyright year 3+ years old,
#   broken mobile, phone number not in header, no Google Maps on contact page
```

### Step 2: Scrape NAP (Name, Address, Phone)
```bash
# Extract EXACT business info — never guess
curl -sL "https://[TARGET_SITE]" | grep -oE '\(?\b[0-9]{3}\)?[-.\s][0-9]{3}[-.\s][0-9]{4}\b' | sort -u
# Also extract: business name, address, services list, testimonials, photos
# Use Firecrawl for structured content extraction
# Lock these values BEFORE writing any code:
#   BUSINESS_NAME: [exact]
#   PHONE: [exact]
#   ADDRESS: [exact]
#   SERVICES: [list from site]
```

### Step 3: Generate Homepage with Google Stitch

**Stitch replaces both video gen and manual HTML writing for the homepage.** It uses Gemini 2.5 Pro to generate a complete high-fidelity UI design + clean HTML/CSS in one shot, customized to the business's niche, brand, and real NAP data.

```javascript
// Install once: npm install @google/stitch-sdk (in /tmp/rebuild/[slug]/)
// API key: /Users/andreofastora/.openclaw/workspace/.secrets/stitch-api-key.txt

import { StitchToolClient } from "@google/stitch-sdk";
import { writeFileSync, mkdirSync } from 'fs';
import { execSync } from 'child_process';

const STITCH_API_KEY = require('fs').readFileSync(
  '/Users/andreofastora/.openclaw/workspace/.secrets/stitch-api-key.txt', 'utf8'
).trim();

const client = new StitchToolClient({ apiKey: STITCH_API_KEY });

// 1. Create project
const projectResult = await client.callTool("create_project", {
  title: `${BUSINESS_NAME} — Rebuild Demo`
});
const projectId = projectResult.projectId || projectResult.name?.split('/')[1];
console.log("Stitch project ID:", projectId);

// 2. Generate homepage — use real NAP data from Step 2
const screenResult = await client.callTool("generate_screen_from_text", {
  projectId,
  prompt: buildStitchPrompt(BUSINESS_NAME, NICHE, CITY, STATE, PHONE, ADDRESS, SERVICES, COLOR_SYSTEM),
  deviceType: "DESKTOP"
});

// 3. Get HTML download URL and screenshot URL
function findUrls(obj, depth=0) {
  const urls = { html: null, image: null };
  if (depth > 6 || typeof obj !== 'object' || !obj) return urls;
  for (const [k, v] of Object.entries(obj)) {
    if (typeof v === 'string') {
      if (v.startsWith('https://contribution.usercontent.google.com') && !urls.html) urls.html = v;
      if (v.startsWith('https://lh3.googleusercontent.com') && !urls.image) urls.image = v;
    }
    if (typeof v === 'object') {
      const sub = findUrls(v, depth+1);
      if (sub.html && !urls.html) urls.html = sub.html;
      if (sub.image && !urls.image) urls.image = sub.image;
    }
  }
  return urls;
}

const { html: htmlUrl, image: imageUrl } = findUrls(screenResult);

// 4. Download HTML and screenshot
const { execSync } = await import('child_process');
mkdirSync(`/tmp/rebuild/${SLUG}/assets`, { recursive: true });
execSync(`curl -sL "${htmlUrl}" -o /tmp/rebuild/${SLUG}/index.html`);
execSync(`curl -sL "${imageUrl}" -o /tmp/rebuild/${SLUG}/assets/stitch-preview.jpg`);

console.log("Stitch homepage downloaded.");
await client.close();
```

**Stitch prompt builder — fill in real data from Step 2:**

```javascript
function buildStitchPrompt(name, niche, city, state, phone, address, services, colorSystem) {
  const nicheInstructions = {
    'auto repair': 'Dark industrial theme. Bold sans-serif headlines (Oswald or Clash Display). Red accent. Phone number in hero. Free estimate CTA. Trust badges (years in business, ASE certified). No emojis. No purple.',
    'roofing': 'Dark bold theme. Industrial trust signals. Free inspection CTA. Years in business counter. Storm damage section.',
    'law firm': 'Authoritative dark theme. Serif headlines (Playfair Display). Practice area pages. Free consultation CTA. Bar credentials visible.',
    'dentist': 'Dark professional theme. Soft teal or gold accent. Before/after gallery placeholder. New patient CTA. Insurance info.',
    'restaurant': 'Warm dark theme. Serif + sans pairing. Menu link in hero. Hours prominently placed. Reservation CTA. Food photography dominant.',
    'salon': 'Dark elegant theme. Thin serif headlines. Booking CTA everywhere. Service menu with prices. Gallery section.',
    'plumbing': 'Dark bold theme. 24/7 emergency banner. Phone number massive in hero. Same-day service CTA.',
  };

  const instructions = Object.entries(nicheInstructions)
    .find(([key]) => niche.toLowerCase().includes(key))?.[1]
    || 'Dark professional theme. No emojis. No purple. Mobile-first layout.';

  return `
Homepage for ${name}, a ${niche} business in ${city}, ${state}.

DESIGN RULES:
- ${instructions}
- Dark background mandatory — never white or near-white
- No emojis anywhere on the page
- No purple, violet, lavender, or indigo
- Mobile-first responsive layout
- GSAP scroll animations (fade-up on scroll)
- Color system: ${colorSystem}

REAL BUSINESS DATA (use verbatim, do not invent):
- Business name: ${name}
- Phone: ${phone}
- Address: ${address}
- City/State: ${city}, ${state}
- Services: ${services.join(', ')}

REQUIRED SECTIONS:
1. Nav bar — logo left, links right, phone number visible, CTA button
2. Hero — large headline with "${city}'s Trusted ${niche}", subtext, dual CTA (primary: call phone, secondary: see services)
3. Services grid — one card per service, icon (SVG Lucide), short description
4. Trust/stats bar — years in business, customers served, 5-star reviews count
5. Testimonials — 3 review cards with stars, name, city
6. Contact section — address, phone, email, map placeholder
7. Footer — all nav links, phone, address, copyright

OUTPUT: Clean semantic HTML + embedded CSS. No external dependencies except GSAP CDN. No framework boilerplate.
`.trim();
}
```

**After Stitch generates the homepage:**
- Save the HTML to `/tmp/rebuild/[slug]/index.html`
- Save the screenshot to `/tmp/rebuild/[slug]/assets/stitch-preview.jpg`
- The Stitch HTML is the homepage. Claude Code expands it in Step 5.

**Stitch design system extraction (optional — use for existing branded clients):**
```javascript
// Extract design system from any URL
const designResult = await client.callTool("extract_design_system", {
  url: ORIGINAL_URL
});
// Returns: colors, fonts, spacing — use these in your Stitch prompt for brand consistency
```

### Step 4: Generate Nano Banana Images (Hero + Service Cards)

Generate hero background and service card images to swap into the Stitch HTML:

```python
import urllib.request, json, base64, os

GEMINI_API_KEY = open('/Users/andreofastora/.openclaw/workspace/.secrets/gemini-api-key.txt').read().strip()
OUT_DIR = f"/tmp/rebuild/{SLUG}/assets"
os.makedirs(OUT_DIR, exist_ok=True)

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
    with urllib.request.urlopen(req) as resp:
        d = json.load(resp)
    with open(f"{OUT_DIR}/{filename}", 'wb') as f:
        f.write(base64.b64decode(d['predictions'][0]['bytesBase64Encoded']))
    print(f"Generated: {filename}")

# Niche-appropriate prompts — fill in the business context
generate_image(f"Cinematic wide shot of a professional {NICHE} business in {CITY}, dramatic lighting, dark atmospheric background, high quality editorial photography", "hero-main.jpg")
generate_image(f"Close-up professional shot of {SERVICES[0]} in progress, dark workshop environment, dramatic lighting", "service-1.jpg")
generate_image(f"Editorial shot of {SERVICES[1]} equipment and tools, dark background, cinematic", "service-2.jpg")
generate_image(f"Professional action shot of {SERVICES[2]} work being done, dark industrial aesthetic", "service-3.jpg")
```

After generating, swap the placeholder images in the Stitch HTML with these real ones.

### Step 5: Expand to Multi-Page Architecture
Claude Code takes the Stitch homepage and builds out the full required file structure.

### Step 6: Run Completion Gate
See "COMPLETION GATE" section below. Build is not done until gate passes.

### Step 7: Deploy to GitHub Pages (FREE — outreach demos only)
```bash
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"
SITE_SLUG="[business-name-slug]"  # e.g. takase-auto-rebuild
SITE_DIR="/tmp/rebuild/$SITE_SLUG"

cd "$SITE_DIR"
git init
git add .
git commit -m "feat: website rebuild for $SITE_SLUG"

# Create public repo under oh-ashen-one org
gh repo create "oh-ashen-one/$SITE_SLUG" --public --source . --remote origin --push

# Enable GitHub Pages on main branch root
gh api "repos/oh-ashen-one/$SITE_SLUG/pages" \
  -X POST \
  -f source[branch]=main \
  -f source[path]=/ \
  --silent

# Live URL (may take 60s to go live):
DEMO_URL="https://oh-ashen-one.github.io/$SITE_SLUG"
echo "Demo URL: $DEMO_URL"
```

**Why GitHub Pages:**
- Free. Zero monthly cost. No account limits for public repos.
- These are outreach demos — not production sites. They just need to be viewable.
- Netlify is for production only: ForgeAI SEO itself, client handoffs after payment.
- GitHub Pages URL format: `oh-ashen-one.github.io/[site-slug]`
- Pages goes live in ~60 seconds after push. Wait before sending the cold email.

### Step 8: Log to Notion
```bash
NOTION_TOKEN=$(cat ~/.openclaw/workspace/.secrets/notion.env | grep NOTION_API_KEY | cut -d= -f2)
DB_ID="327664f6-a1e3-81e8-879d-ff9d14f95213"
curl -s -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{
    "parent": {"database_id": "'$DB_ID'"},
    "properties": {
      "Business Name": {"title": [{"text": {"content": "[BUSINESS_NAME]"}}]},
      "Original URL": {"url": "[ORIGINAL_URL]"},
      "Demo URL": {"url": "[DEMO_URL]"},
      "Niche": {"select": {"name": "[NICHE]"}},
      "City": {"rich_text": [{"text": {"content": "[CITY]"}}]},
      "Phone": {"phone_number": "[PHONE]"},
      "Email Sent": {"checkbox": false},
      "Email Address": {"email": "[OWNER_EMAIL]"},
      "Status": {"select": {"name": "Built"}},
      "Agent": {"select": {"name": "Andre"}},
      "Date Built": {"date": {"start": "[YYYY-MM-DD]"}},
      "Notes": {"rich_text": [{"text": {"content": "Demo built [YYYY-MM-DD]. Awaiting email send."}}]}
    }
  }'
```

### Step 9: Send Cold Email via AgentMail
```bash
AGENTMAIL_API_KEY=$(cat ~/.openclaw/workspace/.secrets/agentmail-api-key.txt | tr -d '[:space:]')
curl -s -X POST "https://api.agentmail.to/v0/inboxes/forgeaiseo@agentmail.to/messages/send" \
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": ["[OWNER_EMAIL]"],
    "from_display_name": "Alison | Teza",
    "subject": "[BUSINESS_NAME] — we rebuilt your entire website",
    "text": "Hi [FIRST_NAME or 'there'],\n\nMy name is Alison, from Teza. We help small businesses rebuild their digital footprint using AI — new websites, SEO, the works.\n\nWe rebuilt your entire website because we noticed a few problems with your current one: [SPECIFIC_PROBLEMS].\n\nThese kinds of issues are quietly costing you customers every week.\n\nTake a look at what we built:\n[DEMO_URL]\n\nCompletely free to browse — no credit card, no catch.\n\nIf you like it, we'd love to sell it to you. We can have the whole thing running on your own domain within 24 hours. If it's not for you, no pressure at all — just let us know.\n\n— Alison\nTeza"
  }'

# MANDATORY: Update Notion row after email sends — run this immediately after the email API call
# Captures: email sent date, subject used, observation that triggered the email, full status update
NOTION_TOKEN=$(grep NOTION_API_KEY /Users/andreofastora/.openclaw/workspace/.secrets/notion.env | cut -d= -f2)
EMAIL_DATE=$(date -u +"%Y-%m-%d")
curl -s -X PATCH "https://api.notion.com/v1/pages/[NOTION_PAGE_ID]" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d "{
    \"properties\": {
      \"Email Sent\": {\"checkbox\": true},
      \"Status\": {\"select\": {\"name\": \"Emailed\"}},
      \"Notes\": {\"rich_text\": [{\"text\": {\"content\": \"Demo built $EMAIL_DATE. Cold email sent $EMAIL_DATE to [OWNER_EMAIL]. Subject: [EMAIL_SUBJECT]. Observation: [ONE_SPECIFIC_THING_NOTICED_ON_THEIR_SITE]. Template used: d4=[TEMPLATE_NUMBER].\"}}]}
    }
  }"
# Verify output — Email Sent must be true before proceeding to Step 10
echo "Notion updated. Verifying..."
```

**Email sender:** `forgeaiseo@agentmail.to` — display name "Alex | Forge"

---

### Step 10: Post to #announcements

After email is sent, post ONE message to Discord channel **1480787296729960468** (#announcements) using a **components container block** with this exact format:

```
**[BUSINESS_NAME]** — [CITY], [STATE] | [NICHE]
Old site: <[ORIGINAL_URL]>
New site: <[DEMO_URL]>
Notion: <https://www.notion.so/[NOTION_PAGE_ID_NO_DASHES]>
Emailed [OWNER_EMAIL]
```

**Rules:**
- Post to #announcements ONLY (channel ID: 1480787296729960468)
- **WRAP ALL URLS IN `<angle brackets>`** — e.g. `<https://example.com>` — this suppresses Discord link previews. Never paste a bare URL.
- Use Discord message tool with components container block — NOT plain text
- DO NOT paste the full email body in Discord — forward it to Hari's email instead (see below)
- **NO narration at any point during the run** — no "spawning subagent", "let me yield", "pipeline running" etc.
- ONE message total — after all builds complete, not one per site
- This is the only Discord message — no other channels

**After posting to #announcements, forward the email via AgentMail:**
```bash
AGENTMAIL_KEY=$(cat /Users/andreofastora/.openclaw/workspace/.secrets/agentmail-api-key.txt | tr -d '[:space:]')
curl -s -X POST "https://api.agentmail.to/v0/inboxes/forgeaiseo@agentmail.to/messages/send" \
  -H "Authorization: Bearer $AGENTMAIL_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": ["haritth@gmail.com"],
    "subject": "FWD: [EMAIL_SUBJECT] — sent to [OWNER_EMAIL]",
    "text": "Here is the cold email sent to [BUSINESS_NAME] ([OWNER_EMAIL]):\n\n---\n\n[FULL EMAIL BODY]"
  }'
```
**NEVER use** `friendlycookie166@agentmail.to` — that inbox is retired.

---

## 🎨 DESIGN SYSTEM — STITCH-FIRST, NICHE-GUIDED

**How design decisions work with Stitch in the pipeline:**

Stitch auto-generates a design system during Step 3 — it names it, chooses fonts, colors, spacing, and layout style. The `designMd` field in the Stitch response contains the full design rationale. **Read it** before expanding to multi-page in Step 5 — it tells you exactly what Stitch built and why.

**Your job:** Guide Stitch with niche + real data in the prompt (Step 3). Stitch executes. Claude Code expands using the same system Stitch established.

**When Stitch design diverges from rules:**
- If Stitch picked purple → override in the Step 5 Claude Code expansion (`--override-color`)
- If Stitch picked white background → add `background: #131313` to `body` in `styles.css`
- If Stitch used emojis → strip them in the expansion step

The dice rolls below are now **fallback only** — use them when you need to override Stitch's choices or when building without Stitch.

Every build has two layers:
1. **Niche vibe** — locked. A roofing company always feels like a trades site. A restaurant always feels warm and food-forward. Never random.
2. **Color, typography, motion, nav** — guided by Stitch prompt, with niche-appropriate overrides below.

---

### STEP 1: Identify Niche → Lock Vibe

**TRADES** (roofing, plumbing, HVAC, auto, electrician, landscaping)
- Vibe: Bold, industrial, no-nonsense. Built to instill trust in working-class homeowners.
- Typography: Heavy sans-serif headlines — Oswald, Bebas Neue, Clash Display. Body: DM Sans or Inter.
- Hero imagery: Hands working, job sites, equipment, before/after. NOT stock smiling people.
- Trust signals: Years in business counter, license numbers, BBB/certifications, free estimate CTA always visible.
- Layout feel: Dense and informative. Phone number in header always. Address visible.
- Banned: Script fonts, decorative serifs, minimalist whitespace layouts, anything that looks like a tech startup.

**LAW / MEDICAL / PROFESSIONAL** (law firms, dentists, chiropractors, accountants, consultants)
- Vibe: Authority and calm. Clients need to trust you with serious problems.
- Typography: Serif or authoritative sans — Playfair Display, Cormorant, or DM Serif for headings. DM Sans body.
- Hero imagery: Office interiors, consultations, city skylines, professional portraits. Clean.
- Trust signals: Years of experience, case results/testimonials, practice area pages, consultation CTA.
- Layout feel: Editorial and spacious. Clear hierarchy. Long-scroll storytelling.
- Banned: Loud accent colors, industrial fonts, counter animations for trivial stats, anything flashy.

**RESTAURANT / FOOD / CAFE / BAKERY**
- Vibe: Warm, appetizing, inviting. Makes you want to eat there right now.
- Typography: Mix of an elegant serif (Cormorant, Playfair) for dish names/headlines + clean sans for body.
- Hero imagery: Food close-ups, plated dishes, restaurant ambiance, kitchen action. Shot in warm light.
- Trust signals: Hours, location, reservations CTA, menu link, real reviews.
- Layout feel: Magazine editorial. Generous food photography. Menu section essential.
- Banned: Cold blue tones, industrial aesthetic, stat counters, anything that feels corporate.

**BEAUTY / WELLNESS** (salons, spas, gyms, yoga studios, nail bars)
- Vibe: Soft, aspirational, personal. Clients are treating themselves.
- Typography: Elegant thin serif + light sans. Cormorant Garamond, Libre Baskerville, or similar.
- Hero imagery: Studio interiors, treatments, before/after transformations, products. Warm and intimate.
- Trust signals: Before/after gallery, client reviews, booking CTA always prominent.
- Layout feel: Airy and spacious. Lots of photography. Soft motion.
- Banned: Heavy industrial fonts, loud accent colors, dense info layouts, anything that feels masculine/aggressive.

**RETAIL / SERVICE** (florists, pet groomers, movers, locksmiths, dry cleaners)
- Vibe: Friendly, local, practical. Accessible and easy to contact.
- Typography: Approachable sans — Plus Jakarta Sans, Nunito, or DM Sans. Clean and readable.
- Hero imagery: Products, storefronts, service in action, happy outcomes (pets, flowers, clean clothes).
- Trust signals: Local area served, hours, phone number, "family-owned" if applicable.
- Layout feel: Clear and practical. Services front and center. Contact easy to find.
- Banned: Overly minimal/luxurious feel, aggressive dark aesthetics, anything that feels intimidating.

---

### STEP 2: Randomize Within Niche

Once niche vibe is locked, randomize the following to keep each build visually distinct.

#### COLOR PALETTE (d8 — filtered by niche)

| Roll | System | Dominant | Accent |
|------|--------|----------|--------|
| 1 | Ash & Ember | Charcoal #1C1C1E | Burnt sienna #B85C38 |
| 2 | Night Forest | Deep forest #1A2E20 | Soft gold #C8922A |
| 3 | Blueprint | Navy #0A1628 | Electric blue #1E6FFF |
| 4 | Chalk & Iron | Near-black #111111 | Red #E63329 or Yellow #F2C94C |
| 5 | Terracotta | Dark espresso #2A1810 | Terracotta #C4622D |
| 6 | Slate & Copper | Cool slate #2D3748 | Copper #B87333 |
| 7 | Monochrome +1 | Black/white only | One accent: sage, dusty rose, or marigold |
| 8 | Deep Ocean | Dark teal #0D2B35 | Aquamarine #4DB6AC |

Niche color filters (re-roll if you land outside these):
- Trades → any roll valid (bold colors suit the niche)
- Law/Medical → rolls 2, 3, 6, 7 preferred. Re-roll 5 (too warm/earthy)
- Restaurant → rolls 1, 2, 5, 6 preferred. Re-roll 3 (too cold/tech)
- Beauty/Wellness → rolls 2, 6, 7 preferred. Soft and warm only.
- Retail/Service → any roll valid

BANNED always: Purple/violet/indigo/lavender. Neon. Rainbow gradients.

#### NAV STYLE (d4 — all niches)

| Roll | Style |
|------|-------|
| 1 | **Full-width bar** — dark bg, logo left, links center, phone/CTA right |
| 2 | **Off-canvas drawer** — minimal wordmark + hamburger, full-screen menu on tap |
| 3 | **Sticky shrink** — large on load, compresses to slim bar on scroll |
| 4 | **Floating island** — small solid pill, centered, appears after scroll |

#### HERO TREATMENT (d4 — filtered by niche)

| Roll | Type |
|------|------|
| 1 | **Full-bleed video** — Veo 2 loop behind dark overlay, text floats above |
| 2 | **Split-screen** — dark panel + text/CTA left, Imagen 4 photo right |
| 3 | **Layered parallax** — 3-depth image layers, text moves at 100% scroll speed |
| 4 | **Editorial full-bleed image** — Imagen 4 fills hero, bold headline overlaid |

Niche hero filters:
- Trades → rolls 1, 2, 4 preferred. Roll 3 acceptable.
- Law/Medical → rolls 2, 4 preferred. Avoid video unless it's tasteful office/city footage.
- Restaurant → rolls 1, 3, 4 preferred. Food photography hero always wins.
- Beauty/Wellness → rolls 2, 3, 4 preferred. Soft and personal.
- Retail/Service → any roll valid.

**Video hero note:** Always include static image fallback (`poster` on `<video>`). Compress to under 3MB. Use `ffmpeg -crf 28`.

#### MOTION SIGNATURE (d6 — filtered by niche)

Pick ONE, apply everywhere consistently.

| Roll | Signature |
|------|-----------|
| 1 | **Clip-path wipe** — content slices in from right on scroll enter |
| 2 | **Staggered float-up** — elements rise from 60px below, opacity 0→1, 0.15s stagger |
| 3 | **Counter animation** — numbers count up from 0 on viewport enter. Trades/professional only. |
| 4 | **Scale + blur reveal** — `scale(0.95) blur(8px)` → sharp on scroll enter |
| 5 | **Line-by-line text reveal** — each line wipes in bottom-to-top, 80ms stagger |
| 6 | **Horizontal marquee** — trust signals, stats, or service names scroll sideways infinitely |

Niche motion filters:
- Trades → rolls 1, 2, 3, 6 preferred
- Law/Medical → rolls 1, 2, 5 preferred. Nothing flashy.
- Restaurant → rolls 2, 4, 5 preferred. Soft and sensory.
- Beauty/Wellness → rolls 2, 4, 5 preferred. Gentle only.
- Retail/Service → any roll valid.

All motion must respect: `@media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; } }`

#### SECTION SEQUENCE (d4 — filtered by niche)

The default sequence (hero → 3-col grid → horizontal band → contact form) is **BANNED**.

| Roll | Sequence |
|------|----------|
| 1 | Hero → Services (tabbed or accordion) → Trust signals/stats → Testimonials → FAQ → Contact |
| 2 | Hero → About/story → Services (alternating image+text) → Testimonials → Contact |
| 3 | Hero → Trust badges → Services grid → Video/media section → Testimonials → FAQ → Contact |
| 4 | Hero → Services lead (bento grid) → Stats bar → About split-screen → Testimonials → Contact |

Niche section notes:
- Trades → always include: phone number CTA in hero, free estimate CTA, years-in-business stat, license/BBB badge
- Law/Medical → always include: practice areas, consultation CTA, years of experience, testimonials
- Restaurant → always include: menu link or section, hours, location/map, reservations CTA
- Beauty/Wellness → always include: services/treatment menu, booking CTA, gallery, reviews
- Retail/Service → always include: service area, hours, phone, what makes them local/trusted

---

### Lock-In Comment Block

Before writing any HTML, document your choices at the top of `index.html`:

```html
<!--
DESIGN SYSTEM — [Business Name]
Niche: [NICHE CATEGORY]
Vibe: [one sentence describing the locked vibe]
Color: [roll + system name + hex values]
Nav: [roll + style name]
Hero: [roll + type name]
Motion: [roll + signature name]
Sections: [roll + sequence description]
-->
```
Die 4 Layout: [roll — personality name]
Die 5 Motion: [roll — signature name]
Die 6 Sections: [roll — sequence name]
-->
```

**Diversity rule:** Check last 3 builds. If any two share the same Nav OR Hero OR Section Sequence, re-roll those dice.

---

## 📋 COMPLETION GATE — MANDATORY BEFORE DEPLOY

**You cannot deploy until every item below is verified on disk.** This is not a suggestion. If any file is missing, CREATE IT before proceeding to Step 7 (Deploy).

### Required Files Checklist

Run this verification after building. Every box must be checked:

```
COMPLETION GATE — [Business Name]
═══════════════════════════════════

FILE CHECK (all must exist on disk):
[ ] index.html              — Homepage
[ ] about.html              — About page with team/credentials/story
[ ] contact.html            — Contact page with address + map embed
[ ] faq.html                — FAQ page with FAQPage JSON-LD schema
[ ] services/[service-1].html — Individual service page #1
[ ] services/[service-2].html — Individual service page #2
[ ] sitemap.xml             — XML sitemap listing all pages
[ ] robots.txt              — Robots file referencing sitemap

CONTENT CHECK (verify in each file):
[ ] Every page has unique <title> tag (keyword first, 50-60 chars)
[ ] Every page has unique <meta name="description"> (150-160 chars)
[ ] Every page has exactly one <h1> with target keyword
[ ] Every page has JSON-LD LocalBusiness schema
[ ] Every page has canonical tag
[ ] Every page has OG tags (og:title, og:description, og:url)
[ ] Every page has breadcrumb nav (Home > Category > Page)
[ ] Nav links work across all pages (relative paths correct)
[ ] Footer has links to all pages
[ ] Internal linking: every page links to ≥3 other pages

DESIGN CHECK:
[ ] Die 6 section sequence matches roll (not the banned default)
[ ] Dark background (not white/near-white)
[ ] No emojis anywhere
[ ] No purple anywhere
[ ] Mobile responsive at 375px
[ ] GSAP animations present and smooth

ASSET CHECK:
[ ] Hero video or hero image present in assets/
[ ] Service images generated (≥3)
[ ] All image paths resolve (no 404s)
```

### Verification Script

Run this bash check before deploying:

```bash
#!/bin/bash
BUILD_DIR="/tmp/rebuild/[business-name]"
PASS=true

echo "=== COMPLETION GATE ==="

# Check required files
for f in index.html about.html contact.html faq.html sitemap.xml robots.txt; do
  if [ ! -f "$BUILD_DIR/$f" ]; then
    echo "FAIL: Missing $f"
    PASS=false
  else
    echo "OK: $f exists"
  fi
done

# Check at least 2 service pages exist
SERVICE_COUNT=$(find "$BUILD_DIR" -name "*.html" -path "*/services/*" 2>/dev/null | wc -l)
if [ "$SERVICE_COUNT" -lt 2 ]; then
  echo "FAIL: Only $SERVICE_COUNT service pages (need ≥2)"
  PASS=false
else
  echo "OK: $SERVICE_COUNT service pages found"
fi

# Check every HTML file has a <title> tag
for f in $(find "$BUILD_DIR" -name "*.html"); do
  if ! grep -q "<title>" "$f"; then
    echo "FAIL: $f missing <title> tag"
    PASS=false
  fi
done

# Check no white backgrounds
for f in $(find "$BUILD_DIR" -name "*.html" -o -name "*.css"); do
  if grep -qE 'background(-color)?:\s*#(FFFFFF|ffffff|FFF|fff|F5F5F5|FAFAFA)' "$f"; then
    echo "FAIL: $f has white/near-white background"
    PASS=false
  fi
done

if [ "$PASS" = true ]; then
  echo "=== GATE PASSED — CLEAR TO DEPLOY ==="
else
  echo "=== GATE FAILED — FIX ISSUES BEFORE DEPLOYING ==="
  exit 1
fi
```

**If the gate fails, go back to Step 5 and build the missing pages. Do NOT skip to deploy.**

---

## Building the Remake — Multi-Page Architecture

### Required Page Structure

Every rebuild produces this file tree. No exceptions:

```
[business-name]/
├── index.html                 ← Homepage (from Stitch, expanded by Claude Code)
├── about.html                 ← About + team + credentials (E-E-A-T)
├── contact.html               ← Contact + address + map embed
├── faq.html                   ← FAQ with FAQPage JSON-LD
├── services/
│   ├── [service-1].html       ← Individual service page
│   ├── [service-2].html       ← Individual service page
│   └── [service-3].html       ← Individual service page (if applicable)
├── assets/
│   ├── stitch-preview.jpg     ← Stitch screenshot (used in forgeaiseo.com showcase)
│   ├── hero-main.jpg          ← Nano Banana hero image
│   ├── service-1.jpg          ← Service image
│   ├── service-2.jpg          ← Service image
│   └── service-3.jpg          ← Service image
├── css/
│   └── styles.css             ← Shared stylesheet (mobile-first, extracted from Stitch output)
├── js/
│   └── main.js                ← Shared GSAP + interactions
├── sitemap.xml                ← XML sitemap with all pages
└── robots.txt                 ← Points to sitemap
```

### Shared Components Across Pages

Every page shares these elements (put in a consistent structure):

**Nav:** Same nav on every page. Use the Die 1 roll style. Links: Home, Services, About, Contact, FAQ. CTA button in nav.

**Footer:** Same footer on every page. Business name, address, phone, email. Links to all pages. Hours of operation. Copyright.

**CSS:** One shared `styles.css` loaded by all pages. Mobile-first breakpoints at bottom.

**JS:** One shared `main.js` for GSAP ScrollTrigger, nav interactions, animations.

### Page-by-Page Build Instructions

**index.html — Homepage**
- Follow your Die 6 section sequence EXACTLY
- Include the Die 3 hero treatment
- Apply Die 5 motion signature throughout
- Link to all service pages, about, contact, FAQ
- JSON-LD: LocalBusiness schema

**services/[service].html — Individual Service Pages**
- One page per major service the business offers (minimum 2, ideally 3-5)
- Each page: unique H1 with "[Service] in [City]", 300+ words of content, relevant image, CTA to contact, breadcrumb nav
- JSON-LD: Service schema
- Internal links to related services + homepage

**about.html — About Page**
- Business story, founding date, team (if available)
- Credentials, certifications, awards
- Statistics: years in business, clients served, reviews count
- Photo (real from site, or AI-generated professional portrait)
- JSON-LD: Organization schema

**contact.html — Contact Page**
- Business name, full address, phone, email
- Google Maps embed (use embed URL from Google Maps)
- Contact form (name, email, phone, message)
- Hours of operation
- JSON-LD: LocalBusiness with geo coordinates

**faq.html — FAQ Page**
- Minimum 10 questions relevant to the niche
- Direct-answer format (answer in first sentence, then expand)
- JSON-LD: FAQPage schema (this is a rich result opportunity)
- Internal links to relevant service pages within answers

### Build Process

Build ALL pages before moving to the Completion Gate. Suggested order:

1. Create `css/styles.css` with full design system (colors, typography, spacing, mobile breakpoints)
2. Create `js/main.js` with GSAP setup, ScrollTrigger, nav interactions
3. Build `index.html` with Die 6 section sequence
4. Build `about.html`
5. Build `contact.html`
6. Build each `services/[service].html`
7. Build `faq.html`
8. Generate `sitemap.xml` listing all pages
9. Create `robots.txt` pointing to sitemap
10. Run Completion Gate

---

## Business Model & Pricing

### Why This Works

- **Market**: 60%+ of small businesses have outdated websites
- **Value**: A $10K rebuild adds 30-50% to annual revenue within 6 months
- **Urgency**: They lose 2-3 leads/day to better-designed competitors
- **Margin**: 85-90% profit (low marginal cost, high perceived value)
- **Speed**: Full multi-page rebuild in 1-2 days with this pipeline

### Pricing Tiers

| Tier | Price | Includes |
|------|-------|----------|
| **Basic** | $2,500 | Clean multi-page design, mobile responsive, basic animations, Netlify deploy |
| **Pro** | $5,000 | + GSAP scroll animations, video hero, testimonial carousel, Core Web Vitals optimized |
| **Premium** | $10,000 | + AI video scroll sequences, advanced micro-interactions, full SEO + GEO, ongoing support |

### Revenue Projection

- Month 1: 200 emails → 6 demos → 3 deals × $7,500 = $22,500
- Month 2-3: Refined → 4.2 deals/month × $7,500 = $31,500/month
- Year 1: Ramp to 20 emails/day → $180K-250K annual at 85% profit

---

## Finding & Qualifying Targets

### Top Niches

1. Dentists (avg revenue $500K-2M, poor tech adoption)
2. Restaurants (urgent need, visual design crucial)
3. Law Firms (high margins, outdated sites endemic)
4. Real Estate Agents (portfolio-heavy, visual-first)
5. Medical Practices (insurance-backed, professional image critical)
6. Contractors/Plumbers (trust-based, poor websites)
7. Salons/Spas (visual-first, Instagram-ready converts)
8. Accountants/CPAs (seasonal, need rebrand before tax season)

### Search Queries

```
"[niche] near [city]"
"[niche] [city]"
"best [niche] [city]"
"[niche] [city] reviews"
```

### Qualification Rubric

Score each prospect (target: 70+ to email, 85+ priority):

| Criterion | Weight |
|-----------|--------|
| Google Reviews 4.5+, 50+ reviews | 20% |
| Website exists | 10% |
| Design looks pre-2018 | 20% |
| Mobile broken or bad | 15% |
| Zero animations | 10% |
| Contact info easily findable | 10% |
| Top niche | 15% |

---

## Site Analysis & Scraping

### NAP Lock — Before Any Code

```bash
# Extract phone numbers
curl -sL "https://[TARGET]" | grep -oE '\(?\b[0-9]{3}\)?[-.\s][0-9]{3}[-.\s][0-9]{4}\b' | sort -u

# Extract all real photos (run alongside Firecrawl)
curl -sL "$URL" | grep -oE 'src="(https://[^"]+\.(jpg|jpeg|png|webp))"' | sed 's/src="//;s/"//' | sort -u

# For WordPress sites specifically
curl -sL "$URL" | grep -oE 'https://[a-zA-Z0-9._-]+/wp-content/uploads/[A-Za-z0-9/_.-]+\.(jpg|jpeg|png|webp)' | grep -v '[0-9]x[0-9]' | sort -u
```

### Platform Detection

```bash
curl -sL "$URL" | grep -i "wp-content\|uenicdn\|squarespace\|wix\|shopify\|webflow" | head -5
```

### Firecrawl Extraction

Use Firecrawl for structured content (copy, services, testimonials). But always raw-grep for images too — Firecrawl markdown strips image URLs.

---

## Animation Stack & Premium Effects

### GSAP Patterns

**Text reveal (char-by-char stagger):**
```javascript
gsap.registerPlugin(ScrollTrigger);

// Hero headline
gsap.to('.headline-word', {
  duration: 0.8, opacity: 1, y: 0,
  stagger: 0.15, delay: 0.3, ease: "power3.out"
});
```

**Scroll-triggered cards:**
```javascript
gsap.to(".card", {
  scrollTrigger: { trigger: ".section", start: "top 80%" },
  duration: 0.8, opacity: 1, y: 0, stagger: 0.2, ease: "power3.out"
});
```

**Counter animation:**
```javascript
gsap.to(el, {
  textContent: targetValue, duration: 2,
  snap: { textContent: 1 },
  scrollTrigger: { trigger: el, start: "top 80%" },
  ease: "power3.out"
});
```

**Horizontal pinned scroll gallery:**
```javascript
gsap.to(".h-gallery", {
  scrollTrigger: {
    trigger: ".gallery-section", start: "top top",
    end: () => "+=" + (gallery.scrollWidth - gallery.clientWidth) * 1.5,
    scrub: 1, pin: true
  },
  x: () => -(gallery.scrollWidth - gallery.clientWidth), ease: "none"
});
```

**Clip-path reveal:**
```javascript
gsap.from(".img", { clipPath: "inset(0 100% 0 0)", duration: 1.2 });
```

### Easing Reference

| Easing | Use |
|--------|-----|
| `power3.out` | Default for most reveals |
| `back.out(1.7)` | Button clicks, playful |
| `elastic.out(1, 0.3)` | Icons, badges |
| `expo.out` | Major reveals |
| `sine.inOut` | Hover effects, loops |

---

## Anti-Slop Design Checklist

### NEVER (instant fail):
- Inter/Roboto/Arial as default font
- Purple gradient or purple accent of any shade
- Uniform rounded corners on everything
- Center-only layout with no personality
- ~~Hero → 3-column features → horizontal band → contact form~~ (BANNED SEQUENCE)
- Stock illustrations of diverse teams
- No animations (static 2010 design)
- No clear CTA above fold

### ALWAYS:
- Distinctive font pairing (Display: Poppins, Clash Display, Satoshi, Playfair, Monument; Body: Inter, DM Sans, Work Sans, Outfit)
- Dominant 60% + Secondary 30% + Accent 10% color distribution
- Asymmetric or grid-breaking elements
- Textured backgrounds (gradient mesh, noise overlay at 0.03 opacity, geometric patterns)
- Staggered reveal on page load
- Unexpected hover/scroll interactions

### Anti-Slop Enforcement — Active Verification

The randomizer creates variety on paper. This section makes sure it shows up on screen.

**The "Screenshot Test" — Run After Building index.html**

Before building any other page, audit `index.html` against these 7 kill signals. If ANY are true, delete and rebuild the homepage.

```
SLOP DETECTOR — run mentally after building index.html
═══════════════════════════════════════════════════════

1. GRADIENT CHECK: Open styles.css. Find "linear-gradient".
   → If gradient goes from [any color] to transparent as the MAIN
     visual over a solid dark bg → that's the #1 AI-site tell.
     Replace with texture, image, or solid color block.

2. CARD SYMMETRY CHECK: Count columns in first section after hero.
   → If it's exactly 3 equal-width cards with icons above text and
     a "Learn More" link → STOP. That's the banned sequence in
     disguise. Re-read Die 6 and rebuild.

3. FONT MONOTONY CHECK: How many font-family declarations in styles.css?
   → If 1 → add a display font for headings.
   → If body font is Inter, Roboto, or Arial → swap it.
   → If both fonts are sans-serif → add serif display font
     (Playfair Display, DM Serif, Fraunces, Lora).

4. SPACING UNIFORMITY CHECK: Are all sections the same height/padding?
   → Agency sites have RHYTHM. Vary section heights — tall hero,
     tight stats bar, generous testimonials, dense service grid.
     Not everything is padding: 80px 0.

5. ELEMENT OVERLAP CHECK: Does anything break the grid or overlap?
   → If everything sits neatly inside containers with equal margins
     → you have a template, not a design. Add at least ONE:
     - Image that bleeds past its column
     - Heading so large it wraps unexpectedly
     - Decorative element crossing section boundaries
     - Asymmetric layout where left ≠ right

6. INTERACTION CHECK: Hover every card, button, link mentally.
   → If answer is "color changes" for all → add richer interactions:
     - Cards: translateY(-4px) + shadow + slight scale
     - Buttons: background slide (left-to-right fill), not color swap
     - Images: scale(1.03) with overflow:hidden on parent
     - At least ONE element with a unique hover nothing else shares

7. SCROLL LIFE CHECK: Scroll top to bottom mentally.
   → If nothing moves/appears/changes → GSAP isn't working.
   → MINIMUM: 3 scroll-triggered animations on homepage.
     One in hero (load), one in middle (scroll), one near bottom.
```

**Niche-Specific Design Overrides — Apply AFTER dice roll, BEFORE building:**

```
AUTO REPAIR / TRADES:
  → Fonts: Clash Display, Bebas Neue, or Oswald. NEVER cursive/script.
  → Photos: Hands on tools, engine bays. NOT people smiling at cameras.
  → Trust: ASE badge, years-in-business counter, "family-owned since [year]".
  → Color: If Die 2 gives Deep Ocean or Monochrome+sage → swap accent to
    red, yellow, or orange.

RESTAURANTS / FOOD:
  → Bad AI food photos kill restaurant sites. If Imagen looks synthetic,
    fall back to restaurant's own scraped photos.
  → Must include: menu link, hours in hero or immediately below,
    reservation/order CTA.
  → Fonts: Serif display works — Playfair, DM Serif, handwritten logo only.

LAW / FINANCE / MEDICAL:
  → BANNED motion regardless of dice: rolls 5 (scramble), 7 (venetian),
    8 (3D cylinder), 10 (perimeter ticker), 15 (magnetic cursor).
  → Must feature: credentials, licenses, bar numbers, certifications.
  → Photos: Real headshots > AI faces. Use actual site photos if they exist.
  → Fonts: Playfair Display, Cormorant Garamond, Source Serif Pro.

SALONS / SPAS / BEAUTY:
  → Warmer palettes: Terracotta, Slate & Copper, Night Forest all strong.
    Chalk & Iron red accent can feel too aggressive.
  → Photos: Texture shots (hair, skin, products) > people. AI beauty imagery
    is uncanny valley — dangerous.
  → Must include: booking CTA (not "contact us"), service menu w/ prices,
    gallery/portfolio section.

REAL ESTATE:
  → Hero MUST feature property imagery, not abstract graphics.
  → Include property showcase/gallery even if placeholder.
  → Map integration on contact page is critical, not optional.
  → Fonts: Outfit, Plus Jakarta Sans, Satoshi. Serif for luxury only.
```

---

## SEO Implementation

### Per-Page SEO (apply to every page)

```html
<head>
  <title>[Keyword First] | [Business Name]</title>
  <meta name="description" content="[Keyword + CTA, 150-160 chars]">
  <meta property="og:title" content="[Title]">
  <meta property="og:description" content="[Description]">
  <meta property="og:image" content="[Image URL]">
  <meta property="og:url" content="[Canonical URL]">
  <link rel="canonical" href="[URL]">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
```

### JSON-LD Schemas

**LocalBusiness** (every page):
```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "[BUSINESS]",
  "telephone": "[PHONE]",
  "address": {"@type": "PostalAddress", "streetAddress": "[STREET]", "addressLocality": "[CITY]", "addressRegion": "[STATE]"},
  "url": "[URL]"
}
```

**FAQPage** (faq.html):
```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "[Q]", "acceptedAnswer": {"@type": "Answer", "text": "[A]"}}
  ]
}
```

**Service** (service pages):
```json
{
  "@context": "https://schema.org",
  "@type": "Service",
  "name": "[SERVICE]",
  "provider": {"@type": "LocalBusiness", "name": "[BUSINESS]"},
  "areaServed": "[CITY]"
}
```

### GEO Optimization (AI Search Visibility)

- FAQ page with direct-answer format (answer in first sentence)
- Specific statistics and data points throughout
- Named entities with real credentials
- One 1500-word authoritative guide page per niche

---

## Deployment to Netlify (Production Handoff Only)

**This section is for AFTER a client pays.** Demo sites go to GitHub Pages (Step 7). Netlify is for production handoff with a custom domain.

```bash
# Create repo and deploy to Netlify (post-payment only)
cd /tmp/rebuild/[business-name]
git init
git add .
git commit -m "feat: multi-page website rebuild for [business-name]"
gh repo create [business-name]-website --public --source . --remote origin --push

# Deploy to Netlify
netlify deploy --prod --dir .
# Live URL: https://[business-name]-website.netlify.app
# Then connect client's custom domain via Netlify dashboard
```

### netlify.toml (optional)
```toml
[build]
  publish = "."

[[headers]]
  for = "/assets/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

---

## Cold Outreach Strategy

### Cold Email — Humanization Rules

The email determines whether a $7,500 deal happens. Treat it accordingly.

- **Rule 1:** NEVER send the same email twice. The [PROBLEMS] must be specific to this business — scraped from their actual site.
- **Rule 2:** Subject line names the business. Don't be clever. Be direct.
- **Rule 3:** One CTA only — click the link. Nothing else.
- **Rule 4:** Sender is always Alison from Teza. Display name: "Alison | Teza"

**ONE TEMPLATE — use this every time, fill in the brackets:**

```
Subject: [BUSINESS_NAME] — we rebuilt your entire website

Hi [FIRST_NAME or "there"],

My name is Alison, from Teza. We help small businesses rebuild
their digital footprint using AI — new websites, SEO, the works.

We rebuilt your entire website because we noticed a few problems
with your current one: [SPECIFIC_PROBLEMS — e.g. "it doesn't load
properly on mobile, your phone number isn't visible above the fold,
and you're not showing up when people search '[niche] in [city]'"].
These kinds of issues are quietly costing you customers every week.

Take a look at what we built:
[DEMO_URL]

Completely free to browse — no credit card, no catch.

If you like it, we'd love to sell it to you. We can have the whole
thing running on your own domain within 24 hours. If it's not for
you, no pressure at all — just let us know.

— Alison
Teza
```

**Finding [SPECIFIC_PROBLEMS] — pull 2-3 real issues during NAP scrape:**

**Finding [SPECIFIC OBSERVATION] — capture during NAP scrape:**
```
OBSERVATION CHECKLIST — find at least ONE:
[ ] Free subdomain (wixsite.com, wordpress.com, etc.)
[ ] No mobile responsiveness
[ ] Hours not on homepage
[ ] Phone buried (not in header/hero)
[ ] No Google Maps on contact page
[ ] >5 second load time
[ ] No HTTPS (http:// only)
[ ] Copyright year 2+ years old
[ ] Competitor in same city has visibly better site
```

**Follow-up Sequence:**

Day 3 — Short bump (under 30 words):
```
Subject: Re: [original subject]

Hi [NAME], did the new site load OK? Here's the link again: [DEMO_URL]

— Alex
```

Day 7 — Closing (under 40 words):
```
Subject: Re: [original subject]

Hi [NAME], moving on to other projects this week. If you want
the site, just reply and I'll send everything over. Otherwise
no worries at all.

— Alex
```

### AgentMail API

```bash
AGENTMAIL_API_KEY=$(cat ~/.openclaw/workspace/.secrets/agentmail-api-key.txt | tr -d '[:space:]')
curl -s -X POST "https://api.agentmail.to/v0/inboxes/forgeaiseo@agentmail.to/messages/send" \
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": ["[EMAIL]"],
    "subject": "[SUBJECT]",
    "text": "[BODY]"
  }'
```

---

## Closing & Objection Handling

### Common Objections

**"Too expensive"** → "Even 2-3 extra bookings = $5K-$10K in revenue. ROI in 1-2 months."

**"Can I see examples?"** → Show 3 similar niche rebuilds with results.

**"Happy with current site"** → "When was it built? How many mobile leads? Compare to your competitor's new site."

**"No time"** → "Total time from you: ~1 hour. I handle everything."

**"I'll lose SEO"** → "New site has faster loads, mobile optimization, proper schema. SEO improves. We do 301 redirects."

### Sales Call Structure (15 min)

1. Build rapport (2 min) — background, similar niche results
2. Show the demo (3 min) — walk through hero, scroll effects, mobile, speed
3. Acknowledge their situation (2 min) — honest assessment of current site
4. Explain value (3 min) — mobile leads, speed, bookings increase
5. Price (3 min) — Pro $5K or Premium $10K
6. Close (2 min) — 50% deposit, 1-2 week timeline

---

## Nick Saraev Flow — AI Video Scroll Sequences

### The 3-Step Method

**Step 1:** Use Leon's Taste Skill (embedded below) with Claude Code to oneshot the site structure.

**Step 2:** Generate image with Nano Banana (Imagen 4) → animate with Veo 2/3 → extract frames with ffmpeg.

**Step 3:** Claude Code integrates video as hero background or scroll-scrubbed frame sequence.

### Leon's Taste Skill (High-Agency Frontend)

Use for all new builds. Key rules:

- **DESIGN_VARIANCE: 8** | **MOTION_INTENSITY: 6** | **VISUAL_DENSITY: 4**
- Framework: React or vanilla HTML. Styling: Tailwind CSS.
- BANNED: Inter font, purple gradients, centered hero (when variance > 4), 3-column equal card grids, h-screen (use min-h-[100dvh])
- Typography: text-4xl md:text-6xl tracking-tighter. Use Geist, Outfit, Cabinet Grotesk, Satoshi.
- Motion: Spring physics on all interactive elements. Staggered orchestration on mount. Animate only transform + opacity.
- Liquid Glass: backdrop-blur + 1px inner border + inner shadow.

### Leon's Soft Skill (Luxury/Agency — $150k look)

Use when client wants premium agency feel:

- Vibe options: Ethereal Glass (OLED black, mesh gradients), Editorial Luxury (warm creams, serif), Soft Structuralism (silver-grey, bold Grotesk)
- Layout options: Asymmetrical Bento (masonry grid), Z-Axis Cascade (stacked cards), Editorial Split
- Double-Bezel card pattern: outer shell (bg-black/5, ring-1, p-1.5) + inner core (inset shadow)
- Button-in-Button: rounded-full with nested arrow icon circle
- All transitions: custom cubic-bezier — NEVER linear or ease-in-out

### Cost Per Site

| Item | Cost |
|------|------|
| Claude Code tokens | ~$1 |
| Veo video generation | ~$1-2 |
| Imagen 4 images | ~$0.10 |
| Netlify hosting | Free |
| **Total** | **~$3-5** |

---

## Interactive Features — High-Value Upsells

### Order/Appointment Tracker (Pizza Hut Pattern)

For businesses that take orders or appointments. Replace generic contact forms:

**State 1: Wizard** — Product/service selector → Customize → Date/Details → Review & Confirm
**State 2: Confirmation** — Animated checkmark, order number, ETA
**State 3: Tracker** — `[●]———[○]———[○]———[○]` progress bar with pulsing active step
**State 4: History** — localStorage order list with status badges

Uses GSAP state transitions: `gsap.to(current, {opacity:0, x:-50})` then `gsap.from(next, {opacity:0, x:50})`

---

## Autonomous Cron Setup

### Cron Configuration

```json
{
  "name": "website-remake-daily",
  "schedule": {
    "kind": "cron",
    "expr": "0 9 * * 1-5",
    "tz": "America/Chicago"
  },
  "payload": {
    "kind": "agentTurn",
    "model": "haiku",
    "message": "Read the website-remake skill at ~/.openclaw/workspace/skills/website-remake/SKILL.md. Execute the PIPELINE EXECUTION CHECKLIST top to bottom for niche=dentist, city=chicago, limit=1. Find one target, scrape NAP, generate hero video + images, build ALL pages (index + services + about + contact + faq), run COMPLETION GATE, deploy to Netlify, log to Notion, send cold email via AgentMail (sender: forgeaiseo@agentmail.to). Post summary to #website-rebuilder."
  },
  "sessionTarget": "isolated",
  "delivery": {
    "mode": "announce",
    "channel": "discord",
    "to": "#website-rebuilder"
  },
  "enabled": false
}
```

### Required Secrets

All must be in `~/.openclaw/workspace/.secrets/`:

| File | Used By |
|------|---------|
| `gemini-api-key.txt` | Imagen 4 + Veo video generation |
| `firecrawl-api-key.txt` | Site scraping |
| `netlify-token.txt` | Deployment |
| `agentmail-api-key.txt` | Cold email sending |
| `notion.env` | Pipeline logging |

---

## API Keys & Setup Reference

### Firecrawl
- URL: https://firecrawl.dev/
- Free tier: 10K credits/month

### Netlify
- Token: https://netlify.com/account/tokens

### Gemini (Imagen 4 + Veo)
- URL: https://ai.google.dev
- Models: `imagen-4.0-generate-001` (images), `veo-2.0-generate-001` (video)

### AgentMail
- URL: https://agentmail.to
- Inbox: `forgeaiseo@agentmail.to`
- Endpoint: `POST /v0/inboxes/{inbox}/messages/send`

---

## Mobile-First CSS Template

Every build must include these breakpoints at the bottom of `styles.css`:

```css
/* Base styles are mobile (375px+) */

@media (min-width: 768px) {
  /* Tablet: multi-column grids, larger padding, side-by-side layouts */
}

@media (min-width: 1024px) {
  /* Desktop: full grid, larger typography, hover effects */
}

@media (max-width: 480px) {
  /* Extra small: font floors, minimal padding, stacked everything */
}
```

**Mandatory rules:**
- No fixed pixel widths on containers
- Touch targets ≥ 44px
- `font-size: clamp(1.8rem, 6vw, 4rem)` for headlines
- Body text minimum 1rem (16px)
- Section padding: 80px desktop → 48px mobile
- All grids → single column at 768px
- Hamburger nav for 3+ links
- `max-width: 100%` on all images

---

## REFERENCE BUILD — What Success Looks Like

**Takase Auto Repair — Chicago, IL | March 19, 2026**
Live demo: https://takase-auto-rebuild.netlify.app
Approved by Hari as the gold standard for this skill.

### Target profile
- Wix free subdomain (takaseauto.wixsite.com) — no custom domain, zero Google presence
- 7 Facebook likes — invisible online
- Strong real-world reputation (ASE certified, good Yelp reviews)
- Phone, email, address all publicly available
- Niche: Auto repair, Chicago South Side

### Design roll
```
Die 1 Nav:      5 — Sticky headline bar (massive on load, shrinks on scroll)
Die 2 Colors:   7 — Monochrome +1 (black #111111, white text, marigold #F2C94C accent)
Die 3 Hero:     1 — Full-bleed Veo video, dark gradient overlay
Die 4 Layout:   6 — Classic 12-column grid, micro-details, sophisticated typography
Die 5 Motion:   3 — Horizontal marquee (infinite scroll for trust signals/stats)
Die 6 Sections: 1 — Manifesto First: brand statement → gallery → testimonial wall → services accordion → sticky CTA bar
```

### What made this a clean run
- Die 6 produced a genuinely different section sequence — NOT hero→grid→band→contact
- Manifesto First led with a bold brand POV before any services — felt like a real agency site
- Marigold accent on black = high contrast, distinctive, not AI-slop purple
- Marquee trust bar replaced the boring 3x3 stat grid
- Accordion for services instead of cards — Die 6 forced this

### Pages built (all 10 — Completion Gate passed)
```
index.html
about.html
contact.html
faq.html
services/index.html
services/brakes.html
services/oil-change.html
services/alignments.html
sitemap.xml
robots.txt
```

### Pipeline steps completed
1. Target found via Brave Search — Wix site, no custom domain, verified contact info
2. NAP scraped from search results (phone, email, address, hours, services)
3. Veo 2 hero video generated via Gemini API (veo-2.0-generate-001)
4. 2x images generated via Gemini Imagen 4 (imagen-4.0-generate-001)
5. All 10 required files built by Sonnet subagent
6. Completion Gate ran — all files verified present
7. Deployed to GitHub Pages (oh-ashen-one.github.io/takase-auto-rebuild) — free
8. Logged to Notion DB (status: Built)
9. Cold email sent via forgeaiseo@agentmail.to to takaseautorepair@gmail.com

### Time & cost
- Total wall time: ~25 minutes (Veo video gen + Sonnet subagent build + manual finish)
- Sonnet subagent: timed out at 10min with 7/9 pages done — Andre finished remaining 3 files directly
- Tokens: ~47.7k (Sonnet subagent) + orchestration overhead
- Estimated cost: ~$0.60–0.80 for this build

### Lesson: subagent timeout handling
Sonnet timed out at 10min mid-build. The fix: check `/tmp/[site]/site/` for partial work, write missing files directly, run the Completion Gate, then deploy. Don't respawn — finish it yourself. Saves time and tokens.

---

## GSAP Validation — Mandatory Before Completion Gate

GSAP is the #1 source of broken builds. Animations look coded but fail silently.

### The 6 GSAP Killers

```
KILLER 1: MISSING PLUGIN REGISTRATION
  First line of main.js (after imports) MUST be:
    gsap.registerPlugin(ScrollTrigger);
  Missing this = every ScrollTrigger animation silently fails.

KILLER 2: CDN LOAD ORDER
  Every HTML file must load scripts in this EXACT order:
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>
    <script src="js/main.js"></script>
  main.js before gsap = everything breaks.

KILLER 3: SELECTOR MISMATCH
  For every gsap.to()/gsap.from() call, verify the CSS selector
  actually exists in HTML, spelled exactly the same (case-sensitive).
  Common fail: main.js uses ".service-card", HTML uses class="serviceCard".

KILLER 4: INITIAL STATE MISSING
  If animating FROM opacity:0 and y:60, elements must START there in CSS.
  Add to styles.css: .gsap-hidden { opacity: 0; transform: translateY(60px); }
  Add class="gsap-hidden" to every animated element in HTML.

KILLER 5: SCROLLTRIGGER START VALUE
  start: "top 80%" = correct for most reveals.
  NEVER use start: "top bottom" — fires before element visible.

KILLER 6: MULTIPLE PAGES, ONE main.js
  Wrap page-specific animations in existence checks:
    const hero = document.querySelector('.hero-video');
    if (hero) { gsap.from(hero, { ... }); }
  Do this for EVERY selector that only exists on one page.
```

### Minimum Animation Inventory Per Page

```
index.html    Hero entrance (load), first section (scroll), stats/counter (scroll), 1+ more, nav transition
about.html    Stats counter, 1+ scroll reveal
contact.html  Form/content reveal on scroll
services/     Card/content stagger on scroll
ALL PAGES     scroll-behavior: smooth, hover states on all interactive elements
```

### GSAP Boilerplate — Starting Point for main.js

```javascript
// === GSAP SETUP — DO NOT MODIFY THIS BLOCK ===
gsap.registerPlugin(ScrollTrigger);

function animateIfExists(selector, animProps, triggerOpts = {}) {
  const elements = document.querySelectorAll(selector);
  if (!elements.length) return;
  elements.forEach((el, i) => {
    gsap.from(el, {
      ...animProps,
      delay: (animProps.stagger || 0) * i,
      scrollTrigger: {
        trigger: el.closest('section') || el,
        start: 'top 80%',
        once: true,
        ...triggerOpts
      }
    });
  });
}

// Fade-up reveals (add class="reveal" to any element)
animateIfExists('.reveal', {
  opacity: 0, y: 40, duration: 0.8, stagger: 0.15, ease: 'power3.out'
});

// Counter animations (add data-count="150" to any element)
document.querySelectorAll('[data-count]').forEach(el => {
  const target = parseInt(el.dataset.count);
  gsap.from(el, {
    textContent: 0, duration: 2, ease: 'power3.out',
    snap: { textContent: 1 },
    scrollTrigger: { trigger: el, start: 'top 85%' }
  });
});

// === PAGE-SPECIFIC ANIMATIONS BELOW ===
// Always wrap in: if (document.querySelector('.selector')) { ... }
```

---

## Media Generation — Fallback Chain

Media generation has a 3-tier fallback. Try each in order. NEVER halt the pipeline.

```
TIER 1: Veo 2 Video (preferred)
  → If API errors OR video file <50KB → log error, go to TIER 2

TIER 2: Imagen 4 Static Image (good)
  → If API errors OR image file <10KB → log error, go to TIER 3

TIER 3: CSS Gradient Mesh (zero-cost — still looks good)
  → Force Die 3 = 7 (Animated gradient mesh)
  → Log: "Using CSS gradient hero — no external media."
  → Note in HTML comment: "Die 3: 7 — Animated gradient mesh (FALLBACK)"
```

**Imagen 4 prompt formula that works:**
`[Photography style] [shot type] of [SPECIFIC subject], [lighting], [camera/lens], [publication-quality reference]`

Good: `"Editorial photograph of a modern auto repair shop interior, warm tungsten lighting, shallow depth of field, Canon EOS R5, 35mm lens, professional photography"`

Bad: `"A beautiful website hero image for a dentist"` ← AI doesn't understand "hero image" visually

**Veo 2 prompt formula that works:**
`[Camera movement] [through/over/across] [specific scene], [lighting], [cinematic quality descriptor]`

Good: `"Slow cinematic dolly forward through auto repair shop, warm tungsten light, shallow depth of field, 24fps film grain"`

**Image validation after generation:**
```bash
for img in /tmp/rebuild/[business-name]/assets/*.{jpg,png,webp,mp4}; do
  [ -f "$img" ] || continue
  SIZE=$(stat -f%z "$img" 2>/dev/null || stat --format=%s "$img")
  [ "$SIZE" -lt 10000 ] && echo "WARNING: $img is ${SIZE}B — corrupt, regenerate or use fallback" || echo "OK: $img"
done
```

---

## Design Quality Gate v2

Score each item 0/1. Must score **10/12 minimum** to deploy. Below 10 = rebuild.

```
FIRST IMPRESSION (1440px):
[ ] 1. Within 3 seconds: clear what business does + why they're good?
[ ] 2. Clear CTA visible (button, not text link)?
[ ] 3. Hero feels different from a generic template (matches Die 3 + Die 6)?

SCROLL EXPERIENCE:
[ ] 4. At least 3 things animate/appear/move on scroll?
[ ] 5. Sections have varied heights and densities?
[ ] 6. At least ONE element breaks the grid (overlap, bleed, asymmetry)?

TYPOGRAPHY & COLOR:
[ ] 7. Headings and body text visually distinct (2:1 size ratio minimum)?
[ ] 8. Accent color used sparingly (10% rule — not everywhere)?
[ ] 9. Color palette matches business mood (see niche overrides)?

MOBILE (375px):
[ ] 10. Nav collapses to hamburger?
[ ] 11. All text readable, no horizontal scroll?
[ ] 12. Primary CTA tappable with thumb (≥44px)?

SCORE: ___/12
```

**Automated quality checks — add to Completion Gate bash script:**
```bash
# GSAP on every page
for f in $(find "$BUILD_DIR" -name "*.html"); do
  grep -q "gsap.min.js" "$f" || { echo "FAIL: $f missing GSAP"; PASS=false; }
  grep -q "ScrollTrigger.min.js" "$f" || { echo "FAIL: $f missing ScrollTrigger"; PASS=false; }
done
# registerPlugin in main.js
[ -f "$BUILD_DIR/js/main.js" ] && ! grep -q "registerPlugin" "$BUILD_DIR/js/main.js" && { echo "FAIL: missing registerPlugin"; PASS=false; }
# Die 6 comment in index.html
grep -q "Die 6" "$BUILD_DIR/index.html" || { echo "FAIL: missing design roll comment"; PASS=false; }
# At least 3 ScrollTrigger usages
SCROLL_COUNT=$(grep -c "scrollTrigger\|ScrollTrigger" "$BUILD_DIR/js/main.js" 2>/dev/null || echo 0)
[ "$SCROLL_COUNT" -lt 3 ] && echo "WARN: Only $SCROLL_COUNT scroll triggers (want ≥3)"
# nav + footer on every page
for f in $(find "$BUILD_DIR" -name "*.html"); do
  grep -q "<nav" "$f" || { echo "FAIL: $f missing <nav>"; PASS=false; }
  grep -q "<footer" "$f" || { echo "FAIL: $f missing <footer>"; PASS=false; }
done
```

---

## Design Memory — Mandatory Diversity Tracking

After every successful deploy, append to the log:
```bash
echo "[$(date +%Y-%m-%d)] [BUSINESS_NAME] | Nav:$DIE1 Colors:$DIE2 Hero:$DIE3 Layout:$DIE4 Motion:$DIE5 Sections:$DIE6" \
  >> /Users/andreofastora/.openclaw/workspace/design-memory.log
```

Before rolling dice on a new build, read last 3 entries:
```bash
tail -3 /Users/andreofastora/.openclaw/workspace/design-memory.log
```

**Re-roll rules (enforced):**
- Same Nav as last build → re-roll Die 1
- Same Hero as last build → re-roll Die 3
- Same Section Sequence as last build → re-roll Die 6
- Same Color System as last 2 builds → re-roll Die 2
- Same Motion Signature as last 2 builds → re-roll Die 5

---

## Subagent Timeout Recovery Protocol

Sonnet subagents WILL timeout on large builds. This is expected. Plan for it.

**Immediately after subagent returns, run:**
```bash
echo "=== TIMEOUT RECOVERY CHECK ==="
BUILT=$(find /tmp/rebuild/[business-name] -name "*.html" | wc -l)
EXPECTED=7
echo "Built: $BUILT / $EXPECTED HTML files"
[ "$BUILT" -lt "$EXPECTED" ] && echo "PARTIAL BUILD — entering recovery mode"
for f in index.html about.html contact.html faq.html; do
  [ ! -f "/tmp/rebuild/[business-name]/$f" ] && echo "MISSING: $f"
done
```

**Recovery rules:**
1. **DO NOT respawn.** Finish missing pages yourself (orchestrating agent). Faster and cheaper.
2. Read existing `styles.css` and `main.js`. Match design system exactly — same CSS vars, class names, animation patterns.
3. Copy nav and footer from `index.html` into every missing page verbatim.
4. Run Completion Gate. Only deploy after gate passes.

**Token budget planning:**
- Comfortable in 10min: 4-5 pages + shared CSS/JS (~40K tokens)
- Risky at 10min: 7+ pages with complex animations (~60K+ tokens)
- Split strategy: 2 subagents — one for core pages (index, about, contact, faq, CSS, JS), one for service pages only.
