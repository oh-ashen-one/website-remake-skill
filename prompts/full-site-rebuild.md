# Full Website Rebuild Prompt (4-Iteration Framework)

## How to Use This

1. **Context**: Gather business info (name, type, colors, copy, current site analysis)
2. **Iteration 1**: Build basic structure (hero, about, services, testimonials, contact)
3. **Iteration 2**: Add animations (GSAP scroll, parallax, hover effects)
4. **Iteration 3**: Polish (carousel, counters, gallery, micro-animations)
5. **Iteration 4**: Premium features (3D, Core Web Vitals, schema markup)

Each iteration is a Claude Code prompt. Copy-paste each into Claude, refine, repeat.

---

## Pre-Build Checklist

Collect this info before starting:

- [ ] Business name
- [ ] Business type (dentist, lawyer, restaurant, realtor, etc.)
- [ ] Website URL (for reference)
- [ ] Brand colors (primary, secondary, accent) — hex codes
- [ ] Logo (URL or description)
- [ ] Headline (e.g., "Family Dentistry Since 2001")
- [ ] Subheadline (e.g., "Trusted by 500+ families")
- [ ] Services (3-5 main services)
- [ ] Testimonials (5-10 customer reviews)
- [ ] Key benefits (what makes them different?)
- [ ] Call-to-action (book appointment, call, contact form)
- [ ] Target audience (e.g., "families, kids")

---

## ITERATION 1: Basic Structure

**Time: 30 minutes | Scope: Layout only**

```
You are a premium web designer building a website for [BUSINESS_NAME], a [BUSINESS_TYPE].

CONTEXT:
- Business: [BUSINESS_NAME]
- Type: [DENTIST/LAWYER/RESTAURANT/REALTOR/SALON/etc]
- Target audience: [DESCRIBE]
- Brand colors: Primary: [HEX], Secondary: [HEX], Accent: [HEX]
- Headline: "[INSERT_HEADLINE]"
- Subheadline: "[INSERT_SUBHEADLINE]"

BUILD A BASIC WEBSITE WITH THESE SECTIONS:

1. HERO SECTION (100vh)
   - Video background or solid color
   - Headline + Subheadline
   - CTA button ("Book Appointment" / "Contact Us" / "Call Now")
   - Center everything, mobile responsive

2. ABOUT SECTION
   - Brief description (2-3 sentences)
   - Years in business, experience, credentials
   - Show trustworthiness

3. SERVICES SECTION (3-4 cards)
   - Service name
   - Brief description
   - Icon or image
   - Grid layout, mobile responsive

4. TESTIMONIALS SECTION
   - Show 3-4 testimonials
   - Each: Quote, author name, title, 5-star rating
   - Simple display (will animate later)

5. CONTACT SECTION
   - Headline: "Get in Touch"
   - Contact form (Name, Email, Message)
   - Phone number + email
   - Address + map (optional)

6. FOOTER
   - Copyright
   - Links to main sections
   - Social media icons (if applicable)

REQUIREMENTS:
- Single HTML file (no build tools)
- Google Fonts (Poppins for headlines, Inter for body)
- Brand colors throughout
- Mobile responsive (375px to 1920px)
- Clean, professional design
- No animations yet (iteration 2)
- CSS included in <style> tag
- JavaScript included in <script> tag

MAKE IT LOOK PROFESSIONAL AND TRUSTWORTHY. This is iteration 1 of 4.
I will refine and add animations next.
```

---

## ITERATION 2: Add Animations & Scroll Effects

**Time: 45 minutes | Scope: Animations + visual effects**

```
Improve this website with animations and scroll effects:

ADD:
1. HEADER/NAVIGATION
   - Sticky navigation bar
   - Fade in on page load
   - Link hover effects (color change, underline animation)

2. HERO ANIMATION
   - Headline: Each word appears with stagger (0.15s delay)
   - Subheadline: Fades in after headline
   - CTA button: Slides up + fades in
   - All with GSAP library (from CDN)

3. SCROLL ANIMATIONS
   - GSAP ScrollTrigger: Sections fade in + slide up as user scrolls
   - Services cards: Stagger in on scroll
   - About section: Text slides in from left, image from right

4. PARALLAX EFFECTS
   - Hero background moves slower than foreground
   - "Depth" effect on scroll

5. BUTTON INTERACTIONS
   - Hover: Scale 1.05, shadow grows
   - Active: Color shift to accent color
   - Smooth transitions (0.3s)

6. HOVER EFFECTS
   - Service cards: Shadow grows, slight scale
   - Testimonial cards: Subtle scale + shadow

REQUIREMENTS:
- Add GSAP from: https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js
- Add ScrollTrigger: https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js
- Keep animations smooth (60fps)
- Mobile-friendly (reduce animation intensity on mobile)
- No performance issues (test in DevTools)

KEEP:
- All previous content + layout
- Brand colors
- Mobile responsiveness

GOAL: Site should feel premium and engaging while scrolling. Every interaction should feel polished.
```

