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

