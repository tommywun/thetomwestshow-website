# The Tom West Show — Website

## At the start of each session
- Read this file completely before doing anything
- Check `git status` and `git log -5` to see recent changes
- Check BEST-PRACTICES.md before making any changes
- Verify the site is live: `curl -sI https://thetomwestshow.com | head -20`
- Share any notable observations with Tom

## Project overview
- **Site**: thetomwestshow.com — personal "everything site"
- **Architecture**: Static HTML/CSS/JS on GitHub Pages, Cloudflare DNS + proxy
- **Repo**: github.com/tommywun/thetomwestshow-website (main branch)
- **Domain registrar**: GoDaddy (nameservers point to Cloudflare)
- **Cloudflare zone ID**: 0ba8b49c13e3b8192c3f4f118e1bd0e6
- **Cloudflare account ID**: 8258a1fdf539f95d62ce9f567a16f858
- **Deploy**: `git push` to main — GitHub Pages auto-builds in ~1 minute
- **YouTube channel**: @thetomwestshow

## Secrets
- **Location**: `~/.config/tws-secrets/vault.json` (plaintext, always readable)
- **Encrypted backup scripts**: `.secrets/vault-encrypt.sh` and `vault-decrypt.sh`
- **NEVER commit vault.json or vault.enc** — `.gitignore` handles this
- **NEVER log, print, or echo secret values**
- **NEVER pass secrets as CLI arguments** (visible in `ps`)
- Contains: Cloudflare API token, GitHub account, VPS creds, OpenAI key, Telegram bot token, Resend API key, YouTube OAuth reference

## Architecture principles
- Clean, minimal, uncluttered code — readability over cleverness
- The site will change radically over time as tech develops
- Every file should be easy for a non-expert to understand
- Mobile-first responsive design
- Semantic HTML5 — use correct elements (`<nav>`, `<main>`, `<article>`, `<section>`, `<footer>`, `<header>`, `<aside>`, `<figure>`)
- External CSS files preferred over inline styles (CSP compatibility)
- External JS files preferred over inline scripts (CSP compatibility)
- No build tools, no bundlers, no frameworks unless the complexity is genuinely justified
- Progressive enhancement: core content works without JavaScript

## File structure
```
thetomwestshow-website/
├── index.html                 ← Homepage
├── CNAME                      ← Domain mapping (DO NOT DELETE)
├── CLAUDE.md                  ← This file
├── BEST-PRACTICES.md          ← Checklist consulted before every change
├── robots.txt                 ← Search engine instructions
├── sitemap.xml                ← Sitemap for SEO
├── 404.html                   ← Custom error page
├── .gitignore
├── .secrets/                  ← Vault encrypt/decrypt scripts only
├── css/
│   ├── main.css               ← Global styles
│   └── videos.css             ← Videos page styles (magazine editorial)
├── fonts/
│   ├── playfair-display-v40-latin-regular.woff2  ← Serif display font
│   └── playfair-display-v40-latin-700.woff2      ← Serif display font (bold)
├── js/                        ← Scripts (when needed)
├── images/                    ← Web-optimized images
└── pages/
    └── videos/
        └── index.html         ← /pages/videos/ — YouTube video gallery
```

## Routing convention
- Every page is a directory with an `index.html` inside it
- Example: `/about/` is served by `pages/about/index.html`
- This gives clean URLs without `.html` extensions
- GitHub Pages serves `dir/index.html` automatically for `dir/` requests

## Important files — DO NOT DELETE
- `CNAME` — Maps thetomwestshow.com to this repo. Deleting it breaks the site.
- `index.html` — The homepage
- `.gitignore` — Prevents secrets from being committed

## Security — GitHub Pages + Cloudflare

### What GitHub Pages provides automatically
- HTTPS via Let's Encrypt (auto-renewed)
- DDoS protection (GitHub infrastructure)
- No server-side execution (static files only = small attack surface)
- Cannot set custom HTTP headers (major limitation)

### What Cloudflare provides
- DNS proxy (orange cloud) hides GitHub Pages origin
- SSL/TLS: Full encryption
- Always Use HTTPS (HTTP→HTTPS redirect)
- Minimum TLS version: 1.2
- Automatic HTTPS Rewrites
- Browser Integrity Check
- Email Address Obfuscation
- Hotlink Protection

