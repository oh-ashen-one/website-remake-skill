# Website Remake Skill — Build $10K Websites & Sell Them

**Convert outdated business websites into modern, animated, high-converting sites — then sell them back at $5K-$10K per deal.**

## Quick Start (5 Min)

### 1. Install Dependencies
```bash
# Firecrawl CLI (for website scraping)
npm install -g firecrawl-cli
firecrawl login --api-key YOUR_API_KEY

# Verify
firecrawl --status
```

### 2. Set Up Environment
```bash
# Create .env file
export AGENTMAIL_API_KEY=your_key_here
export NETLIFY_TOKEN=your_token_here
```

### 3. Find a Target Business
```bash
# Open SKILL.md, section "Step 1: Finding Targets"
# Search for a local business with a poor website
# Example: dentist, law firm, restaurant, realtor

# Use web_search in Claude Code:
# "Find 10 dentists in Chicago with outdated websites"
```

### 4. Scrape Their Current Site
```bash
cd scripts/
./scrape-site.sh "https://example-dentist.com"
# Outputs: example-dentist_analysis.json
```

### 5. Build the Remake in Claude Code
```
Go to https://claude.com → Claude Code

Paste this:
"Rebuild https://example-dentist.com into a luxury website.

Analysis: 
[PASTE OUTPUT FROM scrape-site.sh]

Make it:
- Hero with video background
- GSAP scroll animations
- Testimonial carousel
- Services cards with hover effects
- Mobile-responsive
- Premium quality ($10K level)

Build iteration 1 (hero only). Make it stunning."
```

### 6. Deploy Live
```bash
# Create GitHub repo
gh repo create oh-ashen-one/example-dentist-rebuild --public

# Copy HTML from Claude Code artifacts
# Push to GitHub
git push origin main

# Connect to Netlify
# Get live URL: https://example-dentist-rebuild.netlify.app
```

### 7. Send Cold Email
```bash
./send-email.sh \
  --to owner@example-dentist.com \
  --subject "I rebuilt your website" \
  --url https://example-dentist-rebuild.netlify.app
```

### 8. Close the Deal
- Follow up after 3 days
- Offer: $5K (basic) → $10K (full premium with 3D)
- Get 50% deposit upfront
- Deploy on their domain
- Done.

---

## Pipeline Overview

```
Find Target
    ↓
Scrape Site (Firecrawl)
    ↓
Analyze + Extract Colors/Copy
    ↓
Build Remake (Claude Code, 4 iterations)
    ↓
Deploy to Netlify
    ↓
Send Cold Email
    ↓
Follow-Up Sequence (3 emails, 7 days)
    ↓
Close Deal + Payment
```

---

## Business Model

### Pricing
- **$2,500**: Basic (clean design, responsive)
- **$5,000**: Pro (+ animations, carousel, video)
- **$10,000**: Premium (+ 3D, micro-interactions, optimization)

### Unit Economics
- **Time per rebuild**: 4-8 hours (Claude Code handles most)
- **Cost**: $0 (Netlify free, Firecrawl API cheap)
- **Profit**: 85-95%

### Revenue Potential
- **100 cold emails** → 30 opens → 3 calls → 1-2 closes
- **Per deal**: $5,000-$10,000
- **Monthly**: 2-3 deals = $10K-$30K

---

## What Makes This Work

1. **Real Problem**: 60%+ of small businesses have terrible websites
2. **Proof**: Live demo link in the email (no mockups)
3. **Urgency**: They lose leads every day to better competitors
4. **Quality**: GSAP + Three.js + video = agency-level results
5. **Speed**: You deliver in days, not weeks

---

## File Structure

```
website-remake-skill/
├── SKILL.md                          # Full skill documentation
├── README.md                         # This file
├── scripts/
│   ├── find-targets.sh              # Search for businesses
│   ├── scrape-site.sh               # Analyze site with Firecrawl
│   ├── build-site.sh                # Trigger Claude Code build
│   └── send-email.sh                # Send via AgentMail
├── prompts/
│   ├── hero-section.md              # Hero animation prompt
│   ├── full-site-rebuild.md         # 4-iteration framework
│   └── outreach-email.md            # Email templates
└── examples/
    ├── bright-smile-dentist/        # Example rebuild
    ├── murphy-law-firm/             # Example rebuild
    └── pasta-planet-restaurant/     # Example rebuild
```

