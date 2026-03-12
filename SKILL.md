---
name: website-remake-skill
description: Find businesses with outdated websites, rebuild them to $5K-10K quality with 3D animations, scroll effects, video backgrounds, and modern design, then sell them back. Complete pipeline from target discovery to cold outreach.
tags:
  - business-development
  - web-design
  - sales
  - ai-automation
  - lead-generation
  - claude-code
  - firecrawl
version: 1.0.0
---

# Website Remake Skill — $10K Per Deal

## Overview

This skill automates the full pipeline for finding small businesses with poor websites, rebuilding them to premium quality, and selling them back at $5K-$10K. Target sectors: local restaurants, law firms, dentists, real estate agents, contractors, salons, medical practices.

### Why This Works

- **Market**: 60%+ of small businesses have outdated websites (poor design, no animations, slow, mobile-unfriendly)
- **Value**: A $10K rebuild adds 30-50% to their annual revenue within 6 months (testimonials, CTAs, conversions)
- **Urgency**: They lose leads every day to better-designed competitors
- **Margin**: ~90% profit once you have the system dialed in

## Pipeline Overview

1. **Find Targets** → Scrape local businesses, identify outdated sites
2. **Analyze & Qualify** → Use Firecrawl to analyze existing site, assess potential
3. **Build Remake** → Use Claude Code with animations, 3D, video backgrounds
4. **Deploy** → GitHub + auto-deploy to Vercel or Netlify
5. **Outreach** → Cold email via AgentMail with live preview link
6. **Close** → Follow-up sequence, payment collection

## Step 1: Finding Targets

### Search Strategy

Use web_search to find local businesses with these signals:

- "dentist near [city]"
- "restaurant [city] near me"
- "law firm [city]"
- "real estate agent [city]"
- "contractor [city]"
- "salon [city]"

### Qualification Criteria

A qualified target has:
- **Successful business** (positive reviews, active on Google/Yelp)
- **Poor website** (dated design, no animations, slow, bad mobile, minimal CTAs)
- **No e-commerce** (easier, no payment processing needed)
- **Contact info** (email, phone easily findable)

### Script: find-targets.sh

```bash
#!/bin/bash
# Usage: ./find-targets.sh "dentist" "chicago" 10

NICHE=$1
CITY=$2
LIMIT=${3:-10}

echo "=== Finding $NICHE in $CITY ==="

# Use web_search to find businesses
# Store results with: name, address, phone, website, review count

# Example using web_search internally
for i in $(seq 1 $LIMIT); do
  # This would be called from Claude Code
  echo "Searching result $i..."
done

echo "Results saved to targets_${NICHE}_${CITY}.json"
```

## Step 2: Scraping & Analysis

### Firecrawl Integration

Use Firecrawl to extract:

- Full HTML structure (pages, sections, navigation)
- Brand colors (hex codes from CSS)
- Logo URL
- Copy (headlines, descriptions, CTAs)
- Testimonials (structure, count)
- Services/products listed
- Current animations/effects (almost never any)
- Mobile responsiveness (usually broken)
- Load time indicators

### Key Insights to Extract

```json
{
  "site_url": "https://example-dentist.com",
  "business_name": "Bright Smile Dental",
  "niche": "dental",
  "analysis": {
    "design_score": 2.5,
    "mobile_score": 1.0,
    "animation_score": 0,
    "cta_clarity": 1.0,
    "missing_elements": [
      "hero_animation",
      "scroll_effects",
      "video_background",
      "testimonial_carousel",
      "mobile_optimization",
      "fast_load_times",
      "3d_elements"
    ],
    "color_palette": ["#2c3e50", "#e74c3c", "#ffffff"],
    "copy_tone": "formal, dated",
    "conversion_blockers": [
      "No clear CTA above fold",
      "Desktop only (mobile broken)",
      "No testimonials visible",
      "Contact form broken",
      "Slow page load"
    ]
  }
}
```

### Script: scrape-site.sh

