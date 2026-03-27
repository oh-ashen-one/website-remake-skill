#!/usr/bin/env python3
"""
gen-subpages.py — Generate styled subpages from Stitch-generated index.html.

Extracts the full <head>, <nav>, and <footer> from index.html so subpages
inherit the same Tailwind config, theme, fonts, and layout. Content is
niche-specific with real copy.

Usage: python3 gen-subpages.py <build_dir> <business_name> <niche> <city> <slug> [phone] [address]
"""

import sys, os, re

def extract_between(html, open_tag, close_tag):
    """Extract content between first occurrence of open_tag and close_tag (inclusive)."""
    pattern = re.compile(
        f'({re.escape(open_tag[0]) if len(open_tag)==1 else open_tag}.*?{re.escape(close_tag[0]) if len(close_tag)==1 else close_tag})',
        re.DOTALL | re.IGNORECASE
    )
    m = pattern.search(html)
    return m.group(1) if m else ''

def extract_head(html):
    """Extract full <head>...</head> content."""
    m = re.search(r'<head[^>]*>(.*?)</head>', html, re.DOTALL | re.IGNORECASE)
    return m.group(1) if m else ''

def extract_nav(html):
    """Extract <nav>...</nav> — handles nested tags."""
    start = re.search(r'<nav\b', html, re.IGNORECASE)
    if not start:
        return ''
    depth = 0
    i = start.start()
    while i < len(html):
        if html[i:i+4].lower() == '<nav':
            depth += 1
        elif html[i:i+6].lower() == '</nav>':
            depth -= 1
            if depth == 0:
                return html[start.start():i+6]
        i += 1
    return html[start.start():]

def extract_footer(html):
    """Extract <footer>...</footer> — handles nested tags."""
    start = re.search(r'<footer\b', html, re.IGNORECASE)
    if not start:
        return ''
    depth = 0
    i = start.start()
    while i < len(html):
        if html[i:i+7].lower() == '<footer':
            depth += 1
        elif html[i:i+9].lower() == '</footer>':
            depth -= 1
            if depth == 0:
                return html[start.start():i+9]
        i += 1
    return html[start.start():]

def extract_body_classes(html):
    """Extract class attribute from <body> tag."""
    m = re.search(r'<body\b[^>]*class=["\']([^"\']*)["\']', html, re.IGNORECASE)
    return m.group(1) if m else ''

def extract_html_classes(html):
    """Extract class attribute from <html> tag."""
    m = re.search(r'<html\b[^>]*class=["\']([^"\']*)["\']', html, re.IGNORECASE)
    return m.group(1) if m else ''

def extract_theme_style(html):
    """Extract forge-theme style block if present."""
    m = re.search(r'(<style\s+id=["\']forge-theme["\'][^>]*>.*?</style>)', html, re.DOTALL | re.IGNORECASE)
    return m.group(1) if m else ''

def extract_theme_script(html):
    """Extract forge-theme-js script block if present."""
    m = re.search(r'(<script\s+id=["\']forge-theme-js["\'][^>]*>.*?</script>)', html, re.DOTALL | re.IGNORECASE)
    return m.group(1) if m else ''

# Niche-specific service descriptions
NICHE_SERVICES = {
    'gym': [
        ('Personal Training', 'One-on-one sessions with certified trainers who build custom programs around your goals, fitness level, and schedule.'),
        ('Group Fitness Classes', 'High-energy classes including HIIT, strength circuits, and functional training. All levels welcome.'),
        ('Strength & Conditioning', 'Structured programs for powerlifting, Olympic lifting, and athletic performance. Competition-grade equipment.'),
        ('Recovery & Wellness', 'Stretch therapy, sports massage, and recovery tools to keep you performing at your peak.'),
    ],
    'dentist': [
        ('General Dentistry', 'Comprehensive exams, cleanings, fillings, and preventive care for the whole family.'),
        ('Cosmetic Dentistry', 'Teeth whitening, veneers, bonding, and smile makeovers that transform your confidence.'),
        ('Restorative Care', 'Crowns, bridges, implants, and dentures to restore function and aesthetics.'),
        ('Emergency Dental', 'Same-day appointments for toothaches, broken teeth, and dental emergencies.'),
    ],
    'plumber': [
        ('Residential Plumbing', 'Leak repair, pipe replacement, fixture installation, and whole-home repiping.'),
        ('Drain Cleaning', 'Video inspection, hydro-jetting, and rooter service for stubborn clogs.'),
        ('Water Heater Services', 'Installation, repair, and replacement of tank and tankless water heaters.'),
        ('Emergency Plumbing', '24/7 emergency response for burst pipes, sewer backups, and flooding.'),
    ],
    'electrician': [
        ('Residential Electrical', 'Panel upgrades, outlet installation, rewiring, and code compliance.'),
        ('Lighting Design', 'Interior and exterior lighting installation, smart home integration, and LED upgrades.'),
        ('Generator Installation', 'Whole-home backup generators, transfer switches, and maintenance plans.'),
        ('Emergency Electrical', 'Fast response for outages, sparking outlets, and electrical hazards.'),
    ],
}