---

## Key Prompts

### Hero Section (Iteration 1)
See `prompts/hero-section.md`

**Quick version:**
```
Build a luxury hero for a [BUSINESS_TYPE].
- Full-screen video background
- Animated headline (staggered word reveal)
- CTA button with glow effect
- Parallax on scroll
- Colors: [PASTE_BRAND_COLORS]
- Mobile responsive
```

### Full Rebuild (4 Iterations)
See `prompts/full-site-rebuild.md`

```
Iteration 1: Basic structure (hero, about, services, testimonials, contact)
Iteration 2: Add GSAP animations (scroll triggers, parallax)
Iteration 3: Testimonial carousel, counter animations
Iteration 4: Three.js 3D, Core Web Vitals optimization
```

### Cold Email
See `prompts/outreach-email.md`

```
Subject: I rebuilt your website — here's the link

Hi [NAME],

I spent 2 hours rebuilding your website. See it here:
[LIVE_DEMO_URL]

What I changed:
- Modern hero with video/3D animation
- Smooth scroll effects
- Mobile-optimized (yours doesn't work on mobile)
- Testimonials carousel
- Clear booking/call CTAs

If you like it, let's discuss pricing.

Talk soon,
[Your Name]
```

---

## API Setup

### Firecrawl (Required)
```bash
npm install -g firecrawl-cli
firecrawl login --api-key YOUR_API_KEY
# Get key at: https://firecrawl.dev/app/api-keys
```

### Netlify (Recommended)
```bash
npm install -g netlify-cli
netlify login
# Connect your GitHub account via Netlify dashboard
```

### AgentMail (For Cold Emails)
```bash
export AGENTMAIL_API_KEY=your_key_here
# Get key at: https://agentmail.to
```

### Gemini (Optional, for hero images)
```bash
export GEMINI_API_KEY=your_key_here
# For generating hero visuals
```

---

## Performance Checklist

Before you send a cold email, verify:

- [ ] Hero loads in < 2 seconds
- [ ] Mobile responsive (test on iPhone + Android)
- [ ] All animations smooth (60fps, no lag)
- [ ] CTAs are clear and clickable
- [ ] Contact form works
- [ ] No console errors
- [ ] Images optimized (< 100KB each)
- [ ] Schema markup correct (LocalBusiness)
- [ ] Dark mode (optional but premium feature)

---

## Troubleshooting

**"Firecrawl scrape failed"**
- Check API key: `firecrawl --status`
- Verify internet connection
- Try different URL format

**"Claude Code artifact won't save"**
- Use single HTML file (no build step)
- Verify all imports from CDN (GSAP, Three.js)
- Test in browser DevTools console

**"Deploy to Netlify failed"**
- Check GitHub repo is public/private correctly
- Verify Netlify has repo access
- Re-authenticate: `netlify login`

**"Cold email not converting"**
- Improve subject line (A/B test)
- Make demo link more prominent
- Add social proof (testimonial from previous client)
- Follow up more aggressively (day 3, day 7)

---

## Success Stories

Want to see real examples? Check `examples/` folder:
- Bright Smile Dental ($5K deal, closed in 5 days)
- Murphy Law Firm ($10K deal, premium 3D package)
- Pasta Planet Restaurant ($5K deal, video background)

---

## Next Steps

1. **Read SKILL.md** → Full documentation with all details
2. **Set up APIs** → Firecrawl, Netlify, AgentMail
3. **Test on 1 business** → Run full pipeline end-to-end
4. **Refine prompts** → Customize for your niche
5. **Start cold emailing** → 5 businesses/week minimum
6. **Track metrics** → Conversion, meetings, deals closed
7. **Scale up** → Once you hit consistent closes

---

## Support

For issues or improvements:
- Open issue on GitHub: https://github.com/oh-ashen-one/website-remake-skill
- Check SKILL.md "Troubleshooting" section
- Review `prompts/` for exact prompt examples

---

**Remember**: This works because you're solving a real problem, showing proof (live demo), and moving fast. Most design agencies take 2-3 weeks. You deliver in 2-3 days.

Go build something.