### Security headers via Cloudflare Transform Rules
GitHub Pages cannot set HTTP headers. All security headers are set via a single Cloudflare Transform Rule (Modify Response Header). Free plan allows 10 rules total — we use just one.

Headers set:
- `Content-Security-Policy` (see CSP section below)
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=()`

Headers removed:
- `x-github-request-id` (leaks hosting provider)
- `server` (leaks server identity)

### Content Security Policy (CSP)
Set via Cloudflare Transform Rule AND `<meta>` tag in every HTML file (belt and suspenders).

**Base CSP** (update as services are added):
```
default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https://i.ytimg.com; font-src 'self'; connect-src 'self'; media-src 'self'; frame-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests
```

**When adding a third-party service**, update CSP in BOTH locations:
1. Cloudflare Transform Rule (via API or dashboard)
2. `<meta>` tag in EVERY HTML file
3. Document in the third-party services table below

### Subresource Integrity (SRI)
Any external script or stylesheet from a CDN MUST include:
- `integrity="sha384-..."` attribute
- `crossorigin="anonymous"` attribute
- Specific version pinned in the URL (never `latest` or unversioned)

### Third-party services registry
| Service | Purpose | CSP additions | SRI? | Date added |
|---------|---------|---------------|------|------------|
| YouTube thumbnails (i.ytimg.com) | Video thumbnail images on /pages/videos/ | img-src https://i.ytimg.com | N/A (images) | 2026-03-05 |

**When adding any third-party service, Claude Code MUST:**
1. Ask Tom: "Do you trust this provider? They will be able to track visitors."
2. Add the minimum necessary CSP directives (not wildcard domains)
3. Apply SRI to all external scripts/stylesheets
4. Document in this table
5. Test with browser DevTools console — check for CSP violations
6. Run a security header scan at securityheaders.com

## Working rules
- **Learn and document immediately**: When something goes wrong, a workaround is discovered, or a non-obvious pattern emerges — add it to this file right away.
- **Advocate for the optimal approach**: Always state the most efficient strategy with reasoning, even if Tom suggests something different. Tom values logical pushback and a second perspective.
- **Consult BEST-PRACTICES.md before every change**: Run through the applicable checklist before committing.
- **Proactive security reminders**: When adding any new feature, ALWAYS check whether it introduces new CSP requirements, external dependencies, or attack surface. Remind Tom about the implications.
- **Proactive quality reminders**: Suggest Lighthouse audits, security scans, and accessibility checks at natural milestones.
- **Keep it simple**: This is a static site. Resist complexity. Every dependency is a future burden. Vanilla HTML/CSS/JS can do more than most people think.
- **Commit small, commit often**: Each commit should be one logical change.
- **Always push after committing**: Tom expects changes to be live immediately.
- **Tom is not a technical expert**: Explain decisions in plain language. Don't assume knowledge of web architecture, security, or coding conventions. Prompt and remind him about things he might miss.

## Cloudflare configuration checklist
Applied to zone 0ba8b49c13e3b8192c3f4f118e1bd0e6:
- [x] SSL/TLS: Full
- [x] Always Use HTTPS: ON
- [x] Minimum TLS: 1.2
- [x] Automatic HTTPS Rewrites: ON
- [ ] HSTS: ON (max-age 1 year, includeSubDomains)
- [ ] Browser Integrity Check: ON
- [ ] Email Address Obfuscation: ON
- [ ] Hotlink Protection: ON
- [ ] Bot Fight Mode: ON
- [ ] Transform Rule: Security headers

## Troubleshooting
**Site not loading after push:**
Wait 1-2 minutes for GitHub Pages build. Check https://github.com/tommywun/thetomwestshow-website/actions

**SSL certificate not working:**
Ensure Cloudflare DNS has A records for GitHub Pages IPs (185.199.108-111.153) and CNAME www → tommywun.github.io.

**CSP blocking something:**
Open browser DevTools Console. CSP violations appear as errors. Update CSP in both Cloudflare Transform Rule and meta tag in every HTML file.

**Need to revert a change:**
`git log` to find the commit, `git revert HEAD` to undo the last one, `git push`.