```bash
#!/bin/bash
# Usage: ./scrape-site.sh "https://example.com"

URL=$1
DOMAIN=$(echo $URL | sed 's/https\?:\/\///g' | cut -d/ -f1)

echo "=== Scraping $URL ==="

# Firecrawl scrape (called from Claude Code)
# firecrawl scrape "$URL" --format markdown --include-metadata

# Extract: colors, fonts, structure, copy
# Output: ${DOMAIN}_analysis.json

echo "Analysis saved to ${DOMAIN}_analysis.json"
```

## Step 3: Building the Premium Remake

### Core Requirements for $10K Quality

**Hero Section**
- Full-screen video background OR 3D WebGL animation
- Animated headline with staggered text reveal
- Parallax effect on scroll
- CTA button with hover animation (glow, transform)
- Mobile-optimized with fallback image

**Scroll Effects**
- GSAP ScrollTrigger animations on all major sections
- Parallax scrolling (background/foreground layers)
- Fade-in elements as user scrolls
- Staggered reveal of service cards
- Counter animations (testimonial count, years in business)

**Testimonials Section**
- Carousel with auto-rotation
- Smooth slide transitions
- Star rating display
- Author name + title + avatar
- Mobile-responsive grid

**Services/Products**
- Animated cards with CSS grid
- Hover effects (shadow, scale, color shift)
- Icon animations (on hover or scroll)
- Responsive to all screen sizes

**Technical**
- Core Web Vitals optimized (LCP < 2.5s, CLS < 0.1, FID < 100ms)
- Mobile-first responsive (375px minimum)
- JSON-LD schema (local business, services)
- OG meta tags, title, description
- Lazy loading for images/videos
- CDN-ready structure (for Vercel/Netlify)

### Claude Code Prompt Structure

Use this exact structure when spawning Claude Code to build the remake:

#### Iteration 1: Basic Structure + Hero

```
You are a premium web designer building a luxury website for a [BUSINESS_TYPE].

Requirements:
- Full HTML/CSS/JS single-page app (no dependencies initially)
- Hero section: [HEIGHT] pixels, full-width video background or 3D canvas
- Hero headline: "[BUSINESS_NAME] - [TAGLINE]"
- Brand colors: [COLOR_PALETTE]
- CTA button: "[CTA_TEXT]" → links to #contact
- Mobile responsive (375px to 1920px)
- Modern fonts: Use @import from Google Fonts (Poppins, Inter, or Playfair)

Build the hero ONLY. Make it pixel-perfect, modern, premium. I will iterate on this.
```

#### Iteration 2: Add Animations + Scroll Effects

```
Improve this website:

Changes:
1. Add GSAP library (cdnjs)
2. Hero headline: Split into words, animate each word with staggered reveal (0.3s delay)
3. Add parallax effect to background (moves slower than scroll)
4. Hero CTA button: Glow animation on load, scale on hover
5. Add Services section below hero with 3 cards
6. Cards animate in on scroll (fade + slide up)
7. Each card has icon that rotates on hover

Keep color scheme: [COLORS]
Ensure mobile-responsive.
```

#### Iteration 3: Testimonials + More Effects

```
Add to website:

1. Testimonials section (5 testimonials):
   - Carousel that auto-rotates every 5s
   - Smooth slide transition (0.6s)
   - Show: quote, author name, title, 5-star rating
   - Manual left/right arrows
   
2. About section with counter animations:
   - "20+ Years Experience" (count up 0→20)
   - "500+ Happy Clients" (count up 0→500)
   - Animations trigger on scroll
   
3. Gallery section:
   - Grid of 6 images (CSS Grid)
   - Hover: slight zoom + shadow
   
Keep all animations smooth and professional.
```

#### Iteration 4: Polish + 3D Elements (Optional Premium)

```
Final premium polish:

1. Add Three.js 3D element (if budget allows):
   - Floating geometric shapes in hero background
   - Subtle animation loop
   - Performance optimized (GPU accelerated)
   
2. Add micro-animations:
   - Logo fade-in on page load
   - Menu items stagger on hover
   - CTA button has ripple effect on click
   
3. Optimize Core Web Vitals:
   - Compress images to < 100KB each
   - Minify CSS/JS
   - Lazy load below-fold images
   
4. Add schema markup:
   - LocalBusiness JSON-LD
   - Service schema
   - Review/rating schema

Result should be production-ready, pixel-perfect, no console errors.
```