---

## ITERATION 3: Polish + Carousels

**Time: 60 minutes | Scope: Advanced features + interactions**

```
Add advanced features to polish this website:

ADD:
1. TESTIMONIALS CAROUSEL
   - Auto-rotate every 5 seconds
   - Smooth slide transition (0.6s)
   - Show 1 testimonial at a time
   - Left/right arrows (manual control)
   - Dot indicators (which slide is active)
   - On mobile: Stack vertically

2. COUNTER ANIMATIONS
   - "20+ Years Experience" → counts from 0 to 20
   - "500+ Happy Clients" → counts from 0 to 500
   - "$X Million in Sales" (optional)
   - Trigger on scroll to "About" section
   - Duration: 2 seconds

3. HERO SCROLL INDICATOR
   - Small arrow at bottom of hero
   - Bouncing animation
   - Disappears as user scrolls

4. GALLERY (Optional)
   - Grid of 4-6 project/portfolio images
   - Hover: slight zoom (1.05x) + shadow
   - Lightbox on click (optional)

5. MICRO-INTERACTIONS
   - Form inputs: Focus state styling (border color, glow)
   - Links: Underline animation on hover
   - Buttons: Ripple effect on click (optional)
   - Icons: Rotation/bounce on hover

6. LAZY LOADING
   - Images load as they come into view
   - Improves page speed

REQUIREMENTS:
- Keep all previous animations
- Add counter animation library (CountUp.js or use gsap.to())
- Carousel: Custom JS or Swiper.js
- No external UI frameworks (stay vanilla)
- Mobile responsive
- Performance optimized

ANIMATION LIBRARIES:
- GSAP: Already added (use for carousels + counters)
- CountUp.js (optional): https://cdnjs.cloudflare.com/ajax/libs/countup.js/2.6.0/countUp.min.js
- Swiper.js (optional): For carousel

GOAL: Website should feel premium, interactive, and engaging. Every scroll should reveal something new.
```

---

## ITERATION 4: Premium Polish + 3D + Optimization

**Time: 90 minutes | Scope: 3D elements + performance + SEO**

```
Final premium polish with 3D elements and optimization:

ADD (OPTIONAL - only if budget allows):
1. THREE.JS 3D ELEMENT
   - Location: Hero section background
   - Element: Floating geometric shapes (cube, sphere, torus)
   - Animation: Subtle rotation + floating motion
   - Colors: From brand palette
   - Performance: Optimized (low poly, GPU accelerated)
   - Fallback: Static image if WebGL unavailable

   Library: https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js

2. ADVANCED MICRO-ANIMATIONS
   - Logo: Subtle scale pulse on page load
   - Section headlines: Letter-by-letter reveal (optional)
   - Form submission: Success animation (checkmark, color change)
   - Error states: Shake animation on form error

3. DARK MODE (Optional)
   - Toggle switch in header
   - Dark color scheme
   - Smooth transition between modes
   - Persist user preference (localStorage)

OPTIMIZATION:
1. CORE WEB VITALS
   - LCP < 2.5s (Largest Contentful Paint)
   - CLS < 0.1 (Cumulative Layout Shift)
   - FID < 100ms (First Input Delay)
   - Test in: Chrome DevTools Lighthouse

2. IMAGE OPTIMIZATION
   - All images < 100KB
   - Use next-gen formats (WebP with fallback)
   - Lazy load below-fold images
   - Responsive images (srcset for different sizes)

3. CODE OPTIMIZATION
   - Minify CSS/JS (or use CDN minified)
   - Remove unused CSS
   - Defer non-critical JS
   - Compress assets

4. SEO & SCHEMA MARKUP
   - Add JSON-LD schema:
     - LocalBusiness (name, address, phone, image, rating)
     - Service (name, description, provider)
     - Review (rating, reviewRating, author)
   - Meta tags:
     - Title (50-60 chars, include business name)
     - Description (120-160 chars, include key benefit)
     - OG tags (for social sharing)
   - Structured data validation: https://validator.schema.org/

5. ACCESSIBILITY
   - Alt text on all images
   - Proper heading hierarchy (h1, h2, h3)
   - Color contrast: WCAG AA minimum (4.5:1)
   - Keyboard navigation: Tab through elements
   - Focus states visible
   - Form labels + aria-labels where needed

REQUIREMENTS:
- All previous features working
- No console errors
- Test in: Chrome, Safari, Firefox, Edge
- Mobile test: iPhone 12, iPhone SE, Android Samsung
- Lighthouse score: 90+
- No broken images or 404s

OPTIONAL BUT IMPRESSIVE:
- Smooth page transitions (fade in/out)
- Custom cursor (optional)
- Parallax depth map (advanced)
- WebGL background animation
- Progressive Web App (PWA) features

GOAL: Production-ready website, $10K quality, zero technical debt.

Final checklist:
- [ ] No console errors
- [ ] All animations smooth (60fps)
- [ ] Images optimized
- [ ] Mobile responsive
- [ ] Core Web Vitals > 90
- [ ] Schema markup validated
- [ ] All links working
- [ ] Contact form working (or link to email)
```