DEFAULT_SERVICES = [
    ('Core Services', 'Our primary offerings designed to meet your everyday needs with professional quality.'),
    ('Specialized Solutions', 'Expert handling of complex projects that require advanced skills and equipment.'),
    ('Consultation & Planning', 'Free estimates and professional guidance to help you make informed decisions.'),
    ('Emergency Response', 'When you need help fast, our team is ready with rapid response times.'),
]

# Niche-specific about content
NICHE_ABOUT = {
    'gym': {
        'intro': "isn't just a gym — it's a training ground built for people who show up and put in the work.",
        'values': [
            'Expert coaches who actually train, not just talk',
            'Equipment maintained to competition standards',
            'A community that pushes you without pretension',
            'Programs designed around your goals, not cookie-cutter templates',
        ],
        'cta': 'Start your free trial today',
    },
    'dentist': {
        'intro': 'provides comprehensive dental care built on trust, comfort, and clinical excellence.',
        'values': [
            'Modern technology for faster, more comfortable treatment',
            'A warm, judgment-free environment for every patient',
            'Transparent pricing — no surprise bills',
            'Flexible scheduling including early morning and weekend hours',
        ],
        'cta': 'Book your appointment today',
    },
    'plumber': {
        'intro': 'delivers reliable plumbing solutions backed by years of hands-on experience.',
        'values': [
            'Licensed, insured, and background-checked technicians',
            'Upfront pricing before any work begins',
            'Clean work sites — we treat your home like our own',
            'Warranties on parts and labor',
        ],
        'cta': 'Get a free estimate today',
    },
}

DEFAULT_ABOUT = {
    'intro': 'has been proudly serving the local community with professional, reliable service.',
    'values': [
        'Experienced, certified professionals',
        'Transparent pricing with no hidden fees',
        'Committed to exceeding expectations',
        'Locally owned and community-focused',
    ],
    'cta': 'Get in touch today',
}


def build_subpage(head_content, nav_html, footer_html, html_classes, body_classes, theme_style, theme_script, page_config):
    """Build a complete HTML subpage."""
    # Modify head: swap title and meta description
    modified_head = head_content
    modified_head = re.sub(r'<title>[^<]*</title>', f'<title>{page_config["title"]}</title>', modified_head)
    modified_head = re.sub(
        r'<meta\s+name=["\']description["\']\s+content=["\'][^"\']*["\']',
        f'<meta name="description" content="{page_config["meta_desc"]}"',
        modified_head
    )
    # Add/replace canonical
    canonical = f'<link rel="canonical" href="{page_config["canonical"]}">'
    if re.search(r'<link\s+rel=["\']canonical["\']', modified_head):
        modified_head = re.sub(r'<link\s+rel=["\']canonical["\']\s+href=["\'][^"\']*["\'][^>]*/?\s*>', canonical, modified_head)
    else:
        modified_head += f'\n  {canonical}'

    # Fix nav links on subpage
    fixed_nav = nav_html
    fixed_nav = re.sub(r'href=["\']#about["\']', 'href="about.html"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#services["\']', 'href="services.html"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#contact["\']', 'href="contact.html"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#contact-us["\']', 'href="contact.html"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#home["\']', 'href="index.html"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#stats["\']', 'href="index.html#stats"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#testimonials["\']', 'href="index.html#testimonials"', fixed_nav)
    fixed_nav = re.sub(r'href=["\']#faq["\']', 'href="index.html#faq"', fixed_nav)

    # Fix footer links too
    fixed_footer = footer_html
    fixed_footer = re.sub(r'href=["\']#about["\']', 'href="about.html"', fixed_footer)
    fixed_footer = re.sub(r'href=["\']#services["\']', 'href="services.html"', fixed_footer)
    fixed_footer = re.sub(r'href=["\']#contact["\']', 'href="contact.html"', fixed_footer)
    fixed_footer = re.sub(r'href=["\']#home["\']', 'href="index.html"', fixed_footer)

    return f'''<!DOCTYPE html>
<html class="{html_classes}" lang="en">
<head>
{modified_head}
</head>
<body class="{body_classes}">
  {fixed_nav}
  <main class="pt-24 pb-16 px-4 md:px-8 max-w-5xl mx-auto min-h-screen">
    {page_config["content"]}
  </main>
  {fixed_footer}
  {theme_style}
  {theme_script}
</body>
</html>'''


