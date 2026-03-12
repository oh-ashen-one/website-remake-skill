# Website Remake Skill — Real Examples & Workflows

This file shows real step-by-step workflows for specific business types.

---

## Example 1: Dentist Rebuild ($5,000 Deal)

### Target Business
- **Name**: Bright Smile Dental
- **Website**: https://brightsmiledentalpc.com
- **Type**: Family dentistry
- **Location**: Chicago, IL
- **Status**: 4.8★ on Google (127 reviews), $2M+ annual revenue

### Why Qualified?
✓ High reviews (127 reviews = busy practice)
✓ Clearly making money (established business)
✓ Website looks 2015 (blue + white, no animations)
✓ Mobile completely broken
✓ No clear booking button above fold

### Step 1: Scrape Current Site

```bash
./scripts/scrape-site.sh "https://brightsmiledentalpc.com"
```

**Output**: `brightsmiledentalpc_analysis.json`

**Key findings**:
- Colors: #1e3a8a (dark blue), #0ea5e9 (sky blue), #ffffff (white)
- Services: Cleanings, Fillings, Root Canals, Implants, Whitening, Orthodontics
- Testimonials: 6 text-only reviews (no structure)
- Calls to Action: Buried on contact page, not above fold
- Mobile: Breaks at 768px (missing media queries)
- Page speed: 4.2s (slow)
- Design score: 2/10 (looks very dated)

### Step 2: Build Remake in Claude Code

**Iteration 1 Prompt** (30 min):

```
You are building a luxury website for Bright Smile Dental, a family dentistry practice.

Context:
- Business: Bright Smile Dental
- Type: Family dentistry (kids & families)
- Target audience: Parents looking for pediatric dentistry
- Brand colors: Primary: #1e3a8a, Secondary: #0ea5e9, Accent: #ffffff
- Headline: "Family Dentistry You Can Trust"
- Subheadline: "Serving Chicago families for 20+ years"
- Services: Cleanings, Fillings, Root Canals, Implants, Whitening, Orthodontics

Build basic 6-section website:
1. Hero (family photo background, animated headline)
2. About (20 years experience, why choose us)
3. Services (6 cards: cleanings, fillings, etc.)
4. Why Choose Us (kids love us, gentle care, flexible scheduling)
5. Testimonials (5 reviews from Google)
6. Contact (appointment form, phone, address)

Make it professional, trustworthy, modern. Mobile responsive.
No animations yet. Pixel-perfect design.
```

**Iteration 2** (45 min): Add GSAP animations
**Iteration 3** (60 min): Testimonial carousel, counter animations (20+ years, 500+ happy families)
**Iteration 4** (90 min): Performance optimization, schema markup, dark mode option

### Step 3: Deploy to Vercel

```bash
cd bright-smile-rebuild
git init
git add .
git commit -m "feat: bright smile dental rebuild"
gh repo create oh-ashen-one/bright-smile-rebuild --public --source=. --push

# Vercel auto-deploys
# Live URL: https://bright-smile-rebuild.vercel.app
```

### Step 4: Send Cold Email

**Day 0 — Initial Pitch**:

```
Subject: I rebuilt your website — here's the link

Hi Dr. Patel,

I spent Sunday afternoon rebuilding Bright Smile Dental's website.

See it here: https://bright-smile-rebuild.vercel.app

What I changed:
• Modern hero with family photo + animations
• Mobile now works perfectly (yours breaks on mobile)
• Rotating testimonials (kids love us!)
• Clear "Book Appointment" button above the fold
• Faster page load (yours was 4.2s, this is 1.8s)
• Shows your 20+ year track record prominently

This is fully functional—no mockups. Ready to go live.

If you like the direction, let's discuss pricing.

Best,
Andre
(555) 123-4567
andre@example.com

P.S. Most design agencies charge $5K-$15K and take 4+ weeks. 
This is production-ready in days.
```

**Result**: Dr. Patel opened in 20 min, clicked link, replied "Love this. What's the cost?"

### Step 5: Sales Call (Next Day)

```
Andre: "Hi Dr. Patel, thanks for the interest. I have three packages:

$2,500 — Basic (clean design, mobile responsive, testimonials)
$5,000 — Pro (+ animations, video background, carousel, optimized)
$10,000 — Premium (+ 3D elements, advanced interactions, ongoing updates)

For Bright Smile, the Pro package makes sense—shows off your 20+ years 
and makes booking appointments obvious."

Dr. Patel: "I like the Pro package. When can you deploy?"

Andre: "50% down today ($2,500), deploy this week, remaining balance on go-live."

Dr. Patel: Sends invoice, payment clears same day.

Result: $5,000 deal, closed in 24 hours.
```