---

## POST-BUILD CHECKLIST

Before deploying:

```
FUNCTIONALITY
- [ ] All pages load
- [ ] Navigation links work
- [ ] Contact form works (or email link works)
- [ ] Video/animations play
- [ ] Responsive on mobile (375px)
- [ ] Responsive on tablet (768px)
- [ ] Responsive on desktop (1920px)

PERFORMANCE
- [ ] Lighthouse score 90+
- [ ] LCP < 2.5s
- [ ] CLS < 0.1
- [ ] No console errors
- [ ] Images optimized

DESIGN
- [ ] Colors match brand
- [ ] Typography clean and readable
- [ ] Spacing consistent
- [ ] No broken layouts
- [ ] Mobile buttons are touchable (48px+)

SEO
- [ ] Meta title + description
- [ ] JSON-LD schema markup
- [ ] Images have alt text
- [ ] Heading hierarchy correct (h1, h2, h3)

TESTING
- [ ] Test on iPhone (Safari)
- [ ] Test on Android (Chrome)
- [ ] Test on desktop browsers (Chrome, Safari, Firefox)
- [ ] Test form submissions
- [ ] Check all links
```

---

## Quick Reference: Iteration Timeline

| Iteration | Time | Focus | Output |
|-----------|------|-------|--------|
| 1 | 30 min | Structure | 6 sections, layout only |
| 2 | 45 min | Animations | GSAP scroll, parallax, hover |
| 3 | 60 min | Polish | Carousel, counters, gallery |
| 4 | 90 min | Premium | 3D, optimization, SEO |
| **Total** | **4-5 hrs** | **Full rebuild** | **Production-ready $10K site** |

---

## Pro Tips

1. **Show iteration progress** → After each iteration, take a screenshot and share with client for feedback
2. **Mobile first** → Build on mobile, then enhance on desktop
3. **Test animations** → Make sure 60fps on mobile (use Chrome DevTools)
4. **Keep copy brief** → More white space = more premium
5. **CTA placement** → Hero CTA should be above the fold on all devices
6. **Color usage** → Use accent color strategically (3-5% of page)
7. **Typography contrast** → Ensure headline/body have clear hierarchy

---

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| **Animations lag on mobile** | Reduce animation complexity, disable on slow devices |
| **Images not loading** | Check URLs, compress images, use CDN |
| **Form not working** | Use Formspree, Netlify Forms, or Vercel edge functions |
| **Mobile layout broken** | Use flexbox/grid, test at 375px, fix overflow |
| **Slow lighthouse score** | Optimize images, minify CSS/JS, defer non-critical code |
| **Schema validation errors** | Use JSON-LD validator, check format |

---

## Ready to Build?

1. Collect all context (business info, colors, copy)
2. Copy Iteration 1 prompt into Claude Code
3. Generate, refine, iterate
4. Move to Iteration 2 when happy with layout
5. Continue through Iteration 4
6. Deploy to Vercel/Netlify
7. Send cold email with live link

**Time investment: 4-5 hours per site**
**Revenue per site: $5,000-$10,000**
**Profit: ~90%**

Let's build.
