# awwwards-design skill — key techniques extracted

## Animation stack
- GSAP + ScrollTrigger (scroll-triggered reveals, scrubbed animations, parallax)
- Lenis or GSAP ScrollSmoother for smooth scrolling
- SplitType + GSAP for text splitting animations (char-by-char, word stagger)
- Framer Motion + useScroll for React
- Barba.js for page transitions

## Must-have patterns for $10K sites
- Scroll-triggered reveals with staggered timing (start: "top 80%")
- Scrubbed parallax (scrub: true in ScrollTrigger)
- Pinned sections while content scrolls through
- Magnetic buttons (cursor pull effect)
- Custom cursor with context-awareness
- Page transitions (overlay sweep or zoom)
- Text splitting animations on hero title
- Horizontal scroll sections

## Visual techniques
- Mesh gradients (multi-point radial gradients)
- Animated gradient backgrounds (background-size: 400% 400%)
- Grain/noise overlay (SVG filter, opacity 0.03)
- Glassmorphism (backdrop-filter: blur)
- Layered soft shadows for depth
- Clip-path for diagonal sections
- Asymmetric layouts, overlapping elements

## Typography for impact
- Display fonts: Neue Machina, Monument Extended, PP Mori, Clash Display, Satoshi
- Hero text: 15-25vw
- Variable fonts that animate weight/width

## 3D/WebGL
- Three.js / React Three Fiber
- Spline (no-code 3D)
- Particle systems responding to scroll/mouse
- Shader effects (distortion, ripple)

## Performance targets
- FCP < 1.5s, LCP < 2.5s, 60fps animations
- `will-change` sparingly, `requestAnimationFrame` for JS animations
- `prefers-reduced-motion` support mandatory

## Easing cheat sheet
- power3.out — natural deceleration (most used)
- back.out(1.7) — slight overshoot/settle (playful)
- elastic.out(1, 0.3) — bouncy
- expo.out — dramatic fast-start slow-end
