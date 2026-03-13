---
name: website-remake
description: Find businesses with outdated websites, scrape their existing site, rebuild it to $10K quality with 3D animations/GSAP/scroll effects, auto-deploy to Netlify, and sell it back via cold email. Full pipeline from target finding to payment.
tags:
  - business-development
  - web-design
  - sales
  - ai-automation
  - lead-generation
  - claude-code
  - firecrawl
version: 2.0.0
metadata:
  openclaw:
    requires:
      env:
        - FIRECRAWL_API_KEY
        - NETLIFY_TOKEN
        - GEMINI_API_KEY
        - AGENTMAIL_API_KEY
---

# Website Remake — Master Skill

**The definitive $10K website rebuilding pipeline.** Find outdated business websites, analyze them, rebuild to premium quality with animations/3D effects, deploy instantly, and close deals via cold outreach.

---

## Table of Contents

1. [Business Model & Pricing](#business-model--pricing)
2. [Pipeline Overview](#pipeline-overview)
3. [Step 1: Finding & Qualifying Targets](#step-1-finding--qualifying-targets)
4. [Step 2: Site Analysis & Scraping](#step-2-site-analysis--scraping)
5. [Step 3: Building the Premium Remake](#step-3-building-the-premium-remake)
6. [Step 4: Animation Stack & Premium Effects](#step-4-animation-stack--premium-effects)
7. [Step 5: Anti-Slop Design Checklist](#step-5-anti-slop-design-checklist)
8. [Step 6: SEO Implementation](#step-6-seo-implementation)
9. [Step 7: Deployment to Netlify](#step-7-deployment-to-netlify)
10. [Step 8: Cold Outreach Strategy](#step-8-cold-outreach-strategy)
11. [Step 9: Closing & Objection Handling](#step-9-closing--objection-handling)
12. [Step 10: API Keys & Setup](#step-10-api-keys--setup)
13. [Step 11: Fast Build Path (AntiGravity + Stitch)](#step-11-fast-build-path-antigravity--stitch)
14. [Step 12: Autonomous Cron Setup](#step-12-autonomous-cron-setup)
15. [SEO & GEO Optimization](#seo--geo-optimization-step)
16. [Anthropic Frontend Design + Web Interface Guidelines + SEO Audit](#anthropic-frontend-design--web-interface-guidelines--seo-audit--synthesized)

---

## Business Model & Pricing

### Why This Works

- **Market**: 60%+ of small businesses have outdated websites (2010 design, no animations, broken mobile, slow)
- **Value**: A $10K rebuild adds 30-50% to their annual revenue within 6 months (better CTAs, conversions, trust)
- **Urgency**: They lose 2-3 leads/day to better-designed competitors
- **Margin**: 85-90% profit once the system is dialed in (low marginal cost, high perceived value)
- **Speed**: You can rebuild a site in 1-2 days with Claude Code + GSAP

### Pricing Tiers

| Tier | Price | Build Time | Includes |
|------|-------|-----------|----------|
| **Basic** | $2,500 | 8 hours | Clean design, mobile responsive, 2-3 basic animations, deployed to Netlify |
| **Pro** | $5,000 | 16 hours | + GSAP scroll animations, testimonial carousel, video background, parallax effects, Core Web Vitals optimized |
| **Premium** | $10,000 | 24 hours | + Three.js 3D animations, advanced micro-interactions, custom cursor effects, mesh gradients, grain overlays, full SEO optimization, ongoing support |

### Revenue Projection

```
Month 1:
- 10 cold emails/day × 20 days = 200 emails
- 30% open rate = 60 opens
- 10% meeting rate = 6 demos
- 50% close rate = 3 deals
- Average price: $7,500 → $22,500 revenue

Month 2-3 (Refined):
- Same volume, 35% open rate, 15% meeting, 60% close
- 4.2 deals/month × $7,500 = $31,500/month

Year 1 (Growth):
- Ramp up to 20 emails/day
- Improve conversions through iterations
- Estimated: $180K-250K annual revenue (at 85% profit)
```

---

## Pipeline Overview

**The 10-step process:**

1. **Find Targets** → Scrape local businesses, identify outdated sites
2. **Analyze & Qualify** → Use Firecrawl to analyze existing site, assess potential
3. **Extract Assets** → Colors, fonts, copy, testimonials, structure
4. **Build Remake (Iteration 1)** → Basic structure + hero with GSAP animations
5. **Build Remake (Iteration 2)** → Add scroll effects, service cards, parallax
6. **Build Remake (Iteration 3)** → Testimonials carousel, counter animations, gallery
7. **Build Remake (Iteration 4)** → Optional: 3D elements, micro-interactions, polish
8. **Deploy** → GitHub + auto-deploy to Netlify (live preview link)
9. **Outreach** → Cold email via AgentMail with live preview
10. **Close** → Follow-up sequence, objection handling, payment collection

---

## Step 1: Finding & Qualifying Targets

### Search Strategy

Use web_search to find local businesses. Target niches with:
- Active local presence (Google reviews, Yelp, good ratings)
- Local service focus (not national/enterprise)
- High transaction value (enough to afford a rebuild)

**Top niches (highest ROI):**
1. **Dentists** (avg revenue $500K-2M, poor tech adoption, tech-averse owners)
2. **Restaurants** (urgent need, updates drive foot traffic, owners value design)
3. **Law Firms** (high margins, outdated sites endemic, serious buyers)
4. **Real Estate Agents** (portfolio-heavy, visual design crucial, easy wins)
5. **Medical Practices** (insurance-backed revenue, professional image critical)
6. **Contractors/Plumbers** (high service area, trust-based selling, poor websites)
7. **Salons/Spas** (visual-first businesses, Instagram-ready sites convert well)
8. **Accountants/CPAs** (seasonal revenue, need rebrand before tax season)

### Search Queries

```
# Dentists
"dentist near [CITY]"
"family dental [CITY]"
"emergency dental [CITY]"

# Restaurants
"restaurant [CITY]"
"best [CUISINE] [CITY]"
"[CUISINE] restaurant [CITY]"

# Law Firms
"attorney [CITY]"
"law firm [CITY]"
"personal injury lawyer [CITY]"

# Real Estate
"real estate agent [CITY]"
"realtors near [CITY]"

# Medical
"doctor near [CITY]"
"urgent care [CITY]"
"dentist [CITY]"

# Contractors
"plumber [CITY]"
"electrician [CITY]"
"contractor [CITY]"
```

### Qualification Rubric

Score each prospect on:

| Criterion | Weight | Yes | No | Notes |
|-----------|--------|-----|----|----|
| **Google Reviews** | 20% | 4.5+ stars, 50+ reviews | < 4 stars or < 20 reviews | High reviews = successful business |
| **Website Exists** | 10% | Has website | No website | Must exist to rebuild |
| **Design Quality** | 20% | Looks pre-2015 (dated fonts, colors, layout) | Modern (2020+) | Outdated = high ROI |
| **Mobile Responsiveness** | 15% | Broken, not mobile-friendly | Mobile-optimized | Test on phone |
| **Animations/Effects** | 10% | Zero animations, static | Already animated | Easy to pitch if none |
| **Contact Info Visible** | 10% | Email/phone easy to find | Hidden, requires form | Need easy outreach |
| **Business Type** | 15% | One of top 7 niches | Other service | Higher close rates |
| **Local Focus** | 10% | Local only (not national chain) | National brand | Can't pitch to corporate |

**Qualification threshold: 70+ points = cold email, 85+ points = priority outreach**

### Script: find-targets.sh

```bash
#!/bin/bash
# Usage: ./find-targets.sh "dentist" "chicago" 10

NICHE=$1
CITY=$2
LIMIT=${3:-10}

echo "=== Finding $NICHE targets in $CITY ==="
echo "This will:"
echo "1. Search for businesses"
echo "2. Extract contact info"
echo "3. Analyze website quality"
echo "4. Score qualification"
echo ""

# Create results file
OUTPUT_FILE="targets_${NICHE}_${CITY}_$(date +%Y%m%d).json"
> "$OUTPUT_FILE"

echo "[]" > "$OUTPUT_FILE"

echo "Starting search..."
# This is called from Claude Code / web_search
# For each result:
#   - Extract: business name, address, phone, website
#   - Run Firecrawl analysis on website
#   - Score qualification (see rubric above)
#   - Save to JSON

echo "Complete. Results saved to: $OUTPUT_FILE"
```

---

## Step 2: Site Analysis & Scraping

### Firecrawl Integration

Use Firecrawl to extract the existing site's structure, design, and copy. This becomes the blueprint for what to rebuild.

**Extract these fields:**

```json
{
  "site_url": "https://example-dentist.com",
  "business_name": "Bright Smile Dental",
  "niche": "dental",
  "contact": {
    "phone": "(312) 555-0123",
    "email": "contact@brightsmile.com",
    "address": "123 Main St, Chicago, IL 60601"
  },
  "site_analysis": {
    "design_score": 2.5,
    "mobile_score": 1.0,
    "animation_score": 0,
    "load_time_seconds": 4.2,
    "cta_clarity": 1.0,
    "pages_identified": [
      "home",
      "services",
      "about",
      "testimonials",
      "contact"
    ],
    "missing_elements": [
      "hero_animation",
      "scroll_effects",
      "video_background",
      "testimonial_carousel",
      "mobile_optimization",
      "fast_load_times",
      "3d_elements",
      "clear_above_fold_cta"
    ],
    "conversion_blockers": [
      "No clear CTA above fold",
      "Desktop only (mobile broken)",
      "No testimonials visible",
      "Contact form broken/slow",
      "Loads in 4+ seconds (poor UX)"
    ]
  },
  "brand_assets": {
    "color_palette": [
      "#2c3e50",
      "#e74c3c",
      "#ffffff"
    ],
    "primary_font": "Arial (generic)",
    "secondary_font": "Times New Roman",
    "logo_url": "https://...",
    "logo_extracted": true
  },
  "copy": {
    "headline": "Welcome to Bright Smile Dental",
    "subheadline": "Your trusted dental practice since 2005",
    "services": [
      "Cleanings",
      "Root Canals",
      "Teeth Whitening",
      "Implants"
    ],
    "testimonial_count": 3,
    "about_text_length": 247
  },
  "recommendations": [
    "Replace Arial with Poppins/Inter for modern feel",
    "Add full-screen hero with video background",
    "Animate services cards on scroll",
    "Create testimonial carousel (currently static)",
    "Mobile optimization is critical (currently broken)",
    "Add counter animations (years in business, patients served)",
    "Replace generic CTA with action-oriented button",
    "Add loading optimization (currently 4.2s LCP)"
  ]
}
```

### Script: scrape-site.sh

```bash
#!/bin/bash
# Usage: ./scrape-site.sh "https://example-dentist.com"

URL=$1
DOMAIN=$(echo $URL | sed 's/https\?:\/\///g' | cut -d/ -f1)

echo "=== Scraping $URL ==="

# Call Firecrawl API to extract site data
# Output: full HTML, markdown, JSON metadata

# Extract:
# - Colors from CSS
# - Fonts from @import statements
# - Logo URL
# - All copy/headlines
# - Image URLs
# - Current animations (usually none)
# - Mobile responsiveness status

# Save analysis to JSON file
OUTPUT_FILE="${DOMAIN}_analysis.json"

# This is called from Claude Code
echo "Analysis saved to: $OUTPUT_FILE"
```

---

## Step 3: Building the Premium Remake

### Core Requirements for $10K Quality

Every rebuild must deliver these $10K-quality elements:

#### Hero Section (10% of sales impact)

- **Full-screen video background** OR 3D WebGL animation
  - Video: Relevant to business (e.g., dentist = dental chair, restaurant = food prep)
  - 3D: Floating geometric shapes, tooth animations, scales of justice, etc.
- **Animated headline** with staggered word reveal (0.3s per word)
- **Parallax scrolling effect** (background moves at 0.5x scroll speed)
- **CTA button** with:
  - Glow animation on page load
  - Scale + color shift on hover
  - Ripple effect on click
  - Clear action text (Book Now, Get Quote, Schedule Call)
- **Mobile-optimized** (responsive 375px to 1920px)
- **Performance:** LCP < 2.5s, no jank

#### Scroll Effects (20% of sales impact)

- **GSAP ScrollTrigger** on all major sections
- **Fade-in reveals** as user scrolls (opacity: 0 → 1)
- **Slide-up animations** on cards (y: 50px → 0)
- **Counter animations** (Years: 0 → 25, Clients: 0 → 500)
- **Staggered delays** between elements (0.1s-0.2s apart)
- **Parallax layers** (background slower than foreground)
- **No janky animations** (must maintain 60fps)

#### Testimonials Section (15% of sales impact)

- **Auto-rotating carousel** (every 5 seconds)
- **Smooth slide transitions** (0.6s duration)
- **Display:** Quote, author name, title, 5-star rating, avatar
- **Manual navigation:** Left/right arrows
- **Mobile-responsive** (single column on mobile)
- **Real testimonials** (extracted from Google/Yelp)

#### Services/Products Cards (15% of sales impact)

- **CSS Grid layout** (3 columns desktop, 1 mobile)
- **Cards with hover effects:**
  - Subtle shadow increase (0px → 10px)
  - Scale increase (1.0 → 1.02)
  - Color shift on title
- **Icons with animations** (rotate on hover)
- **Description text** (clear, benefit-focused)
- **Responsive** to all screen sizes

#### About / Counter Section (10% of sales impact)

- **Counter animations** using GSAP
  - "20+ Years Experience" (0 → 20 count)
  - "500+ Happy Clients" (0 → 500 count)
  - Triggered on scroll
- **Professional image**
- **Founder/business story** (2-3 sentences)

#### Gallery Section (5% of sales impact)

- **CSS Grid** (6 images, responsive)
- **Hover effects:**
  - Zoom (scale 1.0 → 1.05)
  - Shadow increase
  - Smooth transition (0.3s)

#### Contact/CTA Section (10% of sales impact)

- **Form** OR **direct contact** (phone, email, calendar link)
- **CTA button** (large, prominent, contrasting color)
- **Social proof** ("Join 500+ happy customers")

#### Technical Requirements (15% of sales impact)

- **Core Web Vitals optimized:**
  - LCP (Largest Contentful Paint) < 2.5s
  - FID (First Input Delay) < 100ms
  - CLS (Cumulative Layout Shift) < 0.1
- **Mobile-first responsive** (375px minimum width)
- **JSON-LD schema markup** (LocalBusiness, Service, Review)
- **OG meta tags** for social sharing
- **Lazy loading** for images below fold
- **CDN-ready structure** (for Netlify/Netlify)
- **No console errors** (tested in Chrome DevTools)
- **Works in:** Chrome, Safari, Firefox, Edge

### Claude Code Prompt Structure

Use this exact framework when spawning Claude Code for the 4-iteration rebuild process:

#### **Iteration 1: Basic Structure + Hero Section**

```
You are a premium web designer building a $10K website for a [BUSINESS_TYPE].

Project Brief:
- Business: [BUSINESS_NAME]
- Niche: [DENTIST/LAWYER/RESTAURANT/REALTOR/etc]
- Current site: [ANALYZED_URL]
- Target audience: [DESCRIPTION]
- Brand colors: [HEX_COLORS: e.g., #2c3e50, #e74c3c, #ffffff]
- Brand tone: [FORMAL/CASUAL/PLAYFUL/LUXURY/etc]

Build ONLY the hero section for this first iteration.

Requirements:
1. HTML/CSS/JS single file (no build tools, no npm)
2. Hero: Full screen (100vh), full-width video background OR 3D canvas
3. Video: [DESCRIPTION] (e.g., "dental chair opening/closing smoothly") OR 3D floating shapes
4. Headline: "[BUSINESS_NAME] - [TAGLINE]"
   - Must be animated (words appear one-by-one with 0.3s stagger)
   - Use GSAP library (include from cdnjs)
5. Subheadline: "[SUBHEADLINE]" (fades in after headline)
6. CTA Button:
   - Text: "[CTA_TEXT]" (e.g., "Book Now", "Get Quote", "Schedule Consultation")
   - Link: #services
   - Color: [ACCENT_COLOR]
   - Glow animation on load
   - Scale on hover
7. Responsive: 375px to 1920px
8. Typography:
   - Headline font: Poppins or Clash Display (Google Fonts)
   - Subheadline: Inter (Google Fonts)
   - Modern, premium feel
9. Performance:
   - Images optimized (< 100KB each)
   - LCP < 2.5s target
   - No console errors

This is ITERATION 1 only. Build the hero perfectly. I will iterate and add more sections.

Make every detail count. This is a $10K pitch—it needs to wow.
```

#### **Iteration 2: Add Animations + Services + Parallax**

```
Improve the website. Keep the hero, add new sections:

Changes:
1. GSAP + ScrollTrigger setup:
   - Register ScrollTrigger plugin
   - Optimize animation performance
2. Services section below hero:
   - 3 cards (grid layout, responsive)
   - Each card: icon, title, description
   - Cards fade + slide up on scroll (trigger: "top 80%")
   - Stagger: 0.2s between cards
   - Hover: shadow increase, slight scale
3. Parallax background enhancement:
   - Background moves at 0.5x scroll speed
   - Smooth parallax (scrub: false for performance)
4. Counter/stats section (optional):
   - "20+ Years" → animate count 0→20
   - "500+ Clients" → animate count 0→500
   - Triggered on scroll
5. Improvements:
   - Add scroll indicator (arrow at bottom of hero)
   - Bouncing animation on arrow
   - Arrow fades on scroll
   - Add smooth scroll behavior (CSS)

Keep brand colors: [COLORS]
Ensure all animations smooth (60fps, no stutter).
Test on mobile (responsive is critical).

This is ITERATION 2. More polish coming next.
```

#### **Iteration 3: Testimonials + Gallery + Polish**

```
Add premium sections to website:

Changes:
1. Testimonials carousel:
   - 5-7 testimonials (I'll provide testimonial data)
   - Auto-rotate every 5 seconds
   - Smooth slide transition (0.6s cubic-bezier)
   - Show: quote, author name, title, 5-star rating (⭐ emojis), avatar
   - Navigation: left/right arrows for manual control
   - Responsive: single column mobile, 2-column tablet, carousel desktop
2. Gallery section:
   - CSS Grid: 6 images (3x2 desktop, responsive)
   - Hover: zoom + shadow (1.0 → 1.05 scale, 0.3s transition)
   - Lazy loading: load images only when visible
3. About section enhancement:
   - Professional photo (left) + text (right, responsive)
   - Story: 2-3 sentences about business
   - Trust badges: Certifications, awards, years in business
4. Advanced animations:
   - Text splitting: Split headlines into words, animate each
   - Stagger reveals: 0.15s between items
   - ScrollTrigger markers: None in production (remove)
5. Mobile optimization:
   - Touch-friendly: Buttons 48x48px minimum
   - Stack everything single-column below 768px
   - No horizontal scroll

Testimonials data:
[PROVIDE 5-7 REAL TESTIMONIALS FROM GOOGLE/YELP]

Brand colors: [COLORS]
All animations should be smooth and professional.

This is ITERATION 3. Final polish in the next round.
```

#### **Iteration 4: Premium Polish + 3D (Optional) + Performance**

```
Final premium polish for production deployment:

Changes:
1. Three.js 3D animation (OPTIONAL, if budget allows):
   - Add 3D background element in hero (or separate section)
   - Example: Rotating dental tooth, rotating scales of justice, floating geometric shapes
   - Performance: Optimize for 60fps on desktop, 30fps mobile
   - Fallback: Static image if WebGL unavailable
2. Advanced micro-interactions:
   - Logo fade-in on page load (0.8s)
   - Menu items stagger-reveal
   - CTA button: ripple effect on click
   - Link hover: underline animation
3. Custom cursor (optional):
   - Follow mouse on hover
   - Change on CTA buttons
4. Mesh gradient backgrounds:
   - Use CSS mesh gradient (or SVG filter)
   - Apply to About or Stats section
   - Subtle, premium feel
5. Performance optimization:
   - Image compression: TinyPNG + ImageOptim (< 100KB each)
   - CSS/JS minification
   - Remove unused libraries
   - Lazy load below-fold images
   - Set Cache-Control headers (ready for Netlify)
6. SEO implementation:
   - LocalBusiness JSON-LD schema
   - Service schema markup
   - Review/rating schema
   - Meta tags (title, description, OG)
   - Canonical URL
7. Accessibility (WCAG AA):
   - Color contrast ≥ 4.5:1 on text
   - Alt text on all images
   - Keyboard navigation (tab through links)
   - Focus states visible
8. Browser testing:
   - Chrome, Safari, Firefox, Edge
   - iPhone 12, 14 Pro
   - Android (Samsung Galaxy)
9. Final checks:
   - No console errors
   - No 404s on images
   - All links working
   - Forms functional (if present)
   - Social share cards test well (OG tags)

Result: Production-ready single HTML file, optimized for Netlify deployment.

This is ITERATION 4. Ready to deploy and pitch!
```

### Key Technical Stack

**Why this approach:**

| Technology | Why | Alternative | Why Not |
|-----------|-----|-----------|---------|
| **HTML/CSS/JS vanilla** | Full control, no build step, instant updates | React/Next.js | Overkill for landing page, slower to iterate |
| **Tailwind (CDN)** | Instant styling, modern utilities, rapid prototyping | Bootstrap | Outdated feel, verbose, bloated CSS |
| **GSAP** | Industry standard (Netflix, Apple use it), smooth animations | Framer Motion | Requires React, adds complexity |
| **Three.js (CDN)** | Most popular 3D lib, 20K+ GitHub stars, mature | Babylon.js | Slightly heavier, less community |
| **Netlify** | Auto-deploy from GitHub, serverless functions, instant scaling | Netlify | Similar, but Netlify has better Next.js integration |

---

## Step 4: Animation Stack & Premium Effects

### GSAP Animation Patterns

**Text reveal (hero headline):**

```javascript
// Split headline into words
const words = document.querySelectorAll('.headline-word');

// Animate each word with stagger
gsap.to(words, {
  duration: 0.8,
  opacity: 1,
  y: 0,
  stagger: 0.15,
  delay: 0.3,
  ease: "power3.out"
});
```

**Scroll-triggered card reveal:**

```javascript
gsap.registerPlugin(ScrollTrigger);

gsap.to(".service-card", {
  scrollTrigger: {
    trigger: ".services-section",
    start: "top 80%",
    end: "bottom 20%",
    markers: false // Set to true for debugging
  },
  duration: 0.8,
  opacity: 1,
  y: 0,
  stagger: 0.2,
  ease: "power3.out"
});
```

**Parallax background:**

```javascript
gsap.to(".hero-bg", {
  scrollTrigger: ".hero",
  duration: 1,
  y: -100, // Moves slower than scroll
  ease: "none",
  transformOrigin: "center center"
});
```

**Counter animation (count up):**

```javascript
const animateCounter = (element, targetValue, duration = 2) => {
  gsap.to(element, {
    textContent: targetValue,
    duration: duration,
    snap: { textContent: 1 },
    scrollTrigger: {
      trigger: element,
      start: "top 80%"
    },
    ease: "power3.out"
  });
};

// Usage
animateCounter(document.querySelector('.years'), 25);
animateCounter(document.querySelector('.clients'), 500);
```

**Button glow animation:**

```javascript
gsap.to(".cta-button", {
  duration: 2,
  boxShadow: "0 0 30px rgba(255, 100, 50, 0.8)",
  repeat: -1,
  yoyo: true,
  ease: "sine.inOut"
});
```

**Hover scale + color shift:**

```javascript
document.querySelectorAll('.service-card').forEach(card => {
  card.addEventListener('mouseenter', () => {
    gsap.to(card, {
      duration: 0.3,
      scale: 1.02,
      boxShadow: "0 20px 40px rgba(0,0,0,0.2)",
      ease: "power3.out"
    });
    gsap.to(card.querySelector('h3'), {
      duration: 0.3,
      color: "#e74c3c" // Brand accent
    });
  });
  
  card.addEventListener('mouseleave', () => {
    gsap.to(card, {
      duration: 0.3,
      scale: 1,
      boxShadow: "0 5px 15px rgba(0,0,0,0.1)"
    });
    gsap.to(card.querySelector('h3'), {
      duration: 0.3,
      color: "#2c3e50"
    });
  });
});
```

**Testimonial carousel auto-rotation:**

```javascript
let currentSlide = 0;
const totalSlides = document.querySelectorAll('.testimonial').length;

const rotateTestimonials = () => {
  const carousel = document.querySelector('.testimonials-carousel');
  gsap.to(carousel, {
    duration: 0.8,
    x: -currentSlide * 100 + '%',
    ease: "power3.inOut"
  });
};

setInterval(() => {
  currentSlide = (currentSlide + 1) % totalSlides;
  rotateTestimonials();
}, 5000); // Rotate every 5 seconds
```

### Awwwards-Level Design Patterns

**Mesh gradient background:**

```css
.about-section {
  background: linear-gradient(
    135deg,
    #667eea 0%,
    #764ba2 25%,
    #f093fb 50%,
    #4facfe 75%,
    #00f2fe 100%
  );
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;
}

@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
```

**Glassmorphism effect:**

```css
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
}
```

**Grain texture overlay (premium feel):**

```css
.hero::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: 
    url('data:image/svg+xml,...'); /* SVG noise filter */
  opacity: 0.03;
  pointer-events: none;
}
```

**Easing cheat sheet (GSAP):**

| Easing | Feel | Use Case |
|--------|------|----------|
| `power3.out` | Natural deceleration | Default for most animations (hero reveals) |
| `back.out(1.7)` | Slight overshoot, playful | Button clicks, interactive elements |
| `elastic.out(1, 0.3)` | Bouncy, fun | Icons, badges, micro-interactions |
| `expo.out` | Fast start, dramatic slowdown | Page transitions, major reveals |
| `sine.inOut` | Smooth, balanced | Hover effects, loops (glow animations) |
| `cubic-bezier(0.68, -0.55, 0.265, 1.55)` | Custom bounce | Advanced tweaking |

---

## Step 5: Anti-Slop Design Checklist

**❌ NEVER do these (AI slop signals):**

- [ ] Using Inter/Roboto/Arial as default font (generic, boring)
- [ ] Purple gradient on white background (trendy trash)
- [ ] Uniform rounded corners on everything (cheap, lazy)
- [ ] Center-only layout (no personality, safe but boring)
- [ ] Generic hero + 3-column features layout (been done 10M times)
- [ ] Same shadow on every card (inconsistent design)
- [ ] Stock illustrations of diverse teams (cringey, overused)
- [ ] No animations (2010 design)
- [ ] Mobile-unfriendly (lose 60% of users)
- [ ] Slow load times (> 3s LCP = bounces)
- [ ] No clear CTA above fold (conversion killer)
- [ ] Testimonials from nobody (they need real names/photos)
- [ ] No color hierarchy (makes everything equally important = nothing stands out)
- [ ] Using system fonts only (Arial/Helvetica)

**✅ ALWAYS do these (premium design signals):**

- [ ] Pick an extreme tone:
  - Brutalism (raw, heavy fonts, bold colors)
  - Minimalism (white space, 2-3 colors max)
  - Retro-futurism (80s colors, geometric shapes)
  - Organic (curves, nature colors, soft shadows)
  - Luxury (serifs, heavy spacing, gold accents)
  - Editorial (large typography, asymmetric)
  - Art Deco (geometric, metallic, luxury feel)

- [ ] Distinctive font pairing (never use same combo twice):
  - Display: Poppins, Clash Display, Satoshi, Playfair, Monument
  - Body: Inter, DM Sans, Work Sans, Outfit

- [ ] Dominant color + strong accent (not evenly distributed):
  - Primary: 60% (background/major sections)
  - Secondary: 30% (supporting elements)
  - Accent: 10% (CTAs, highlights)

- [ ] Asymmetric layout, overlapping elements, diagonal flow
  - Images overlap text
  - Text breaks grid
  - Angled divider sections
  - Unexpected whitespace

- [ ] Grid-breaking elements:
  - Large image that spans 2 columns
  - Text rotated or at an angle
  - Content that pops out of the box

- [ ] Textured backgrounds (never flat solid):
  - Gradient mesh (multi-point colors)
  - Noise overlay (subtle grain at opacity 0.03)
  - Geometric patterns (SVG shapes)
  - Subtle animated background

- [ ] Staggered reveal on page load:
  - Logo appears first (0s)
  - Headline fades in (0.3s)
  - Subheadline slides up (0.6s)
  - CTA button glows (0.9s)
  - Creates anticipation

- [ ] Unexpected hover/scroll interactions:
  - Button reveals hidden text on hover
  - Images tilt slightly on mouse move
  - Cursor changes context
  - Text color shifts on section scroll
  - Cards flip or slide on hover

**Quality Checklist (Before Pitching):**

- [ ] Not using Inter/Roboto/Arial? ✓
- [ ] No purple gradient? ✓
- [ ] Border-radius varies by element? ✓
- [ ] Has asymmetric/overlapping elements? ✓
- [ ] Different fonts/colors from previous build? ✓
- [ ] Would someone ask "did AI make this?" — answer is NO? ✓
- [ ] Animations feel premium (60fps, easing is smooth)? ✓
- [ ] Mobile looks great (test on actual phone)? ✓
- [ ] Would you be proud to show this to a designer friend? ✓

---

## Step 6: SEO Implementation

### LocalBusiness JSON-LD Schema

Add this to `<head>` for local search optimization:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "[BUSINESS_NAME]",
  "description": "[BUSINESS_DESCRIPTION]",
  "image": "https://example.com/logo.png",
  "url": "https://example.com",
  "telephone": "[PHONE_NUMBER]",
  "email": "[EMAIL]",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "[STREET]",
    "addressLocality": "[CITY]",
    "addressRegion": "[STATE]",
    "postalCode": "[ZIP]",
    "addressCountry": "US"
  },
  "priceRange": "[PRICE_RANGE]",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "[LATITUDE]",
    "longitude": "[LONGITUDE]"
  },
  "areaServed": "[SERVICE_AREA]",
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "09:00",
      "closes": "18:00"
    }
  ]
}
</script>
```

### Service Schema

For service-based businesses (dentists, lawyers, salons):

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Service",
  "name": "[SERVICE_NAME]",
  "description": "[SERVICE_DESCRIPTION]",
  "provider": {
    "@type": "LocalBusiness",
    "name": "[BUSINESS_NAME]",
    "url": "https://example.com"
  },
  "areaServed": "[SERVICE_AREA]",
  "availableLanguage": ["en"]
}
</script>
```

### Review/Rating Schema

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "AggregateRating",
  "ratingValue": "4.8",
  "bestRating": "5",
  "worstRating": "1",
  "ratingCount": "127"
}
</script>
```

### Meta Tags

```html
<head>
  <!-- Basic -->
  <title>[BUSINESS_NAME] - [SERVICE]</title>
  <meta name="description" content="[META_DESCRIPTION, 160 chars max]">
  <meta name="keywords" content="[DENTIST, CHICAGO, etc]">
  
  <!-- OG (Open Graph) for social sharing -->
  <meta property="og:title" content="[TITLE]">
  <meta property="og:description" content="[DESCRIPTION]">
  <meta property="og:image" content="https://example.com/og-image.jpg">
  <meta property="og:url" content="https://example.com">
  <meta property="og:type" content="website">
  
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="[TITLE]">
  <meta name="twitter:description" content="[DESCRIPTION]">
  <meta name="twitter:image" content="https://example.com/og-image.jpg">
  
  <!-- Canonical -->
  <link rel="canonical" href="https://example.com">
  
  <!-- Mobile -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="theme-color" content="#2c3e50">
  
  <!-- Preload critical resources -->
  <link rel="preload" as="font" href="https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://cdnjs.cloudflare.com">
</head>
```

### Core Web Vitals Optimization

**LCP (Largest Contentful Paint) < 2.5s:**
- Optimize hero image (use WebP, max 100KB)
- Lazy load images below fold
- Preload critical fonts
- Minify CSS

**CLS (Cumulative Layout Shift) < 0.1:**
- Set explicit width/height on images
- Reserve space for ads/embeds
- Avoid inserting DOM elements above fold
- Use `contain: layout`

**FID (First Input Delay) < 100ms:**
- Minimize JavaScript execution
- Use `requestAnimationFrame` for animations
- Defer non-critical JS
- Remove render-blocking resources

---

## Step 7: Deployment to Netlify

### GitHub Setup

```bash
# Create repo for this rebuild
git init [business-name]-website
cd [business-name]-website

# Create files
echo "index.html" > index.html  # Claude Code output
echo "README.md" > README.md
echo "node_modules/" > .gitignore
echo "*.env" >> .gitignore
echo "" >> .gitignore

# Initial commit
git add .
git commit -m "feat: website rebuild for [business-name] - 4-iteration GSAP/scroll animation stack"

# Push to GitHub
gh repo create [business-name]-website --public --source . --remote origin --push
```

### Netlify Deployment

**Option 1: Connect via UI**
1. Go to https://netlify.com
2. Click "Import Project"
3. Paste GitHub repo URL
4. Netlify auto-detects, no config needed
5. Click "Deploy"
6. Live URL: `https://[business-name]-website.netlify.app`

**Option 2: CLI Deploy**

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy from repo
netlify deploy --prod
# Netlify auto-detects static HTML
# Live URL: https://[business-name]-website.netlify.app
```

### Netlify Configuration (Optional)

Create `netlify.toml` for advanced options:

```json
{
  "buildCommand": "echo 'Static HTML - no build needed'",
  "outputDirectory": ".",
  "headers": [
    {
      "source": "/images/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    },
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        }
      ]
    }
  ]
}
```

### Live Demo URL

**Format:** `https://[business-name]-website.netlify.app`

**Example:** `https://bright-smile-dental.netlify.app`

**This is your hook** — send this link in cold emails with "See your new site here" CTA.

---

## Step 8: Cold Outreach Strategy

### Email A/B Testing

Test these subject lines:

**Set A (High curiosity):**
- "I rebuilt your website — here's the link"
- "Your website just got a $10K makeover"
- "[Business Name] — Free website preview"

**Set B (Urgency/FOMO):**
- "Quick question: [3-second check]"
- "The #1 thing killing your leads (and it's on your site)"
- "Only 2 spots left this month"

**Set C (Benefit-focused):**
- "30-50% more bookings (see how)"
- "Your competitors are stealing your clients"
- "Mobile traffic you're losing right now"

### Cold Email Template (Version 1: Direct)

```
Subject: I rebuilt your website — here's the link

Hi [OWNER_NAME],

I spent 2 hours rebuilding your website. Here's the live link:
https://[business-name]-website.netlify.app

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
[YOUR_PHONE]

P.S. This usually takes 2-3 weeks at design agencies. I can rebuild yours in days.
```

### Cold Email Template (Version 2: Problem-Aware)

```
Subject: The #1 thing killing your leads (found it on your site)

Hi [OWNER_NAME],

I analyzed your website for [BUSINESS_TYPE] best practices, and found 3 major issues costing you bookings:

1. Mobile is broken (60% of your traffic bounces immediately)
2. No clear CTA above the fold (people don't know what to do)
3. Zero animations (looks stuck in 2010, kills trust)

Here's what a rebuild looks like:
https://[business-name]-website.netlify.app

I built this in a weekend. It has:
- 60% faster load time
- Mobile-perfect responsive design
- Scroll animations that engage visitors
- Clear booking CTAs
- SEO optimized

If you want to see the difference a real website makes, let's talk.

[YOUR_NAME]
[YOUR_PHONE]

P.S. Your competitor [COMPETITOR_NAME] just rebuilt theirs last month. Worth thinking about.
```

### Cold Email Template (Version 3: Social Proof)

```
Subject: 3 [CITY] dentists just rebuilt their sites (+27% more bookings)

Hi Dr. [OWNER_NAME],

I've rebuilt websites for 3 dentists in the Chicago area this month. 
Average result: 27% increase in booking inquiries within 60 days.

Here's one example (real site, live):
https://[business-name]-website.netlify.app

What changed:
- Modern design (no more 2010 vibes)
- Mobile perfection (users can book from phone)
- Smooth animations (visitors stay longer, convert more)
- Google-friendly SEO
- Hosting/maintenance included

The cost is $5K-$10K depending on scope.

Interested in seeing what your site could look like?

[YOUR_NAME]
[YOUR_PHONE]

P.S. Most dentists see ROI in 3 months. Happy to share metrics from my other clients.
```

### AgentMail Integration

```bash
# Set up AgentMail (requires API key in ~/.env)
export AGENTMAIL_API_KEY="your_api_key_here"

# Send email via AgentMail
curl -X POST "https://api.agentmail.to/send" \
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "owner@brightsmile.com",
    "subject": "I rebuilt your website — heres the link",
    "body": "[EMAIL_BODY_HERE]",
    "from": "you@yourname.com",
    "track": true
  }'
```

### Follow-Up Sequence (7-Day)

**Email 1 (Day 0): Initial Pitch**
```
Subject: I rebuilt your website — here's the link

Hi [OWNER_NAME],

[INITIAL_EMAIL_TEMPLATE]

Talk soon,
[YOUR_NAME]
```

**Email 2 (Day 3): Soft Follow-Up**
```
Subject: Re: I rebuilt your website — here's the link

Hi [OWNER_NAME],

Did you get a chance to see the new site?
[LIVE_DEMO_URL]

No pressure, but it's worth 90 seconds to check it out.

Talk soon,
[YOUR_NAME]
```

**Email 3 (Day 7): Final Push (Scarcity)**
```
Subject: Last chance to lock in early-bird pricing

Hi [OWNER_NAME],

I'm filling up my calendar for March. 

Last spot available for your type of business:
[LIVE_DEMO_URL]

If you want to move forward, let me know ASAP.

[YOUR_NAME]
```

### Tracking & Analytics

AgentMail provides:
- **Opens**: When email is opened (% open rate)
- **Clicks**: Which links clicked (CTR)
- **Time-to-open**: How long until first open
- **Device**: Desktop vs mobile
- **Location**: Geographic data

Use this data to refine:
- Subject lines (if < 20% open rate, rewrite)
- Email copy (if < 30% click rate, simplify)
- CTA placement (if clicks on wrong link, reposition)

---

## Step 9: Closing & Objection Handling

### Common Objections

**Objection 1: "It's too expensive"**

Response:
```
I get it. But think about it this way:
- How many leads do you lose each month to competitors with better websites?
- Even 2-3 extra bookings = $5K-$10K in revenue (vs $5K cost)
- ROI: 3-6 months, then pure profit

Plus: This is for a complete rebuild, not a cosmetic refresh. 
You're getting animations, mobile optimization, SEO, hosted on fast servers.

What's your revenue per booking? That's the real number.
```

**Objection 2: "Can I see more examples?"**

Response:
```
Absolutely. Here are 3 similar businesses I've rebuilt:
1. [DENTIST_NAME] - [LIVE_URL] (27% more bookings)
2. [LAWYER_NAME] - [LIVE_URL] (50% increase in leads)
3. [SALON_NAME] - [LIVE_URL] (35% more inquiries)

I'll show you these on our call. Plus analytics showing actual results.
```

**Objection 3: "I'm happy with my current site"**

Response:
```
That's cool. But quick question: 
- When was it built? [If 3+ years old, it's outdated by web standards]
- How many of your leads come from mobile? [Usually 60%+, often broken]
- Are you getting as many bookings as 2 years ago? [Probably not]

Websites degrade over time. Technology changes, user expectations rise.

Quick check: Compare yours to a competitor's (built recently). 
I bet theirs converts better. That's what I fix.

No pressure either way.
```

**Objection 4: "I don't have time for this"**

Response:
```
Good news: You don't have to do anything. 

Here's the process:
1. I build the site (you give me 30 min to gather info)
2. You review it (takes 15 min)
3. I deploy it (you just approve)
4. Done. I handle everything.

Total time commitment: ~1 hour. 
Total timeline: 1-2 weeks.

That's it.
```

**Objection 5: "I'll lose my email list / SEO / etc"**

Response:
```
Great question. Here's how I handle it:

1. **Email list**: Stays exactly the same. We preserve all your forms, integrations, email capture.

2. **SEO**: Actually improves. New site has:
   - Faster load times (huge for rankings)
   - Mobile optimization (Google priority)
   - Proper schema markup
   - Clean URL structure
   - Better internal linking
   - We do 301 redirects from old pages to new

3. **Forms/integrations**: Everything transfers over. Contact forms, appointment schedulers, email integrations.

You keep everything. You just get a better-looking, faster, converting site.
```

### Sales Call Structure (15 minutes)

**1. Build rapport (2 min)**
```
"Thanks for hopping on. Quick background—I've been rebuilding websites 
for [NICHE] for [TIME_PERIOD]. Usually see 20-50% increase in 
booking inquiries. I think I can do the same for you."
```

**2. Show the mock (3 min)**
```
"Here's what your site would look like:
[SHARE LIVE_URL]

Walk them through:
- Hero animation
- Scroll effects
- Testimonials carousel
- Mobile version
- Loading speed
- CTAs
"
```

**3. Acknowledge their situation (2 min)**
```
"Your current site is [HONEST ASSESSMENT].
The main issues are:
1. [MOBILE/SPEED/DESIGN]
2. [DESIGN/CTA/TRUST_SIGNALS]
3. [CONVERSION/CLARITY/ANIMATION]

Here's how this fixes each..."
```

**4. Explain the value (3 min)**
```
"When we rebuild, here's what happens:
- 60% faster load time (fewer bounces)
- Mobile works perfectly (captures leads from phones)
- Animations build trust (looks premium, not DIY)
- Clear CTAs (easier bookings)

Result: typically 20-50% more inquiries in first 60 days.

Your current inquiry rate is [X]/month. 
Even 10% improvement = [Y] more bookings × $[PRICE] = $[VALUE] 

The rebuild pays for itself in 1-2 months."
```

**5. Get to price (3 min)**
```
"For [BUSINESS_NAME], I'd recommend the Pro package: $5K.

That includes:
- Full rebuild (4 iterations, approved at each stage)
- Hosting on Netlify (fast, reliable)
- SEO optimization (local business schema)
- Ongoing support (3 months free tweaks)

Or if you want the premium package with 3D animations: $10K.

Questions?"
```

**6. Close (2 min)**
```
"What does your gut say?"

[If interested] "Perfect. Here's next steps:
1. 50% deposit ($2.5K or $5K) to get started
2. You gather info (business copy, testimonials, photos)
3. I build Iteration 1 (you review, approve)
4. Iterate to perfection
5. Deploy and go live

Timeline: 1-2 weeks. Any concerns?"

[If not interested] "No worries. At least you know what's possible. 
My offer stands if you change your mind. 
Good luck with the current site."
```

### Closing Tactics

**Scarcity play:**
```
"I have 2 spots left in March. 
Want to secure one before they fill up?"
```

**Social proof play:**
```
"[COMPETITOR_NAME] just went live last month. 
Seeing 40% more inquiries already. Worth thinking about."
```

**Urgency play:**
```
"Every month you wait, you're losing ~$2K in leads to competitors 
with better websites. I can fix this in 2 weeks."
```

**Money-back guarantee (optional):**
```
"If you're not happy with the rebuild, I'll give you 50% back. 
That's how confident I am."
```

---

## Step 10: API Keys & Setup

### Required Environment Variables

Create `.env` file in your project root:

```bash
# Firecrawl (site scraping & analysis)
FIRECRAWL_API_KEY=your_firecrawl_api_key

# Netlify (deployment)
NETLIFY_TOKEN=your_netlify_token

# Gemini (image generation for hero visuals)
GEMINI_API_KEY=your_gemini_api_key

# AgentMail (cold email sending)
AGENTMAIL_API_KEY=your_agentmail_api_key

# Optional: GitHub (for repo creation)
GITHUB_TOKEN=your_github_token
```

### API Setup Instructions

#### **Firecrawl API Key**

1. Go to https://firecrawl.dev/
2. Sign up (free tier: 10K credits/month)
3. Copy API key from dashboard
4. Install CLI:
   ```bash
   npm install -g firecrawl-cli
   firecrawl login --api-key YOUR_KEY
   ```
5. Test:
   ```bash
   firecrawl scrape "https://example.com" --format markdown
   ```

#### **Netlify Token**

1. Go to https://netlify.com/account/tokens
2. Click "Create Token"
3. Copy token (never commit to git)
4. Add to `.env`:
   ```bash
   NETLIFY_TOKEN=your_token_here
   ```
5. Test:
   ```bash
   netlify deploy --prod
   ```

#### **Gemini API Key**

1. Go to https://ai.google.dev
2. Click "Get API Key"
3. Create new project if needed
4. Copy API key
5. Test:
   ```bash
   curl -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent" \
     -H "Content-Type: application/json" \
     -d '{"contents": [{"parts": [{"text": "Say hello"}]}]}' \
     -H "x-goog-api-key: YOUR_KEY"
   ```

#### **AgentMail API Key**

1. Go to https://agentmail.to
2. Create account or login
3. Go to Settings → API Keys
4. Generate new key
5. Add to `.env`:
   ```bash
   AGENTMAIL_API_KEY=your_key_here
   ```
6. Test:
   ```bash
   curl -X POST "https://api.agentmail.to/send" \
     -H "Authorization: Bearer YOUR_KEY" \
     -H "Content-Type: application/json" \
     -d '{"to": "test@example.com", "subject": "Test", "body": "Hello"}'
   ```

#### **GitHub Token**

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Scopes: `repo`, `workflow`, `gist`
4. Copy token
5. Add to `.env`:
   ```bash
   GITHUB_TOKEN=your_token_here
   ```

---

## Step 11: Fast Build Path (AntiGravity + Stitch)

**When to use:** Speed matters over control, or you're cloning a niche (same business type, different city/brand).
**When NOT to use:** Client needs custom backend, complex logic, or absolute design control → use Step 3 (Claude Code) instead.

> Full background on Jack Roberts' method, frameworks, and anti-slop rules: `references/jack-roberts-method.md`

---

### Tool Setup

| Tool | Purpose | URL |
|------|---------|-----|
| AntiGravity | Visual website builder (Google) | antigravity.dev |
| Stitch | Design agent for brand variations | stitch.withgoogle.com |
| Gemini 3 | AI engine for copy, design systems, validation | gemini.google.com |
| Spline | 3D animation, no-code, embeds in AntiGravity | spline.design |

---

### Workflow: First Client in a Niche (2–3 days)

**Phase 1: Brand Brief (30 min)**
```
Inputs needed:
- Business name + industry
- Primary color (from scrape-site.sh output)
- Logo URL or file
- 3 key services
- Target customer (age, location, problem)
- Desired tone: professional / friendly / luxury / urgent

Prompt for Gemini 3:
"I'm rebuilding a [industry] website for [business name] in [city].
Brand colors: [hex]. Tone: [tone]. Target customer: [customer].
Generate: (1) complete design system (colors, fonts, spacing), (2) hero headline + subheadline,
(3) 3 benefit bullets, (4) CTA text, (5) FAQ (5 questions), (6) social proof angle."
```

**Phase 2: Build in AntiGravity (4–8 hours)**

1. Open AntiGravity → New Project → Blank or pick a base template
2. Load Gemini's design system: paste colors/fonts into AntiGravity theme settings
3. Build these sections in order:
   - **Hero**: Full-screen, headline from Gemini, CTA button, background (video or Spline 3D)
   - **Social proof bar**: logos or "trusted by X businesses"
   - **Services**: 3-column card grid, icons, animate on scroll
   - **Testimonials**: carousel with star ratings (extract from Google with scrape-site.sh)
   - **CTA section**: Book/call/contact, prominent button
   - **Footer**: address, phone, hours, links
4. Apply GSAP scroll animations to cards and section reveals (AntiGravity has built-in GSAP support)
5. Add Spline 3D to hero if Tier 2+:
   - Open spline.design → create or pick a 3D scene → Export → "Embed on web"
   - Copy embed code → paste into AntiGravity hero section HTML embed block

**Phase 3: Mobile Pass (1 hour)**
- Switch to mobile view in AntiGravity
- Stack columns to single-column
- Increase tap target sizes to ≥44px
- Test hero headline font size (min 32px on mobile)
- Check video/Spline loads without lag (fallback to static image if needed)

**Phase 4: Deploy (15 min)**
```bash
# In AntiGravity: Publish → Connect GitHub → auto-push to repo
# Then:
netlify login
netlify init   # link to repo
netlify deploy --prod
# Live URL → send in cold email
```

---

### Workflow: Cloning for Same-Niche Repeat (4–6 hours per client)

Once you have one excellent template in a niche (e.g., dentist in Chicago):

```
In AntiGravity:
1. Duplicate master project → rename to new client
2. Open Stitch → "Generate variation" → upload new brand brief:
   - New business name, logo, colors, city, testimonials
3. Stitch regenerates: typography, palette, hero copy, service names, CTA text
4. Review + approve each section (spot-check layout, fix anything off)
5. Deploy to Netlify → new subdomain per client
```

**What changes automatically:** logo, colors, fonts, copy, testimonials, service names
**What you fix manually:** any layout breaks, custom photos, contact info in footer

---

### Gemini 3 Prompts (Copy-Paste Ready)

**Design system generation:**
```
Business: [name], Industry: [industry], City: [city]
Primary color: [hex from scrape], Tone: [professional/warm/luxury]
Generate a complete design system:
- Primary + secondary + accent hex colors (60/30/10 rule)
- Display font + body font (NOT Inter, Roboto, or Arial)
- Base font size + heading scale
- Border radius (pick one: sharp 0px / soft 8px / round 16px)
- Button style (filled / outlined / ghost)
```

**Hero copy:**
```
Business: [name] — [one-line description]
Target customer: [customer type] with problem: [problem]
Write: (1) H1 headline (max 8 words, outcome-focused), (2) subheadline (max 20 words),
(3) primary CTA button text (2-4 words), (4) secondary CTA (optional)
Tone: [tone]. No generic phrases like "Welcome to" or "We are".
```

**Cold email with live link:**
```
Write a cold email for a [industry] owner.
My rebuilt version of their site is live at: [URL]
Key improvements made: [list 3 specific improvements from scrape output]
Keep it under 150 words. No fluff. Lead with the link.
Subject line + email body. Use [SENDER_NAME] as signature.
```

---

### Decision Matrix: AntiGravity vs Claude Code

| Situation | Use AntiGravity + Stitch | Use Claude Code |
|-----------|--------------------------|-----------------|
| First build in a niche | ✅ Build the master template | — |
| 2nd–10th client in same niche | ✅ Clone via Stitch | — |
| Custom animations (GSAP complex) | — | ✅ |
| Backend / API integration | — | ✅ |
| Client needs source code | — | ✅ |
| Speed is the priority | ✅ | — |
| Absolute design control | — | ✅ |


## Step 12: Autonomous Cron Setup

Automate the entire pipeline to run daily without human intervention. Uses `openclaw cron add` to schedule an isolated agent session that finds targets, builds sites, sends outreach emails, and posts results to Discord.

### Scripts Overview

Two new scripts power the automated pipeline:

| Script | Purpose |
|--------|---------|
| `scripts/build-site.sh` | Takes scraped site content → builds with Claude Code → deploys to Netlify → returns live URL |
| `scripts/run-pipeline.sh` | Master orchestrator: find-targets → scrape → build → email → summary |

### Manual Run

```bash
# Run the full pipeline manually
bash scripts/run-pipeline.sh --niche dentist --city chicago --limit 3 --sender-name "Alex"

# Or build a single site
bash scripts/build-site.sh \
  --domain "brightsmile.com" \
  --scrape-dir "/tmp/website-remake-targets/brightsmile_com" \
  --niche "dentist" \
  --city "chicago"
```

### Cron Schedule (Weekdays 9 AM Chicago Time)

Add this cron job to run the pipeline every weekday at 9 AM Central:

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
    "message": "Run the website-remake pipeline. Execute: bash /Users/andreofastora/.openclaw/workspace/skills/website-remake-skill/scripts/run-pipeline.sh --niche dentist --city chicago --limit 3 --sender-name Alex. Log output and post a summary of results (sites built, emails sent, failures) to #website-rebuilder tagging <@1468821540861902973>."
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

> **Note:** `enabled: false` by default — flip to `true` only after testing manually with `run-pipeline.sh` and confirming all API keys are present.

### What the Cron Does Each Day

| Time | Action | Output |
|------|--------|--------|
| 9:00 AM CT | Agent wakes up in isolated session | — |
| 9:01 AM | Runs `find-targets.sh` → searches Brave for outdated sites | Markdown table of targets |
| 9:02 AM | Runs `scrape-site.sh` on top 3 targets | `/tmp/website-remake-targets/*/content.md` |
| 9:05 AM | Runs `build-site.sh` for each target → Claude Code builds site | Full website in `/tmp/website-rebuilds/` |
| 9:15 AM | Deploys each build to Netlify | Live `.netlify.app` URLs |
| 9:16 AM | Extracts business emails from scraped content | — |
| 9:17 AM | Sends cold outreach via `send-email.sh` (AgentMail) | Email delivery confirmation |
| 9:18 AM | Posts summary to `#website-rebuilder` Discord channel | "3 built, 2 emails sent, 0 failed" |

### Enable / Disable

Manage via OpenClaw's `cron` tool (or ask Andre directly):

```
# List all crons (including disabled)
→ cron action:list includeDisabled:true

# Enable the daily run
→ cron action:update jobId:<id> patch:{"enabled": true}

# Disable (pause without deleting)
→ cron action:update jobId:<id> patch:{"enabled": false}

# Delete entirely
→ cron action:remove jobId:<id>

# Trigger a manual run immediately
→ cron action:run jobId:<id>
```

### Customizing the Niche & City

Edit the cron payload message to target different markets:

```json
{
  "name": "website-remake-lawyers-miami",
  "schedule": {
    "kind": "cron",
    "expr": "0 10 * * 1-5",
    "tz": "America/Chicago"
  },
  "payload": {
    "kind": "agentTurn",
    "model": "haiku",
    "message": "Run the website-remake pipeline. Execute: bash /Users/andreofastora/.openclaw/workspace/skills/website-remake-skill/scripts/run-pipeline.sh --niche lawyer --city miami --limit 3 --sender-name Alex. Post summary to #website-rebuilder."
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

All secrets must be present in `$HOME/.openclaw/workspace/.secrets/` before the cron fires:

| File | Used By |
|------|---------|
| `brave-search-api-key.txt` | `find-targets.sh` — Brave Search API |
| `firecrawl-api-key.txt` | `scrape-site.sh` — Firecrawl site analysis |
| `netlify-token.txt` | `build-site.sh` — Netlify deployment |
| `agentmail-api-key.txt` | `send-email.sh` — cold outreach emails |


## SEO & GEO Optimization Step

This step runs AFTER the site is built and deployed. Every website remake must include this — it's what makes the $5K site worth $10K.

### Why Multi-Page Architecture Wins

**The #1 SEO mistake on rebuilt sites: keeping everything on one page.**

Single-page sites have one URL to rank. Multi-page sites have dozens. Every service page, every location page, every FAQ entry is a separate opportunity to rank for a different keyword. For a dentist in Chicago:

- `/services/teeth-whitening` → ranks for "teeth whitening chicago"
- `/services/dental-implants` → ranks for "dental implants chicago cost"
- `/services/invisalign` → ranks for "invisalign chicago near me"
- `/about` → ranks for branded searches + E-E-A-T signals
- `/faq` → ranks for question-based searches ("how long do dental implants last")
- `/blog/` → long-tail content traffic

One page = 1 ranking opportunity. Ten pages = 10+ ranking opportunities. This is not optional — build multi-page for every client.

**Minimum page structure for every remake:**
```
/                     → Homepage (primary keyword: "[service] [city]")
/services/            → Services overview
/services/[service-1] → Individual service pages (1 per service)
/services/[service-2]
/about                → About + team (E-E-A-T)
/contact              → Contact + location (Local SEO)
/faq                  → FAQ schema markup
/blog/                → Blog index (optional but high value)
```

### SEO Implementation (On-Page)

Run this for every page after the build:

**1. Title tags** — primary keyword first, brand second, 50-60 chars
```html
<title>Teeth Whitening Chicago | Bright Smile Dental</title>
```

**2. Meta descriptions** — include keyword + CTA, 150-160 chars
```html
<meta name="description" content="Professional teeth whitening in Chicago. Same-day appointments. Get a brighter smile in 1 hour. Call or book online at Bright Smile Dental.">
```

**3. H1 → H2 → H3 hierarchy** — one H1 per page, keyword in H1
```html
<h1>Teeth Whitening in Chicago</h1>
<h2>How Our Whitening Process Works</h2>
<h2>Why Choose Bright Smile Dental</h2>
```

**4. JSON-LD structured data** — mandatory on every page
```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Bright Smile Dental",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main St",
    "addressLocality": "Chicago",
    "addressRegion": "IL"
  },
  "telephone": "+1-312-555-0100",
  "openingHours": "Mo-Fr 09:00-18:00",
  "priceRange": "$$",
  "image": "https://brightsmile.com/og-image.jpg",
  "url": "https://brightsmile.com"
}
```

**5. Open Graph tags** — for social sharing
```html
<meta property="og:title" content="Teeth Whitening Chicago | Bright Smile Dental">
<meta property="og:description" content="Professional teeth whitening. Same-day appointments.">
<meta property="og:image" content="https://brightsmile.com/og-image.jpg">
<meta property="og:url" content="https://brightsmile.com/services/teeth-whitening">
```

**6. Canonical tags** — prevent duplicate content
```html
<link rel="canonical" href="https://brightsmile.com/services/teeth-whitening">
```

**7. Internal linking** — every service page links to at least 3 other pages. Homepage links to all service pages. Blog posts link to relevant service pages.

**8. Image alt text** — every image has descriptive alt text with keyword where natural
```html
<img src="whitening-before-after.jpg" alt="Before and after teeth whitening Chicago patient results">
```

### Core Web Vitals (Required)

Every rebuilt site must pass Core Web Vitals — Google uses these as ranking signals:

```bash
# Run Lighthouse audit after deploy
npx lighthouse https://your-site.netlify.app --output=json --quiet | jq '.categories | {performance: .performance.score, seo: .seo.score, accessibility: .accessibility.score}'
```

**Targets:**
- LCP (Largest Contentful Paint): < 2.5s
- FID/INP (Interaction to Next Paint): < 200ms
- CLS (Cumulative Layout Shift): < 0.1
- Performance score: 90+
- SEO score: 95+

**Quick wins for performance:**
```html
<!-- Preload critical fonts -->
<link rel="preload" href="/fonts/display.woff2" as="font" type="font/woff2" crossorigin>

<!-- Lazy load below-fold images -->
<img src="team.jpg" loading="lazy" alt="...">

<!-- Defer non-critical JS -->
<script src="animations.js" defer></script>
```

**Claude Code prompt for Core Web Vitals:**
```
Audit this site for Core Web Vitals. Check:
1. Are all images using lazy loading below the fold?
2. Are fonts preloaded?
3. Is there any layout shift from images without dimensions?
4. Are animations using CSS transforms (not layout properties)?
5. Is JS deferred where possible?
Fix any issues you find and ensure LCP < 2.5s.
```

### GEO Optimization (Generative Engine Optimization)

GEO = optimizing to be cited by AI search engines: ChatGPT, Perplexity, Claude, Gemini, Grok.

This is new but already matters. When someone asks "what's the best dentist in Chicago" to an AI assistant, you want your client's name to appear. Here's how:

**Why it works:** AI engines pull from authoritative, well-structured content. They favor:
- Clear factual statements ("Bright Smile Dental has served Chicago since 2008")
- Specific data points ("Over 2,400 5-star reviews")
- FAQ-format content (question → direct answer)
- Named entities (real people, real addresses, real credentials)
- Content that other sites link to or quote

**GEO Implementation checklist:**

**1. FAQ page with direct-answer format**
Every question answered in the first sentence, then expanded:
```
Q: How much does teeth whitening cost in Chicago?
A: Professional teeth whitening in Chicago typically costs $300-$600 at Bright Smile Dental, depending on the treatment type. In-office whitening starts at $299 for a 1-hour session...
```

**2. About page with specific credentials**
AI engines weight named entities and credentials heavily:
```
Dr. Sarah Chen, DDS, has practiced dentistry in Chicago's Lincoln Park neighborhood since 2008. She completed her dental degree at Northwestern University Dental School and holds a certificate in cosmetic dentistry from the American Academy of Cosmetic Dentistry.
```

**3. Statistics and data points**
Specific numbers make content more citable:
```
"We've completed over 4,200 teeth whitening treatments since 2015, with a 97% patient satisfaction rate across 2,400+ Google reviews."
```

**4. Clear entity markup**
Help AI understand who/what this is with schema:
```json
{
  "@type": "Dentist",
  "name": "Bright Smile Dental",
  "medicalSpecialty": "Dentistry",
  "award": "Chicago Magazine Top Dentist 2023, 2024",
  "numberOfEmployees": 12,
  "foundingDate": "2008"
}
```

**5. Mention-worthy content**
Write one genuinely useful piece per niche that other sites would want to link to or AI would want to cite:
```
Example: "Complete Guide to Teeth Whitening in Chicago: Costs, Options, and What to Expect"
— 1500+ words, covers all options, includes real pricing, answers the questions people actually ask
```

**6. Local citations (AI checks these)**
Ensure NAP (Name, Address, Phone) is consistent across:
- Google Business Profile (mandatory — set this up for every client)
- Yelp
- Apple Maps
- Bing Places
- Industry directories (Healthgrades for medical, Avvo for lawyers, etc.)

**GEO Claude Code prompt:**
```
Add GEO optimization to this website. I need it to appear in AI search engine results when people ask about [service] in [city].

Add:
1. A /faq page with 15 questions answered in direct-answer format (question first, answer in first sentence)
2. Update the /about page to include specific credentials, founding date, number of clients served, and any awards
3. Add specific statistics and data points throughout the site (reviews count, years in business, clients served)
4. Update JSON-LD schema to include all business details: specialty, awards, employee count, founding date
5. Write one 1500-word authoritative guide page at /guide/[topic] that thoroughly answers the most common question in this niche

Make every claim specific and verifiable. Avoid vague marketing language.
```

### SEO Pitch to Client

Use this when selling the upgrade or justifying the $10K price:

> "The site I'm building you isn't just a redesign — it's engineered to rank. Your current site has one page. The new one will have 12+ pages, each targeting a different search term your customers are using right now. We're also optimizing for AI search — when someone asks ChatGPT or Google's AI who the best [service] in [city] is, I want your name to come up. That's GEO optimization, and most agencies aren't doing it yet. This is a competitive advantage window that closes as more businesses catch on."

---

---

## Anthropic Frontend Design + Web Interface Guidelines + SEO Audit — Synthesized

### The Core Design Philosophy (from Anthropic's frontend-design skill)

Every website rebuild must start with a committed aesthetic direction — not a vague brief but a specific, named style. Before a single line of code is written, decide: is this brutalist, maximalist, retro-futuristic, organic, luxury, editorial, art deco, or something else entirely? The Anthropic frontend skill is explicit: pick an extreme and execute it with precision. Timid "balanced" design is forgettable design. Bold maximalism and refined minimalism both win awards — mediocre middle-ground doesn't.

The typography rule is non-negotiable: never Inter, Roboto, Arial, or system fonts. Every rebuilt site must use a distinctive display font paired with a refined body font. The Anthropic skill recommends pairing unexpected, characterful display fonts with refined body fonts — a combination that immediately signals professional design rather than AI-generated slop. Match the font pairing to the aesthetic direction: Neue Machina fits tech/industrial, Monument Extended fits luxury/fashion, Satoshi fits modern minimal, Clash Display fits editorial.

Color must follow the dominant + sharp accent rule: pick one dominant color and one strong accent, never distribute colors evenly across the palette. Dominant colors with sharp accents outperform timid, evenly-distributed palettes every time.

For motion: one well-orchestrated page load with staggered reveals creates more delight than scattered micro-interactions. Prioritize CSS-only animations for performance. Use scroll-triggering and hover states that surprise. The bar for "good enough" is: does someone stop scrolling and say "how did they do that?"

**Web Interface Guidelines checklist** (run this after every build):
- Fetch the live guidelines from `https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md` and run a compliance audit against every page
- Check: tap target sizes ≥ 44px, color contrast ≥ 4.5:1, viewport meta tag present, no horizontal scroll on mobile, all interactive elements keyboard accessible
- Check: images have alt text, headings follow logical hierarchy, form labels present, error messages descriptive
- Check: no layout shift on load, animations respect prefers-reduced-motion, focus indicators visible

### SEO Audit (from coreyhaines31/marketingskills)

Run this full audit on every rebuilt site before delivering to the client. This is what separates a $2,500 site from a $10,000 site — the client can see Google rankings improve within 30-90 days.

**Priority order for the audit:**
1. Crawlability & Indexation — can Google find and index every page?
2. Technical Foundations — is the site fast and functional?
3. On-Page Optimization — is content optimized per page?
4. Content Quality — does it deserve to rank?
5. Authority & Links — does it have credibility signals?

**Technical audit checklist:**
- robots.txt exists, no important pages blocked, sitemap referenced
- XML sitemap submitted to Google Search Console, contains only canonical indexable URLs
- Every important page reachable within 3 clicks from homepage
- No orphan pages (every page has at least one internal link pointing to it)
- HTTPS across entire site, valid SSL, no mixed content, HTTP→HTTPS redirect working
- Core Web Vitals: LCP < 2.5s, INP < 200ms, CLS < 0.1
- Mobile responsive, same content as desktop, tap targets ≥ 44px

**On-page audit checklist (run per page):**
- Unique title tag, primary keyword near the start, 50-60 characters
- Unique meta description, 150-160 characters, includes keyword + CTA
- One H1 per page, H1 contains primary keyword, logical H1→H2→H3 hierarchy
- Keyword appears in first 100 words of body content
- All images: descriptive file names, alt text, WebP format, lazy loading
- No keyword cannibalization — each page targets a unique primary keyword
- Internal links use descriptive anchor text (not "click here")

**Schema markup note:** web_fetch and curl cannot detect JavaScript-injected schema (Yoast, AIOSEO, RankMath inject JSON-LD via JS). Always validate schema using Google's Rich Results Test (search.google.com/test/rich-results) — it renders JavaScript. Never report "no schema found" based solely on curl output.

**Claude Code prompt for running the full SEO audit:**
```
Run a complete SEO audit on this website. Check:

TECHNICAL:
1. Does robots.txt exist and is it blocking anything important?
2. Is there an XML sitemap? Does it include all pages?
3. Are all pages reachable within 3 clicks from the homepage?
4. Is HTTPS working with a valid SSL cert and HTTP→HTTPS redirect?
5. Run a Lighthouse audit and report Core Web Vitals scores

ON-PAGE (check each page):
6. Are title tags unique, 50-60 chars, with keyword near the start?
7. Are meta descriptions unique, 150-160 chars, with keyword + CTA?
8. Does each page have exactly one H1 with the target keyword?
9. Are all images using alt text and lazy loading?
10. Is there JSON-LD structured data on every page?

Report all findings with impact level (High/Medium/Low) and exact fixes for each issue.
```

**E-E-A-T signals to add for every client site:**
- Author/owner bio page with real credentials, years in business, certifications
- Physical address and phone number (boosts local trust)
- Case studies or testimonials with real names and photos
- Any awards, press mentions, or industry recognition
- Privacy policy and terms of service pages (required for Google trust)