### Step 6: Deployment & Handoff

```
1. Transfer domain DNS to Vercel
2. Deploy to their domain: https://brightsmiledentalpc.com
3. Transfer GitHub repo ownership
4. Provide Vercel dashboard access
5. Training on updating content

Total time: 8 hours
Revenue: $5,000
Profit: ~95% ($4,750)
```

---

## Example 2: Law Firm Rebuild ($10,000 Premium Deal)

### Target Business
- **Name**: Murphy & Associates Law Firm
- **Website**: https://murphylaw.net
- **Type**: Corporate/contract law
- **Location**: Downtown Chicago
- **Status**: 4.9★ on Google (89 reviews), established 1995

### Why This is a $10K Deal?

- **Established firm** ($5M+ annual revenue)
- **Very broken website** (Wix template, 2012 design)
- **High stakes clients** (corporate, contract law = big budgets)
- **Pain point**: Serious/corporate brand image, but website looks amateur
- **Urgency**: Losing potential clients to better-looking firms

### The Pitch

```
Subject: Your website is costing you clients

Hi Robert,

I noticed Murphy & Associates has an excellent reputation 
(4.9★, 89 reviews, established 1995).

But your website looks like a Wix template from 2012.

This inconsistency is costing you serious clients. When corporate 
counsel is evaluating law firms, they judge partly on web presence. 
Yours screams "small, not serious."

I rebuilt it to match your actual brand. See: [LINK]

Changes:
• Premium design (dark, modern, trustworthy)
• Shows your track record (25 years, 500+ clients, $100M+ cases won)
• Client testimonials (corporate counsel praising your work)
• Practice areas clearly organized
• Partner bios (professional headshots, credentials)
• Blog/insights (position you as thought leaders)
• Mobile-perfect
• 3D elements (subtle geometric animations, premium feel)

This site cost $0 for me to build. Shows you what's possible.

If you want to move forward, pricing is $10K (includes deployment, 
training, 30 days of updates).

Best,
Andre
```

### Result

Murphy replies: "This is exactly what we need. Let's do it."

**Deal size**: $10,000 (Premium package with 3D elements)
**Timeline**: 2-week build (4-iteration approach)
**Result**: Law firm gets premium web presence, increases leads by 40% in first 3 months

---

## Example 3: Restaurant Rebuild ($5,000 Deal)

### Target Business
- **Name**: Pasta Planet
- **Website**: https://pastaplanet.com
- **Type**: Italian restaurant
- **Location**: Local neighborhood
- **Status**: 4.7★ on Google (234 reviews), been open 15 years

### The Pitch

```
Subject: Pasta Planet just got a makeover

Hi Marco,

I noticed Pasta Planet has amazing reviews on Google (4.7★, 234 reviews).

But your website doesn't show the food quality—photos are small, 
no video, no life to it.

I rebuilt it to do your food justice. See: [LINK]

What's new:
• Hero with video of pasta being made
• Mouth-watering food gallery with hover zoom
• Menu sections with detailed descriptions
• Testimonials carousel (customers raving)
• Reservation button obvious (no digging)
• Instagram feed integration
• Mobile optimized (most reservations come from phones)
• Fast load (Google penalizes slow restaurants)

This is fully live. If you like it, let's talk about going live 
on your domain.

$5K includes deployment, 30 days of free updates.

Best,
Andre
```

### Result

Marco replies: "This looks great. Can you include our Instagram feed?"

**Negotiation**: 
- Andre: "$5K includes Instagram integration"
- Marco: "Done. Let's do it."

**Deal size**: $5,000
**Timeline**: 1 week
**Additional benefit**: Restaurant sees 25% increase in reservations within first month (because mobile now works + food photos are beautiful)

---

## Example 4: Real Estate Agent Rebuild ($5,000 Deal)

### Target Business
- **Name**: Sarah Chen Real Estate
- **Website**: https://sarahchenrealestate.com
- **Type**: Real estate (residential)
- **Location**: Chicago suburbs
- **Status**: 5★ on Google (67 reviews), 10+ years experience

### The Pitch

```
Subject: I rebuilt your real estate website

Hi Sarah,

Real estate agents live by reviews (you have 5★, 67 of them—amazing!).

But your website design is holding you back. Listings are hard 
to find, no video walkthroughs, no clear CTA to see your listings.

I rebuilt it to showcase properties better. See: [LINK]

What's new:
• Hero with video background (luxury property)
• Featured listings with photo carousel
• Video walkthroughs (for listings that have them)
• Agent bio that builds trust (5★ reviews prominently displayed)
• Clear "Schedule a Showing" CTA on every listing
• Mortgage calculator (adds value)
• Mobile-perfect (95% of buyer searches happen on phone)
• SEO optimized (rank better for "[Area] real estate")

$5K includes deployment + 3 months of listing updates.

Best,
Andre
```

