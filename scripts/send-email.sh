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
URL=""
BUSINESS_NAME=""
SPECIFIC_PROBLEMS=""
FIRST_NAME=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --to) TO="$2"; shift 2 ;;
    --url) URL="$2"; shift 2 ;;
    --business-name) BUSINESS_NAME="$2"; shift 2 ;;
    --problems) SPECIFIC_PROBLEMS="$2"; shift 2 ;;
    --first-name) FIRST_NAME="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$TO" ] || [ -z "$URL" ]; then
  echo "❌ Usage: ./send-email.sh --to owner@example.com --url https://demo.github.io/slug --business-name 'Joe Plumbing' --problems 'site not mobile friendly'"
  exit 1
fi

if [ -z "$AGENTMAIL_API_KEY" ]; then
  echo "❌ AGENTMAIL_API_KEY not found in $SECRETS_DIR/agentmail-api-key.txt"
  exit 1
fi

# Hardcoded inbox — never dynamically select
FROM_EMAIL="forgeaiseo@agentmail.to"

BUSINESS_NAME="${BUSINESS_NAME:-your business}"
FIRST_NAME="${FIRST_NAME:-there}"
SPECIFIC_PROBLEMS="${SPECIFIC_PROBLEMS:-it doesn't load properly on mobile and your phone number isn't visible above the fold}"
SUBJECT="${BUSINESS_NAME} — we rebuilt your entire website"

echo "📧 Sending from: $FROM_EMAIL (Alison | Teza)"
echo "📧 Sending to: $TO"
echo "📎 Preview URL: $URL"
echo ""

# Build email body — Alison | Teza template from SKILL.md
EMAIL_BODY="Hi ${FIRST_NAME},

My name is Alison, from Teza. We help small businesses rebuild their digital footprint using AI — new websites, SEO, the works.

We rebuilt your entire website because we noticed a few problems with your current one: ${SPECIFIC_PROBLEMS}. These kinds of issues are quietly costing you customers every week.

Take a look at what we built:
${URL}

Completely free to browse — no credit card, no catch.

If you like it, we'd love to sell it to you. We can have the whole thing running on your own domain within 24 hours. If it's not for you, no pressure at all — just let us know.

— Alison
Teza"

# Send via AgentMail — hardcoded endpoint
SEND_RESPONSE=$(curl -s -X POST "https://api.agentmail.to/v0/inboxes/forgeaiseo@agentmail.to/messages/send" \
  -H "Authorization: Bearer $AGENTMAIL_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"to\": [\"$TO\"],
    \"from_display_name\": \"Alison | Teza\",
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
