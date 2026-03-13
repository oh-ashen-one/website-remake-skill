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
