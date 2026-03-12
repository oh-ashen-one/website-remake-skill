#!/bin/bash
# find-targets.sh — Search for businesses with outdated websites
# Usage: ./find-targets.sh "dentist" "chicago" 15

set -e

NICHE="${1:-dentist}"
CITY="${2:-chicago}"
LIMIT="${3:-15}"

echo "🔍 Finding $LIMIT $NICHE businesses in $CITY..."
echo ""

# This script generates a search query that you would use in Claude Code
# to find businesses with outdated websites.

# In Claude Code, you would run:
# "Find $LIMIT $NICHE businesses in $CITY with outdated websites"
# The Claude Code agent will:
# 1. Use web_search to find local businesses
# 2. Visit each Google Maps / Yelp / Yellow Pages result
# 3. Analyze each website for: age, design quality, mobile responsiveness
# 4. Output JSON with qualified leads

OUTPUT_FILE="targets_${NICHE}_${CITY}.json"

cat > ${OUTPUT_FILE} << EOF
{
  "search_criteria": {
    "niche": "$NICHE",
    "city": "$CITY",
    "limit": $LIMIT,
    "qualification_criteria": [
      "High Google/Yelp rating (4.0+ stars)",
      "Active business (reviews within 6 months)",
      "Outdated website design (pre-2020 style)",
      "No animations or scroll effects",
      "Poor or missing mobile responsiveness",
      "Slow page load time (> 3 seconds)",
      "Minimum contact info visible (phone, address)"
    ]
  },
  "instructions": {
    "step_1": "Use web_search to find '$NICHE near $CITY'",
    "step_2": "Extract business name, address, phone, website URL",
    "step_3": "Visit each website and analyze:",
    "step_4": "Design age (look at fonts, colors, animations)",
    "step_5": "Mobile responsiveness (check on Chrome DevTools)",
    "step_6": "Page speed (check in DevTools Lighthouse)",
    "step_7": "Social proof (testimonials, reviews)",
    "step_8": "CTAs (clear call-to-action buttons?)"
  },
  "output_fields": [
    "business_name",
    "website_url",
    "phone",
    "address",
    "google_rating",
    "review_count",
    "design_score_1_to_10",
    "mobile_score_1_to_10",
    "animation_score_1_to_10",
    "page_speed_ms",
    "identified_problems",
    "estimated_rebuild_price"
  ],
  "results": []
}
EOF

echo "✅ Search template saved to: $OUTPUT_FILE"
echo ""
echo "📋 Next steps:"
echo "1. Go to Claude Code: https://claude.com"
echo "2. Paste the search query:"
echo ""
echo "   \"Find 15 $NICHE businesses in $CITY with outdated websites."
echo "    Include: name, website, phone, rating, review count."
echo "    Analyze: design quality, mobile responsiveness, page speed."
echo "    Rank by estimated rebuild price.\""
echo ""
echo "3. Copy results into $OUTPUT_FILE"
echo "4. Run: ./scrape-site.sh 'https://website1.com'"
echo ""
