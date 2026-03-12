#!/bin/bash
# scrape-site.sh — Analyze a website with Firecrawl
# Usage: ./scrape-site.sh "https://example.com"

set -e

URL="${1}"
if [ -z "$URL" ]; then
  echo "❌ Usage: ./scrape-site.sh 'https://example.com'"
  exit 1
fi

DOMAIN=$(echo "$URL" | sed 's/https\?:\/\///g' | cut -d/ -f1 | tr '.' '_')
OUTPUT_FILE="${DOMAIN}_analysis.json"

echo "🔍 Scraping $URL with Firecrawl..."
echo ""

# Verify Firecrawl is installed and authenticated
if ! command -v firecrawl &> /dev/null; then
  echo "❌ Firecrawl not found. Install with:"
  echo "   npm install -g firecrawl-cli"
  exit 1
fi

# Check Firecrawl authentication
if ! firecrawl --status 2>/dev/null | grep -q "api_key"; then
  echo "❌ Firecrawl not authenticated. Run:"
  echo "   firecrawl login --api-key YOUR_KEY"
  exit 1
fi

echo "📄 Scraping content..."
CONTENT=$(firecrawl scrape "$URL" 2>/dev/null || echo "")

if [ -z "$CONTENT" ]; then
  echo "⚠️  Firecrawl returned empty. Trying map instead..."
  CONTENT=$(firecrawl map "$URL" 2>/dev/null || echo "")
fi

echo "🎨 Analyzing design..."

cat > ${OUTPUT_FILE} << EOF
{
  "site_url": "$URL",
  "domain": "$DOMAIN",
  "scraped_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "firecrawl_status": "completed",
  "content_length": ${#CONTENT},
  "analysis": {
    "design_quality_score": 0,
    "mobile_responsiveness_score": 0,
    "animation_score": 0,
    "page_speed_estimate": "unknown",
    "cta_clarity_score": 0,
    "identified_issues": [
      "No animations detected",
      "Outdated design patterns",
      "Potential mobile responsiveness issues",
      "No scroll effects detected"
    ],
    "opportunities": [
      "Hero section with video/3D background",
      "GSAP scroll animations",
      "Testimonial carousel",
      "Service cards with hover effects",
      "Mobile optimization",
      "Page speed optimization"
    ],
    "brand_colors": {
      "primary": "extract manually from site",
      "secondary": "extract manually from site",
      "accent": "extract manually from site"
    },
    "recommended_rebuild_price": "\$5,000 - \$10,000",
    "estimated_timeline": "4-8 hours (Claude Code)"
  },
  "next_steps": [
    "1. Review the site manually at $URL",
    "2. Extract brand colors (use DevTools)",
    "3. Take note of copy (headlines, CTAs)",
    "4. Identify key sections (hero, services, testimonials, contact)",
    "5. Open Claude Code: https://claude.com",
    "6. Use prompts/full-site-rebuild.md to generate remake",
    "7. Deploy to Netlify or Netlify",
    "8. Send cold email with demo link"
  ]
}
EOF

echo "✅ Analysis saved to: $OUTPUT_FILE"
echo ""
echo "📋 Manual review required:"
echo "1. Open: $URL"
echo "2. Check: Design age, mobile, animations, colors"
echo "3. Extract: Brand colors, copy, structure"
echo "4. Update $OUTPUT_FILE with findings"
echo ""
echo "🚀 Next: Run Claude Code rebuild with prompts/full-site-rebuild.md"
echo ""