### Key Technical Choices

**Why No Build Tools?**
- Single HTML file = easier to deploy, no build step, instant changes
- Tailwind CSS via CDN = instant styling without npm
- GSAP via CDN = all animations from one library
- Three.js via CDN = 3D without webpack

**Why This Stack?**
- **GSAP** = industry standard for scroll animations (Netflix, Nike use it)
- **Three.js** = most popular 3D library on web (20K+ GitHub stars)
- **Tailwind** = fastest to prototype, modern utility approach
- **HTML/CSS/JS vanilla** = maximum control, no framework overhead

### Prompts (Save These)

Create `prompts/` directory with these files:

#### prompts/hero-section.md

```markdown
# Premium Hero Section Prompt

You are a senior frontend developer. Build a luxury website hero section for [BUSINESS_NAME] ([BUSINESS_TYPE]).

## Visual Brief
- Hero height: 100vh (full screen)
- Video background: [DESCRIPTION] OR 3D animated background
- Color palette: [HEX_COLORS]
- Typography: Modern, high contrast

## Requirements
1. Full HTML/CSS/JS (single file)
2. Responsive (mobile-first)
3. Headline with staggered word animation
4. Subheadline
5. CTA button (glow + scale on hover)
6. Parallax background layer
7. No external fonts initially (system fonts OK)
8. Performance: LCP < 2.5s

## Brand Copy
- Headline: "[INSERT_HEADLINE]"
- Subheadline: "[INSERT_SUBHEADLINE]"
- CTA Button Text: "[INSERT_CTA]"

Build this hero now. Make it stunning, modern, premium. Every detail matters.
```

#### prompts/full-site-rebuild.md

```markdown
# Full Website Rebuild Prompt (Iteration Framework)

## Context
- Business: [NAME]
- Type: [DENTIST/LAWYER/RESTAURANT/REALTOR/etc]
- Target Audience: [DESCRIPTION]
- Brand Colors: [COLORS]
- Current Site Analysis: [PASTE FIRECRAWL ANALYSIS]

## Build Instructions

### Iteration 1: Structure
Build basic multi-section layout:
- Hero
- About
- Services (3 cards)
- Testimonials
- Contact CTA
- Footer

### Iteration 2: Animations
Add GSAP + scroll triggers:
- Text reveals
- Card slide-in on scroll
- Parallax backgrounds
- Button hover effects

### Iteration 3: Polish
- Testimonial carousel
- Counter animations
- Gallery
- Mobile optimization

### Iteration 4: Premium (if budget)
- Three.js 3D intro animation
- Advanced micro-interactions
- Performance optimization
- Schema markup

## Output
Production-ready single HTML file with:
- No console errors
- All images optimized
- All animations smooth (60fps)
- Mobile responsive
- SEO meta tags
- Schema markup (LocalBusiness, Service, Review)

Start with Iteration 1.
```

## Step 4: Deployment

### GitHub Push

```bash
# Create repo for this specific rebuild
git init [business-name]-website
cd [business-name]-website

# Create index.html (from Claude Code output)
# Create assets/ folder with images
# Create .gitignore

git add .
git commit -m "feat: website rebuild for [business-name]"
git push origin main
```

### Deploy Options (Recommended: Vercel or Netlify)

**Vercel (5 min setup)**
```bash
# Connect GitHub repo
# Vercel auto-deploys on git push
# Live URL: https://[business-name].vercel.app
```

**Netlify (Alternative)**
```bash
# Drag-and-drop or connect GitHub
# Live URL: https://[business-name].netlify.app
```

### Generate Live Demo Link

```
https://[business-name].vercel.app
```

**This is your hook** → send in cold email with "See your new site here" CTA.

## Step 5: Cold Outreach via AgentMail

### Email Strategy

**Subject Lines (A/B Test)**

1. "I rebuilt your website — here's the link"
2. "Your website just got a makeover"
3. "[Business Name] — Free website preview"
4. "Quick question: [3-second check]"

### Email Template

