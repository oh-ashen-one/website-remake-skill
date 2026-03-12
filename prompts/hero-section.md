# Premium Hero Section Prompt

## For Claude Code / Claude Artifacts

Use this exact prompt to generate a premium hero section in Claude Code.

---

## Basic Version (Start Here)

```
You are a premium web designer. Build a luxury website hero for [BUSINESS_NAME] ([BUSINESS_TYPE]).

Requirements:
- Full screen (100vh height)
- Video background OR 3D animated background
- Brand colors: [COLOR_PALETTE]
- Modern typography (Poppins or Inter from Google Fonts)
- Animated headline (words appear one-by-one)
- Subheadline
- CTA button with glow effect on hover
- Parallax effect on background
- Mobile responsive (375px to 1920px)
- No build tools (pure HTML/CSS/JS)

Headline: "[INSERT_HEADLINE]"
Subheadline: "[INSERT_SUBHEADLINE]"
CTA Button: "[INSERT_CTA_TEXT]"

Make this stunning, modern, and premium. Every pixel matters.
This is for a sales pitch—it needs to wow within 3 seconds.
```

---

## Advanced Version (Iteration 2)

```
Improve the hero section:

1. Add GSAP library (include from cdnjs)
2. Split headline into words, animate each with 0.3s stagger
3. Subheadline fades in after headline completes
4. CTA button:
   - Appears after headline
   - Glows on load (box-shadow animation)
   - Scales 1.05 on hover
   - Color shift on hover (primary → brighter)
5. Background parallax:
   - Background moves at 0.5x scroll speed
   - Creates depth effect
6. Add scroll indicator:
   - Small arrow at bottom of hero
   - Bouncing animation
   - Fades out as user scrolls down

Make it seamless and professional. No jank, 60fps minimum.
```

---

## Video Background Version

```
Create a premium hero with video background:

1. Hero: Full screen, video background
2. Video: [DESCRIBE_VIDEO] (e.g., "dental chair spinning smoothly", "cooking food in motion", "office building with people working")
3. Video source: Use a free stock video (pexels, unsplash video, or pixabay)
4. Fallback: Static image if video doesn't load
5. Headline: Animated word-by-word reveal over video
6. Overlay: Semi-transparent dark overlay (opacity 0.3-0.5) to ensure text readability
7. CTA: Large, prominent button with glow effect
8. Parallax: Video moves slightly slower than scroll

Video recommendations:
- Duration: 8-15 seconds (loops)
- Size: < 5MB (optimized)
- Aspect ratio: 16:9
- Style: Professional, relevant to business

Sources:
- Pexels Videos: https://www.pexels.com/videos/
- Pixabay Videos: https://pixabay.com/videos/
- Unsplash: https://unsplash.com/
```

---

## 3D WebGL Version (Premium)

```
Create hero with 3D WebGL background (Three.js):

1. Canvas background: Full screen Three.js scene
2. 3D elements: Floating geometric shapes
   - Rotating cube, sphere, or custom mesh
   - Subtle animation loop
   - Colors from brand palette
3. Lighting: Nice shadows and depth
4. Performance: Optimized (GPU accelerated, < 30MB bundle)
5. Fallback: Static image if WebGL unavailable
6. Headline: Animated over 3D background
7. CTA: Clear, readable, prominent
8. Mobile: Reduce geometry complexity on mobile for performance

Example 3D concepts:
- Dental office: Floating teeth rotating
- Law firm: Scales of justice rotating
- Restaurant: Rotating food shapes
- Real estate: Rotating house model
- Salon: Floating styling product shapes

Performance targets:
- FPS: 60 on desktop, 30+ on mobile
- Bundle size: < 200KB (Three.js CDN)
- Load time: < 2.5 seconds LCP
```

---

## Mobile Optimization

```
Ensure hero is mobile-perfect:

1. Headline size:
   - Desktop: 48-72px
   - Tablet: 36-48px
   - Mobile: 28-36px
2. Subheadline:
   - Keep short (2-3 lines max)
   - Same responsive sizing
3. CTA button:
   - Touch target: 48x48px minimum
   - Padding: Generous on mobile
4. Video/animation:
   - Disable on very slow connections
   - Use static image fallback
5. Layout:
   - Center everything
   - No horizontal scroll
   - Safe area padding (notches, etc.)
```

---

## Color & Typography

### Typography
```css
/* Google Fonts imports */
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap');

/* Usage */
.headline {
  font-family: 'Poppins', sans-serif;
  font-weight: 700;
  font-size: clamp(28px, 6vw, 72px);
  line-height: 1.1;
}

.subheadline {
  font-family: 'Inter', sans-serif;
  font-weight: 300;
  font-size: clamp(16px, 2vw, 20px);
  line-height: 1.5;
}
```

### Brand Colors
- Primary: [HEX_COLOR] (main brand color)
- Secondary: [HEX_COLOR] (accent)
- Accent: [HEX_COLOR] (highlights)
- Text: #ffffff or #000000 (depending on background)

---

## Animations (GSAP Examples)

```javascript
// Headline word-by-word reveal
gsap.to(".headline-word", {
  duration: 0.8,
  opacity: 1,
  y: 0,
  stagger: 0.15,
  delay: 0.3
});

// CTA button glow
gsap.to(".cta-button", {
  duration: 2,
  boxShadow: "0 0 30px rgba(255, 255, 255, 0.8)",
  repeat: -1,
  yoyo: true
});

// Parallax background
gsap.registerPlugin(ScrollTrigger);
gsap.to(".hero-bg", {
  scrollTrigger: ".hero",
  y: -50,
  duration: 1
});
```

---

## Testing Checklist

Before sending to client:

- [ ] Loads in < 2.5 seconds (LCP)
- [ ] Headline is readable (high contrast)
- [ ] CTA button is obvious and clickable
- [ ] Animations smooth (60fps, no stutter)
- [ ] Mobile responsive (test 375px, 768px, 1920px)
- [ ] Video/3D loads correctly
- [ ] Fallback image shows if media fails
- [ ] No console errors
- [ ] Works in: Chrome, Safari, Firefox, Edge

---

## Common Mistakes (Avoid!)

❌ Too many animations (overwhelming)
❌ Text too small on mobile
❌ CTA button buried (not above fold)
❌ Video doesn't loop properly
❌ Animation doesn't start immediately
❌ Parallax too aggressive (disorienting)
❌ No mobile fallback
❌ Images not optimized (> 200KB each)

---

## Quick Win: Implement This Now

1. Copy this prompt into Claude Code
2. Replace [PLACEHOLDERS] with real data
3. Generate artifact
4. Test on mobile (Chrome DevTools)
5. Iterate if needed
6. Deploy to Netlify

**Time: 15 minutes for hero, 2-3 hours for full site**
