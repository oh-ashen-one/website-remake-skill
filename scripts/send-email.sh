#!/bin/bash
# send-email.sh — Send cold outreach email via AgentMail
# Usage: ./send-email.sh --to owner@example.com --subject "Subject" --url https://preview.com

set -e

TO=""
SUBJECT=""
URL=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --to) TO="$2"; shift 2 ;;
    --subject) SUBJECT="$2"; shift 2 ;;
    --url) URL="$2"; shift 2 ;;
    --business-name) BUSINESS_NAME="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$TO" ] || [ -z "$SUBJECT" ] || [ -z "$URL" ]; then
  echo "❌ Usage: ./send-email.sh --to owner@example.com --subject 'Subject' --url https://preview.com"
  exit 1
fi

# Check for AgentMail API key
if [ -z "$AGENTMAIL_API_KEY" ]; then
  echo "❌ AGENTMAIL_API_KEY not set. Export it:"
  echo "   export AGENTMAIL_API_KEY=your_key_here"
  exit 1
fi

BUSINESS_NAME="${BUSINESS_NAME:-their business}"

echo "📧 Preparing cold email to: $TO"
echo ""

# Email body template
read -r -d '' EMAIL_BODY << 'EOF' || true
Hi there,

I spent the last couple hours rebuilding your website. Here's the live preview:

[LINK_PLACEHOLDER]

What I changed:
• Modern hero with animated background
• Smooth scroll effects on every section
• Mobile-optimized (your current site doesn't work well on mobile)
• Professional testimonials carousel
• Clear call-to-action buttons for bookings/inquiries

This isn't a mockup—it's fully functional, hosted live, and ready to go.

If you like the direction, I'd love to talk about bringing this to your domain.

Best,
[Your Name]

P.S. Most design agencies charge $5K-$15K and take 3+ weeks. This is production-ready in days.
EOF

# Replace placeholder
EMAIL_BODY="${EMAIL_BODY//\[LINK_PLACEHOLDER\]/$URL}"

echo "📝 Email preview:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "To: $TO"
echo "Subject: $SUBJECT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$EMAIL_BODY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Send this email? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Sending via AgentMail..."
  
  # AgentMail API call (requires AGENTMAIL_API_KEY env var)
  # For now, we output the curl command (you can pipe to AgentMail later)
  
  cat << CURL_CMD
# Command to send via AgentMail (copy & run):
curl -X POST https://api.agentmail.to/send \\
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \\
  -H "Content-Type: application/json" \\
  -d '{
    "to": "$TO",
    "subject": "$SUBJECT",
    "body": "'"$(echo "$EMAIL_BODY" | jq -Rs .)"'",
    "track_opens": true,
    "track_clicks": true
  }'
CURL_CMD

  echo ""
  echo "✅ Email ready to send!"
  echo "⏰ Track opens/clicks in AgentMail dashboard"
  echo "📋 Follow up after 3 days if no response"
  
else
  echo "❌ Email not sent."
  exit 1
fi

echo ""
echo "📋 Follow-up schedule:"
echo "1. Day 0: Send initial email"
echo "2. Day 3: 'Did you get a chance to see the new site?'"
echo "3. Day 7: 'Last chance to lock in this pricing'"
echo ""