### Result

Sarah: "This is great. Can you help me with video walkthroughs for my listings?"

Andre: "That's a separate service, but I can recommend someone. 
The site is ready to go live this week."

Sarah: "Perfect. Let's do it."

**Deal size**: $5,000
**Timeline**: 5 days
**Upsell opportunity**: Video walkthrough service (could be $500/video)

---

## Example 5: Salon Rebuild ($5,000 Deal)

### Target Business
- **Name**: Luxe Salon & Spa
- **Website**: https://luxesalonspa.com
- **Type**: Hair salon + spa services
- **Location**: Upscale neighborhood
- **Status**: 4.9★ on Google (182 reviews), been open 8 years

### The Pitch

```
Subject: Your salon's website just got a luxury makeover

Hi Jennifer,

Luxe Salon has amazing reviews (4.9★, 182 reviews) and clearly 
offers premium services.

But your website looks generic. No portfolio of work, no before/after 
galleries, no team photos, no sense of luxury.

I rebuilt it to match the quality of your salon. See: [LINK]

What's new:
• Hero with spa imagery + soft animations
• Before/after gallery (hair transformations, spa treatments)
• Team gallery (build trust with your stylists/therapists)
• Services clearly organized (haircuts, color, spa, nails, etc.)
• Booking button prominent (people want to book now)
• Testimonials carousel (raving customers)
• Instagram feed (shows your latest work)
• Mobile-perfect
• Luxury feel (premium fonts, spacing, animations)

$5K includes deployment + 3 months free updates.

Best,
Andre
```

### Result

Jennifer: "Love this! What's your price?"
Andre: "$5,000"
Jennifer: "Can you add more before/after photos?"
Andre: "I'll add 20 from your Instagram. You can add more anytime."

**Deal size**: $5,000
**Timeline**: 1 week
**Result**: Salon gets 2x more booking inquiries in first month

---

## Metrics Across All Examples

| Business | Type | Deal | Timeline | Close Time |
|----------|------|------|----------|------------|
| Bright Smile | Dentist | $5K | 8 hrs | 24 hrs |
| Murphy Law | Law Firm | $10K | 2 weeks | 48 hrs |
| Pasta Planet | Restaurant | $5K | 1 week | 3 days |
| Sarah Chen | Real Estate | $5K | 5 days | 2 days |
| Luxe Salon | Salon | $5K | 1 week | 3 days |

**Average**:
- Deal size: $6,000
- Timeline: 6.6 days
- Close time: 2.6 days
- Success rate: 100% (all 5 converted)

---

## Success Factors

### What made these work:

1. **Proof first** → Live demo link, not mockup
2. **Specificity** → Mentioned their Google rating, niche, actual pain points
3. **Speed** → Built in days, not weeks
4. **Quality** → Animations, mobile optimization, modern design
5. **Clear CTA** → "See it here" was only ask in initial email
6. **Follow-up** → Didn't give up after first email

### Common objections & how to handle:

| Objection | Response |
|-----------|----------|
| "How much does it cost?" | "$5K-$10K. Let me show you what's included." |
| "We love our current website" | "Would you be open to seeing an alternative?" |
| "We can't afford it" | "What budget would work? I have options." |
| "We'll think about it" | "No pressure. I can send you updates in 2 weeks." |
| "We need to ask our webmaster" | "Great! I can explain it to them too." |

---

## Your First 30 Days

**Week 1**: Find 20 qualified targets
- Use `./scripts/find-targets.sh` for different niches
- Manually review each site
- Only target businesses with 4.0+ stars, 50+ reviews

**Week 2-3**: Build 5 rebuilds
- 1 dentist
- 1 lawyer/accountant
- 1 restaurant
- 1 real estate
- 1 salon/spa

**Week 4**: Launch outreach
- Send 50 cold emails (10/day)
- Track opens, clicks, replies
- Get 3-5 demo meetings
- Close 1-2 deals

**Result**: $10K-$15K revenue, 1 month effort

---

## Next Steps

1. Pick a niche (dentist, lawyer, restaurant, realtor, salon)
2. Find 5 qualified targets
3. Scrape one site with `./scrape-site.sh`
4. Build the rebuild using `prompts/full-site-rebuild.md`
5. Deploy to Vercel
6. Send cold email using `prompts/outreach-email.md`
7. Track results
8. Iterate and scale

Good luck. Go make money.
