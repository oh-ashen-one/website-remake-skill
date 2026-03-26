#!/usr/bin/env python3
import urllib.request, json, base64, os, sys

def get_api_key():
    # Primary: read from plain text file
    key_file = os.path.expanduser('~/.openclaw/workspace/.secrets/gemini-api-key.txt')
    try:
        with open(key_file) as f:
            key = f.read().strip()
            if key:
                return key
    except:
        pass
    # Fallback: env vars
    return os.environ.get('GEMINI_API_KEY', os.environ.get('GOOGLE_API_KEY', ''))

def create_placeholder(path):
    try:
        with open(path, 'wb') as f:
            f.write(b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\xf8\xcf\xc0\x00\x00\x03\x01\x01\x00\x18\xdd\x8d\xb4\x00\x00\x00\x00IEND\xaeB`\x82')
        print(f"⚠️ Created placeholder at {path}")
    except Exception as e:
        print(f"⚠️ Placeholder creation failed: {e}")

niche = sys.argv[1] if len(sys.argv) > 1 else 'professional business'
city = sys.argv[2] if len(sys.argv) > 2 else ''
out_path = sys.argv[3] if len(sys.argv) > 3 else '/tmp/hero-main.jpg'

api_key = get_api_key()
if not api_key:
    print("⚠️ No Gemini API key found")
    create_placeholder(out_path)
    sys.exit(0)

prompt = f"Professional photorealistic interior photo of a {niche} office in {city}. Bright, clean, modern. Welcoming atmosphere. No text, no people, no logos. Wide angle 16:9."

# Correct endpoint: generativelanguage.googleapis.com with API key param
url = f"https://generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-002:predict?key={api_key}"

body = json.dumps({
    "instances": [{"prompt": prompt}],
    "parameters": {"sampleCount": 1, "aspectRatio": "16:9"}
}).encode()

req = urllib.request.Request(url, data=body, headers={"Content-Type": "application/json"})

try:
    with urllib.request.urlopen(req, timeout=60) as resp:
        data = json.loads(resp.read())
        img_b64 = None
        if 'predictions' in data and data['predictions']:
            pred = data['predictions'][0]
            img_b64 = pred.get('bytesBase64Encoded') or pred.get('imageBytes')
        if img_b64:
            with open(out_path, 'wb') as f:
                f.write(base64.b64decode(img_b64))
            print(f"✅ Gemini image saved: {out_path}")
        else:
            print(f"⚠️ No image data in response: {str(data)[:200]}")
            create_placeholder(out_path)
except urllib.error.HTTPError as e:
    body_text = e.read().decode('utf-8', errors='replace')[:500]
    print(f"⚠️ Gemini image gen failed HTTP {e.code}: {body_text}")
    create_placeholder(out_path)
except Exception as e:
    print(f"⚠️ Gemini image gen failed: {e}")
    create_placeholder(out_path)