def main():
    if len(sys.argv) < 6:
        print("Usage: gen-subpages.py <build_dir> <business_name> <niche> <city> <slug> [phone] [address]")
        sys.exit(1)

    build_dir = sys.argv[1]
    business_name = sys.argv[2]
    niche = sys.argv[3].lower()
    city = sys.argv[4]
    slug = sys.argv[5]
    phone = sys.argv[6] if len(sys.argv) > 6 else ''
    address = sys.argv[7] if len(sys.argv) > 7 else ''

    index_path = os.path.join(build_dir, 'index.html')
    if not os.path.exists(index_path):
        print(f"❌ index.html not found at {index_path}")
        sys.exit(1)

    with open(index_path, 'r') as f:
        html = f.read()

    head_content = extract_head(html)
    nav_html = extract_nav(html)
    footer_html = extract_footer(html)
    html_classes = extract_html_classes(html)
    body_classes = extract_body_classes(html)
    theme_style = extract_theme_style(html)
    theme_script = extract_theme_script(html)

    base_url = f"https://oh-ashen-one.github.io/{slug}"

    # Get niche-specific content
    services = NICHE_SERVICES.get(niche, DEFAULT_SERVICES)
    about = NICHE_ABOUT.get(niche, DEFAULT_ABOUT)

    # ── Services page ──
    services_cards = ''
    for title, desc in services:
        services_cards += f'''
        <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-8 hover:bg-white/10 transition-all duration-300">
          <h3 class="text-xl font-bold text-white mb-3">{title}</h3>
          <p class="text-white/70 leading-relaxed">{desc}</p>
        </div>'''

    services_content = f'''
    <h1 class="text-4xl md:text-5xl font-black text-white mb-4 tracking-tight">Our Services</h1>
    <p class="text-lg text-white/60 mb-12 max-w-2xl">{business_name} offers a full range of professional {niche} services in {city}.</p>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
      {services_cards}
    </div>
    <div class="flex flex-wrap gap-4">
      <a href="contact.html" class="inline-block bg-white text-black font-bold px-8 py-4 rounded-xl hover:bg-white/90 transition-colors">Get Started</a>
      <a href="index.html" class="inline-block border border-white/30 text-white font-bold px-8 py-4 rounded-xl hover:bg-white/10 transition-colors">Back to Home</a>
    </div>'''

    services_page = build_subpage(
        head_content, nav_html, footer_html, html_classes, body_classes, theme_style, theme_script,
        {
            'title': f'{business_name} Services — {niche.title()} in {city}',
            'meta_desc': f'Professional {niche} services offered by {business_name} in {city}. View our full service list.',
            'canonical': f'{base_url}/services.html',
            'content': services_content,
        }
    )

    # ── About page ──
    values_html = ''.join(f'<li class="flex items-start gap-3 text-white/80"><span class="text-green-400 mt-1">✓</span><span>{v}</span></li>' for v in about['values'])

    about_content = f'''
    <h1 class="text-4xl md:text-5xl font-black text-white mb-4 tracking-tight">About {business_name}</h1>
    <p class="text-lg text-white/60 mb-8 max-w-2xl">Proudly serving {city} and the surrounding community.</p>
    <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-8 md:p-12 mb-8">
      <p class="text-xl text-white/80 leading-relaxed mb-8">{business_name} {about["intro"]}</p>
      <h2 class="text-2xl font-bold text-white mb-6">Why Choose Us</h2>
      <ul class="space-y-4 mb-8">
        {values_html}
      </ul>
    </div>
    <div class="flex flex-wrap gap-4">
      <a href="contact.html" class="inline-block bg-white text-black font-bold px-8 py-4 rounded-xl hover:bg-white/90 transition-colors">{about["cta"]}</a>
      <a href="services.html" class="inline-block border border-white/30 text-white font-bold px-8 py-4 rounded-xl hover:bg-white/10 transition-colors">View Services</a>
      <a href="index.html" class="inline-block border border-white/30 text-white font-bold px-8 py-4 rounded-xl hover:bg-white/10 transition-colors">Home</a>
    </div>'''

    about_page = build_subpage(
        head_content, nav_html, footer_html, html_classes, body_classes, theme_style, theme_script,
        {
            'title': f'About {business_name} — {niche.title()} in {city}',
            'meta_desc': f'Learn about {business_name}, a trusted {niche} serving {city} and surrounding areas.',
            'canonical': f'{base_url}/about.html',
            'content': about_content,
        }
    )

    # ── Contact page ──
    phone_html = f'''
      <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-8 text-center">
        <div class="text-4xl mb-4">📞</div>
        <h3 class="text-xl font-bold text-white mb-2">Call Us</h3>
        <a href="tel:{phone}" class="text-2xl font-bold text-green-400 hover:text-green-300 transition-colors">{phone}</a>
      </div>''' if phone else ''

    address_html = f'''
      <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-8 text-center">
        <div class="text-4xl mb-4">📍</div>
        <h3 class="text-xl font-bold text-white mb-2">Visit Us</h3>
        <p class="text-white/70">{address}</p>
      </div>''' if address else ''

    area_html = f'''
      <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-8 text-center">
        <div class="text-4xl mb-4">🌐</div>
        <h3 class="text-xl font-bold text-white mb-2">Service Area</h3>
        <p class="text-white/70">{city} and surrounding areas</p>
      </div>'''

    contact_content = f'''
    <h1 class="text-4xl md:text-5xl font-black text-white mb-4 tracking-tight">Contact Us</h1>
    <p class="text-lg text-white/60 mb-12 max-w-2xl">Ready to get started? Reach out to {business_name} today.</p>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
      {phone_html}
      {address_html}
      {area_html}
    </div>
    <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-8 md:p-12 max-w-2xl">
      <h2 class="text-2xl font-bold text-white mb-6">Send a Message</h2>
      <form class="space-y-4">
        <input type="text" placeholder="Your Name" class="w-full px-4 py-3 bg-white/5 border border-white/20 rounded-xl text-white placeholder-white/40 focus:outline-none focus:border-white/50 transition-colors">
        <input type="email" placeholder="Your Email" class="w-full px-4 py-3 bg-white/5 border border-white/20 rounded-xl text-white placeholder-white/40 focus:outline-none focus:border-white/50 transition-colors">
        <textarea placeholder="How can we help?" rows="5" class="w-full px-4 py-3 bg-white/5 border border-white/20 rounded-xl text-white placeholder-white/40 focus:outline-none focus:border-white/50 transition-colors resize-vertical"></textarea>
        <button type="submit" class="w-full bg-white text-black font-bold py-4 rounded-xl hover:bg-white/90 transition-colors">Send Message</button>
      </form>
    </div>
    <div class="flex flex-wrap gap-4 mt-8">
      <a href="index.html" class="inline-block border border-white/30 text-white font-bold px-8 py-4 rounded-xl hover:bg-white/10 transition-colors">Home</a>
      <a href="services.html" class="inline-block border border-white/30 text-white font-bold px-8 py-4 rounded-xl hover:bg-white/10 transition-colors">Services</a>
      <a href="about.html" class="inline-block border border-white/30 text-white font-bold px-8 py-4 rounded-xl hover:bg-white/10 transition-colors">About</a>
    </div>'''

    contact_page = build_subpage(
        head_content, nav_html, footer_html, html_classes, body_classes, theme_style, theme_script,
        {
            'title': f'Contact {business_name} — {niche.title()} in {city}',
            'meta_desc': f'Contact {business_name} for {niche} services in {city}. Call us or send a message.',
            'canonical': f'{base_url}/contact.html',
            'content': contact_content,
        }
    )

    # Write all subpages
    for name, content in [('services.html', services_page), ('about.html', about_page), ('contact.html', contact_page)]:
        path = os.path.join(build_dir, name)
        with open(path, 'w') as f:
            f.write(content)
        print(f"✅ {name}")

    # Also update index.html nav to include About and Contact links
    # Add them to nav if missing
    with open(index_path, 'r') as f:
        index_html = f.read()

    # Check if About link exists in nav
    nav_section = extract_nav(index_html)
    has_about = bool(re.search(r'href=["\']about\.html["\']', nav_section))
    has_contact_link = bool(re.search(r'href=["\']contact\.html["\']', nav_section))

    if not has_about or not has_contact_link:
        # Find the last nav link before the phone/button section
        # Insert About and Contact links
        additions = ''
        if not has_about:
            # Find a nav link to insert after
            last_link = re.findall(r'(<a\s+class="[^"]*"\s+href="[^"]*">[^<]*</a>)', nav_section)
            if last_link:
                # Get style from first link for consistency
                style_match = re.search(r'class="([^"]*)"', last_link[0])
                link_class = style_match.group(1) if style_match else ''
                # Make it non-active (remove border-b, change color)
                inactive_class = re.sub(r'border-b-\d+\s*', '', link_class)
                inactive_class = re.sub(r'border-\[[^\]]*\]\s*', '', inactive_class)
                inactive_class = re.sub(r'pb-\d+\s*', '', inactive_class)
                # Get primary color to apply as hover
                about_link = f'\n        <a class="{inactive_class}" href="about.html">About</a>'
                contact_link = f'\n        <a class="{inactive_class}" href="contact.html">Contact</a>'

                # Insert after last FAQ/nav link
                insert_after = last_link[-1]
                new_links = insert_after
                if not has_about:
                    new_links += about_link
                if not has_contact_link:
                    new_links += contact_link

                index_html = index_html.replace(insert_after, new_links, 1)

    with open(index_path, 'w') as f:
        f.write(index_html)

    print(f"✅ All subpages generated with full Stitch styling")


if __name__ == '__main__':
    main()
