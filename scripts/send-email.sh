#!/bin/bash
# send-email.sh — Send cold outreach email via AgentMail
# Usage: ./send-email.sh --to owner@example.com --business-name "Joe's Plumbing" --url https://preview.netlify.app

set -e

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

# Load AgentMail key from secrets
SECRETS_DIR="$HOME/.openclaw/workspace/.secrets"
if [ -f "$SECRETS_DIR/agentmail-api-key.txt" ]; then
  AGENTMAIL_API_KEY=$(cat "$SECRETS_DIR/agentmail-api-key.txt" | tr -d '[:space:]')
fi

TO=""
SUBJECT=""
URL=""
BUSINESS_NAME=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --to) TO="$2"; shift 2 ;;
    --subject) SUBJECT="$2"; shift 2 ;;
    --url) URL="$2"; shift 2 ;;
    --business-name) BUSINESS_NAME="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$TO" ] || [ -z "$URL" ]; then
  echo "❌ Usage: ./send-email.sh --to owner@example.com --url https://preview.netlify.app --business-name 'Joe Plumbing'"
  exit 1
fi

if [ -z "$AGENTMAIL_API_KEY" ]; then
  echo "❌ AGENTMAIL_API_KEY not found in $SECRETS_DIR/agentmail-api-key.txt"
  exit 1
fi

BUSINESS_NAME="${BUSINESS_NAME:-your business}"
SUBJECT="${SUBJECT:-I rebuilt your website — here's the link}"

# Get the AgentMail inbox to send from
INBOX_RESPONSE=$(curl -s -X GET "https://api.agentmail.to/v0/inboxes" \
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \
  -H "Content-Type: application/json")

FROM_EMAIL=$(echo "$INBOX_RESPONSE" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['items'][0]['address'])" 2>/dev/null || echo "")

if [ -z "$FROM_EMAIL" ]; then
  echo "❌ Could not fetch AgentMail inbox. Check API key."
  echo "Response: $INBOX_RESPONSE"
  exit 1
fi

echo "📧 Sending from: $FROM_EMAIL"
echo "📧 Sending to: $TO"
echo "📎 Preview URL: $URL"
echo ""

# Build email body
EMAIL_BODY="Hi there,

I spent the last couple of hours rebuilding your website. Here's the live preview:

$URL

What I changed:
- Modern hero with animated background
- Smooth scroll effects on every section
- Mobile-optimized layout (your current site has issues on mobile)
- Professional testimonials section
- Clear call-to-action buttons

This isn't a mockup — it's fully functional, hosted live, and ready to go.

If you like the direction, I'd love to talk about moving this to your domain.

Best,
Andre

P.S. Most agencies charge \$5K–\$15K and take 3+ weeks. This is production-ready in days."

# Send via AgentMail
SEND_RESPONSE=$(curl -s -X POST "https://api.agentmail.to/v0/inboxes/$FROM_EMAIL/messages" \
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"to\": [\"$TO\"],
    \"subject\": \"$SUBJECT\",
    \"text\": $(echo "$EMAIL_BODY" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  }")

MSG_ID=$(echo "$SEND_RESPONSE" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('id',''))" 2>/dev/null || echo "")

if [ -n "$MSG_ID" ]; then
  echo "✅ Email sent! Message ID: $MSG_ID"
  echo ""
  echo "📋 Follow-up schedule:"
  echo "  Day 3: 'Did you get a chance to see the new site?'"
  echo "  Day 7: 'Last chance to lock in this pricing'"
else
  echo "❌ Send failed. Response:"
  echo "$SEND_RESPONSE"
  exit 1
fi