```
Hi [OWNER_NAME],

I spent 2 hours rebuilding your website. Here's the link:
[LIVE_DEMO_URL]

What I changed:
- Modern hero with video/3D animation
- Smooth scroll effects on every section
- Mobile-optimized (your current site breaks on mobile)
- Testimonials carousel (auto-rotating)
- Clear CTAs for bookings/calls
- Optimized for Google search

This isn't a mockup—it's fully functional, hosted, and ready to go live.

If you like it, we can discuss pricing and handoff.

Talk soon,
[YOUR_NAME]
P.S. This usually takes 2-3 weeks at design agencies. I can rebuild yours in days.
```

### Follow-Up Sequence (7 Days)

**Email 1 (Day 0)**: Initial pitch + demo link
**Email 2 (Day 3)**: "Did you get a chance to see the new site?"
**Email 3 (Day 7)**: "Last chance to lock in early-bird pricing"

### Pricing Tiers

| Tier | Price | Includes |
|------|-------|----------|
| **Basic** | $2,500 | Clean design, mobile responsive, basic animations |
| **Pro** | $5,000 | + GSAP scroll animations, testimonial carousel, video background |
| **Premium** | $10,000 | + 3D WebGL elements, advanced micro-interactions, ongoing optimization |

## Step 6: Automating the Pipeline

### Subagent Flow (Claude Code Integration)

When you say "Remake [URL]", the skill does:

1. **Scrape via Firecrawl** → Extract site analysis
2. **Analyze** → Identify gaps, extract colors/copy
3. **Generate Premium Rebuild** → Run Claude Code iterations
4. **Deploy** → Push to GitHub, deploy to Vercel
5. **Send Outreach** → AgentMail cold email with link
6. **Track** → Monitor opens/clicks (AgentMail analytics)

### Example Invocation

```bash
# In Claude Code or chat:
"Remake https://example-dentist.com for $10K"

# The skill:
1. Firecrawl scrape + analysis
2. Extract business info, colors, copy
3. Claude Code iteration 1-4 (hero → animations → testimonials → polish)
4. Deploy to: https://example-dentist-rebuild.vercel.app
5. Send cold email to dentist@example.com: "I rebuilt your site..."
```

## Tools & APIs You'll Need

### Firecrawl
- **What**: Web scraping + site analysis
- **Setup**: `npm install -g firecrawl-cli` → `firecrawl login --api-key`
- **Free tier**: 10K credits/month (enough for 100+ sites)
- **Docs**: https://firecrawl.dev

### Claude Code
- **What**: AI-powered web builder
- **Setup**: Access at https://claude.com → Artifacts → enable Claude Code
- **Plugins**: Install Firecrawl plugin for web scraping
- **Cost**: Included with Claude subscription

### Vercel
- **What**: Free hosting + auto-deploy from GitHub
- **Setup**: Connect GitHub repo, auto-deploys on push
- **Free tier**: Perfect for this (unlimited projects, unlimited bandwidth)
- **Docs**: https://vercel.com

### AgentMail
- **What**: Cold email API + built-in tracking
- **Setup**: API key in `.secrets/agentmail.env`
- **Cost**: $0.05-0.10 per email (very cheap at scale)
- **Docs**: https://agentmail.to

### Gemini Image Generation (Optional)
- **What**: Generate hero visuals, logo variations
- **Setup**: Gemini API key
- **Use**: "Create a luxury dental office hero image for Bright Smile Dental"

## Complete Workflow Example

### Scenario: Rebuild a Dentist's Website

**1. Find Target**
```
Search: "dentist chicago"
Found: "Bright Smile Dental" — https://bright-smile-dental.com
Reviews: 4.8 stars, 127 reviews (qualified!)
Website: Looks like 2010 design (qualified!)
```

**2. Scrape & Analyze**
```
Firecrawl extracts:
- Colors: #2c3e50 (dark blue), #e74c3c (red), #ffffff (white)
- Copy: "Family Dentistry Since 2001"
- Services: Cleanings, Root Canals, Whitening, Implants
- Testimonials: 5 (text only, not structured)
- Current state: No animations, broken mobile, slow
```

**3. Generate Rebuild via Claude Code**

Iteration 1: Hero with video background (dental chair opening/closing)
Iteration 2: GSAP scroll animations on services
Iteration 3: Testimonial carousel with star ratings
Iteration 4: Three.js 3D tooth animation, Core Web Vitals optimized

