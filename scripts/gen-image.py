import urllib.request, json, base64, os, sys

def get_api_key():
    for env_file in ['/Users/andreofastora/.openclaw/workspace/.secrets/gemini.env',
                     '/Users/andreofastora/.openclaw/workspace/.secrets/google.env']:
        try:
            with open(env_file) as f:
                for line in f:
                    if 'GEMINI_API_KEY' in line or 'GOOGLE_API_KEY' in line:
                        return line.strip().split('=', 1)[1].strip().strip('"\'')
        except:
            pass
    return os.environ.get('GEMINI_API_KEY', os.environ.get('GOOGLE_API_KEY', ''))

niche = sys.argv[1] if len(sys.argv) > 1 else 'professional business'
city = sys.argv[2] if len(sys.argv) > 2 else ''
out_path = sys.argv[3] if len(sys.argv) > 3 else 'hero-main.jpg'

api_key = get_api_key()
if not api_key:
    print("⚠️ No Gemini API key found")
    create_placeholder(out_path)
    sys.exit(0)

prompt = f"Professional high-quality photo for a {niche} website. Bright, welcoming, modern interior. Clean composition. No text. Photorealistic. 16:9 landscape."

def create_placeholder(path):
    """Create a minimal 1x1 PNG placeholder"""
    try:
        with open(path, 'wb') as f:
            f.write(b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\xf8\xcf\xc0\x00\x00\x03\x01\x01\x00\x18\xdd\x8d\xb4\x00\x00\x00\x00IEND\xaeB`\x82')
        print(f"⚠️ Created placeholder at {path}")
    except Exception as e:
        print(f"⚠️ Placeholder creation failed: {e}")

# Use Google's REST API for Imagen 2
url = f"https://us-central1-aiplatform.googleapis.com/v1/projects/prod-forge-ai-01/locations/us-central1/imageGenerators/imagen-3.0-generate-002:predict"

body = json.dumps({
    "instances": [{"prompt": prompt}],
    "parameters": {"sampleCount": 1, "aspectRatio": "16:9"}
}).encode()

req = urllib.request.Request(url, data=body, headers={
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}"
})

try:
    with urllib.request.urlopen(req, timeout=60) as resp:
        data = json.loads(resp.read())
        # Check multiple response formats
        img_b64 = None
        if 'predictions' in data and data['predictions']:
            img_b64 = data['predictions'][0].get('bytesBase64Encoded')
        elif 'images' in data and data['images']:
            img_b64 = data['images'][0].get('bytesBase64Encoded') or data['images'][0].get('imageBytes')
        
        if img_b64:
            with open(out_path, 'wb') as f:
                f.write(base64.b64decode(img_b64))
            print(f"✅ Gemini image saved: {out_path}")
        else:
            print(f"⚠️ No image in response")
            create_placeholder(out_path)
except Exception as e:
    print(f"⚠️ Gemini image gen failed: {e}")
    create_placeholder(out_path)
