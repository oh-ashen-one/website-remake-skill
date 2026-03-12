# Jack Roberts Method — Reference Notes

*Synthesized from Jack Roberts' 12 YouTube videos on $10K website building.*
*See SKILL.md Step 11 for the actionable fast-build workflow.*

---

## The AntiGravity + Stitch Cloning System (Conceptual)

Jack's core innovation: build one excellent template, then use AntiGravity + Stitch to clone it across brands automatically. First client in a niche takes 2–3 days. Every subsequent one takes 4–6 hours.

The cloning system: feed Stitch a brand brief (colors, fonts, tone, industry) + your master template → Stitch generates variations automatically, adapting typography, palette, copy, and imagery while keeping the conversion structure intact.

---

## Gemini 3 as the Core Engine

Jack uses Gemini 3 for:
1. Ideate + validate — landing page frameworks, A/B copy variants, psychology-driven CTAs
2. Design systems generation — complete color/typography/spacing/component systems from a brand brief
3. Rapid prototyping — layout and hierarchy mockups within AntiGravity
4. Copy generation — headlines, CTAs, testimonials, FAQs with specific tone parameters
5. A/B testing frameworks — automatic multi-variant copy and design generation

---

## Spline for 3D Animation (No-Code)

Connect Spline directly to AntiGravity — no Three.js required. Workflow:
1. Design 3D element in Spline (rotating product, floating shapes, morphing logo)
2. Export as web-embedded component
3. Drop into AntiGravity hero section
4. Spline handles performance optimization + animation loops

---

## The PAGES Framework

- **P = Purpose**: Define the conversion goal first (book, buy, lead). Design backwards from it.
- **A = Animation**: Hero must have scroll-stopping animation (video, parallax, 3D).
- **G = Gorgeous**: Coherent color hierarchy, modern typography, whitespace, asymmetric layouts.
- **E = Engagement**: 2–3 interactive moments per page (hover effects, counters, carousels).
- **S = Sections**: Clear structure (hero, value prop, social proof, CTA, footer) with scroll reveals.

---

## The SAS Framework (Profitable SaaS Websites)

1. Validate the idea — market research, competitor analysis, willingness to pay
2. Build a beautiful converting landing page (PAGES above)
3. Add the product/app backend
4. Automate everything (follow-ups, onboarding, invoicing)

---

## Pricing & Sales Strategy

- **Tier 1 ($2.5K–$5K)**: Scroll animations, testimonials carousel, basic GSAP
- **Tier 2 ($5K–$8K)**: Advanced GSAP, Spline 3D, full SEO
- **Tier 3 ($10K+)**: AI backend, design system, ongoing support

Sales approach:
- Lead with live demo link (not mockup) — removes all skepticism
- Focus on outcomes: "27% more bookings," "60% faster load," "Mobile now works"
- Use social proof: "3 dentists in Chicago just rebuilt, all seeing 20–50% more inquiries"
- Close with genuine scarcity: "2 spots left this month"

---

## Anti-Slop Design Rules

Never: generic fonts (Inter, Roboto, Arial), purple gradients, uniform rounded corners, center-only layouts.

Always: pick one extreme direction (brutalism, luxury, editorial), distinctive font pairing, 60/30/10 color rule, asymmetric layouts with overlapping elements, staggered reveals, unexpected interactions.

---

## Actual Build Times

- Hero + scroll animations: 2–4 hours
- Full 5-section site: 8–16 hours
- Add Spline 3D: +2–4 hours
- Add backend integration: +4–8 hours
- Vibe design first pass: 2–3 hours
- Cloning system variation: 4–6 hours per client

---

## Success Metrics & Tracking

**Outreach:** 25–35% open rate, 10–15% CTR, 3–5% reply rate
**Sales:** 10% of opens → demo, 50%+ of demos → close
**Revenue:** 85–90% profit margin

Tracking spreadsheet columns: Date | Name | Business | Email | Opened | Clicked | Met | Demo | Closed | Amount | Notes

---

## Getting Started (7-Day Plan)

**Day 1–2:** Read SKILL.md, study EXAMPLES.md, understand Firecrawl + Netlify + GSAP stack

**Day 3–4:** Find 5 targets (start with dentists, 1 city), qualify at 70+ points, reach out

**Day 5–6:** Scrape, build (4 iterations), deploy to Netlify, show live demo

**Day 7:** Handle objections, get 50% deposit, start rebuild #2

**Month 1 goal:** 3–5 rebuilds in pipeline, 1–2 deals closed, $5K–$15K revenue

---

## Tips for $10K Quality

1. Iterate 4x minimum — don't ship first drafts
2. Use real testimonials extracted from Google/Yelp
3. CTAs should be unmissable — 40–50% of hero section
4. Mobile first — 60–70% of prospects browse on phone
5. Video backgrounds beat 3D if the video is better
6. Compress images — TinyPNG + ImageOptim before deploy
7. Test on real phones, not just DevTools
8. Ask about goals — "What does success look like?"
9. 50% deposit upfront before starting
10. Deliver a surprise extra (custom 3D animation, animated logo) — creates WOW

---

## Common Mistakes

- Building to scale too fast — nail 5 rebuilds first
- Using templates — custom = premium = sells
- Underselling — confidence is half the sale
- Skipping mobile testing
- Not tracking metrics
- Overengineering animations — 3–5 per section max
- Ignoring SEO schema + Core Web Vitals
- Cold emailing without warming up the sending domain
- Not handling objections — "too expensive" is predictable
- Giving up after 3 rejections — takes 7–10 touches

---

## Complete Workflow Example (Restaurant)

**Target:** Mama's Italian Kitchen — `https://mamaskitchen.com`, 4.6 stars, 89 reviews, 2005-era design

**Scrape output:** Colors #8B4513/#FFD700/#FFF, copy "Authentic Italian since 1985", services: dine-in/takeout/delivery/private events, 5 Google reviews, broken mobile, 5.2s load time

**Build (4 iterations):**
- Iter 1: Hero with chef video background, GSAP headline animation
- Iter 2: Menu cards animate on scroll, parallax background
- Iter 3: Reviews carousel (Google testimonials), food photo gallery
- Iter 4: 3D pasta model in hero, micro-interactions, Core Web Vitals optimized

**Result:** Live on Netlify → cold email with link → $5K deal closed in 3 days