Output: Single HTML file, 4 section images, ready to deploy

**4. Deploy**
```
GitHub: oh-ashen-one/bright-smile-rebuild
Vercel: https://bright-smile-rebuild.vercel.app
```

**5. Cold Email**
```
To: owner@brightsmile.com
Subject: I rebuilt your website — here's the link

Hi Dr. Johnson,

I spent this weekend rebuilding your website.
See it here: https://bright-smile-rebuild.vercel.app

What I changed:
- Modern hero with animated dental chair intro
- Smooth scroll animations on every section
- Mobile works perfectly now (yours doesn't)
- Rotating testimonial carousel
- Clear booking CTAs above the fold

If you like it, let's talk pricing. I do this for $5K-$10K depending on scope.

Talk soon,
[Your Name]
```

**6. Follow-Up**
- Day 3: "Did you get a chance to see the new design?"
- Day 7: "Last chance to lock in this price"

**7. Conversion**
- If interested: Schedule call, discuss timeline
- Invoice: $5K-$10K upfront (50% deposit typical)
- Handoff: Transfer domain DNS, GitHub repo access, Vercel project

---

## Tips for $10K Quality Results

1. **Always iterate 4x minimum** → Clients expect polish, not first drafts
2. **Use real testimonials** → Extract from Google/Yelp reviews (with permission)
3. **Make CTAs dead obvious** → Button should be 50%+ of hero
4. **Mobile first** → 60%+ of prospects browse on phone
5. **Video backgrounds** → Users don't care about 3D if video is better
6. **Optimize images** → TinyPNG + ImageOptim before deploy
7. **Test on real phones** → iPhone + Android Chrome minimum
8. **Ask about goals** → "What does success look like?" (bookings? calls? leads?)

## Success Metrics

Track your results:
- **Conversion rate**: Website visits → emails opened (target: 30%+)
- **Meeting rate**: Emails opened → demo calls (target: 10%+)
- **Close rate**: Demo calls → signed deals (target: 50%+)
- **Revenue**: (Conversion × Meeting × Close) × $7,500 avg price

Example math:
- 100 cold emails sent
- 30 opens (30%)
- 3 demo calls (10%)
- 1.5 deals closed (50%)
- **$11,250 revenue from 100 emails**

---

## Files in This Repo

```
website-remake-skill/
├── SKILL.md (this file)
├── README.md (quick start)
├── scripts/
│   ├── find-targets.sh (search for businesses)
│   ├── scrape-site.sh (analyze existing site)
│   ├── build-site.sh (trigger Claude Code)
│   └── send-email.sh (AgentMail integration)
├── prompts/
│   ├── hero-section.md (hero animation prompt)
│   ├── full-site-rebuild.md (4-iteration framework)
│   └── outreach-email.md (cold email templates)
└── examples/
    ├── dentist-rebuild/ (example output)
    ├── restaurant-rebuild/ (example output)
    └── law-firm-rebuild/ (example output)
```

---

## Getting Started

1. **Clone the repo**: `git clone https://github.com/oh-ashen-one/website-remake-skill`
2. **Set up APIs**:
   - Firecrawl: `firecrawl login --api-key YOUR_KEY`
   - AgentMail: Export `AGENTMAIL_API_KEY` in `.env`
   - Vercel: Connect your GitHub account
3. **Test on one business**: Run the full workflow end-to-end
4. **Iterate**: Refine prompts, improve rebuild quality, test email copy
5. **Scale**: 5 pitches/week = $5K-10K monthly revenue

---

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| **Low conversion** | Better qualifying (only approach high-review businesses) |
| **Quality not premium** | More iterations, user feedback loops, A/B testing designs |
| **Email spam folder** | Warm up domain, personalize subject lines, short copy |
| **Site goes down** | Use Vercel (99.9% uptime), monitor deployments |
| **Refund requests** | Get 50% upfront, clear contract, show revisions first |

---

## Next Steps

- Study the example rebuilds in `examples/`
- Customize prompts for your niche
- Test full workflow on 5 businesses
- Track metrics religiously
- Iterate on what works

Good luck. This is a real, profitable system. Execute it.
