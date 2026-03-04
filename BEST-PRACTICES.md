# Best Practices Checklist — thetomwestshow.com

Claude Code: Consult this checklist BEFORE every commit. If any check
fails, fix it before committing. Skip checks not applicable to the change.

---

## PRE-COMMIT CHECKLIST

### 1. Security
- [ ] No secrets, API keys, tokens, or passwords in any committed file
- [ ] No inline `<script>` tags (use external .js files)
- [ ] No inline `style=""` attributes or `<style>` blocks (use external .css files)
- [ ] If adding external resources (CDN scripts/styles):
  - [ ] SRI integrity hash present (`integrity="sha384-..."`)
  - [ ] `crossorigin="anonymous"` attribute present
  - [ ] Specific version pinned (no `latest` or unversioned URLs)
  - [ ] CSP updated in Cloudflare Transform Rule
  - [ ] CSP `<meta>` tag updated in ALL HTML files
  - [ ] Documented in CLAUDE.md third-party services table
  - [ ] Tom informed about privacy implications
- [ ] No `eval()`, `innerHTML`, `document.write()`, or `new Function()` in JS
- [ ] No `target="_blank"` links without `rel="noopener noreferrer"`
- [ ] `.gitignore` still excludes secrets files

### 2. HTML Quality
- [ ] Valid HTML5 (no unclosed tags, no deprecated elements)
- [ ] `<!DOCTYPE html>` present
- [ ] `<html lang="en">` set
- [ ] `<meta charset="UTF-8">` declared
- [ ] Viewport meta tag present
- [ ] Unique `<title>` (under 60 characters)
- [ ] `<meta name="description">` (under 160 characters)
- [ ] CSP `<meta>` tag in `<head>` before any scripts/styles
- [ ] Heading hierarchy correct (one `<h1>`, then `<h2>`, `<h3>`, etc.)
- [ ] Semantic elements used (`<nav>`, `<main>`, `<article>`, `<section>`, `<footer>`)

### 3. Accessibility
- [ ] Every `<img>` has meaningful `alt` text (or `alt=""` if decorative)
- [ ] Every `<a>` has descriptive link text (not "click here")
- [ ] Color contrast meets WCAG AA (4.5:1 normal text, 3:1 large text)
- [ ] Interactive elements are keyboard-focusable
- [ ] Focus states are visible
- [ ] Form inputs have associated `<label>` elements

### 4. Performance
- [ ] Images optimized (WebP preferred, reasonable file size)
- [ ] Images have explicit `width` and `height` attributes
- [ ] Images below the fold use `loading="lazy"`
- [ ] No render-blocking JS in `<head>` (use `defer` or `async`)
- [ ] CSS is minimal — no unused rules

### 5. SEO
- [ ] Canonical URL present: `<link rel="canonical" href="...">`
- [ ] Open Graph tags present (`og:title`, `og:description`, `og:image`, `og:url`)
- [ ] `sitemap.xml` updated if pages were added or removed
- [ ] Internal links use relative paths
- [ ] No orphan pages (every page reachable from navigation)

### 6. Mobile
- [ ] Tested at 375px width (iPhone SE)
- [ ] No horizontal scrolling
- [ ] Touch targets minimum 44x44px
- [ ] CSS uses mobile-first breakpoints (`@media (min-width: ...)`)

### 7. Code Quality
- [ ] Clean, readable code with consistent indentation (2 spaces)
- [ ] No commented-out code left behind
- [ ] No `console.log()` left in JS
- [ ] File names lowercase, hyphen-separated
- [ ] Commit message is descriptive and specific

---

## WHEN ADDING A NEW PAGE

All pre-commit checks, plus:
- [ ] Created as `pages/page-name/index.html` (directory-based routing)
- [ ] Added to site navigation
- [ ] Added to `sitemap.xml`
- [ ] Has unique `<title>` and `<meta name="description">`
- [ ] Has Open Graph and Twitter Card meta tags
- [ ] Has canonical URL
- [ ] Has CSP `<meta>` tag in `<head>`
- [ ] Includes shared CSS (`<link rel="stylesheet" href="/css/main.css">`)

---

## WHEN ADDING A THIRD-PARTY SERVICE

All pre-commit checks, plus:
- [ ] Justified: is this service genuinely necessary?
- [ ] Trustworthy: is this a reputable provider?
- [ ] Privacy: what data does it collect about visitors?
- [ ] Tom has approved the addition
- [ ] CSP updated in BOTH Cloudflare and meta tags
- [ ] SRI applied to all external scripts/styles
- [ ] Documented in CLAUDE.md third-party services table
- [ ] Tested with DevTools console open for CSP violations

### Common third-party CSP reference
| Service | CSP additions needed |
|---------|---------------------|
| YouTube embeds | `frame-src https://www.youtube.com; img-src https://i.ytimg.com` |
| Google Fonts | `style-src https://fonts.googleapis.com; font-src https://fonts.gstatic.com` |
| Google Analytics | `script-src https://www.googletagmanager.com; connect-src https://*.google-analytics.com` |
| Plausible Analytics | `script-src https://plausible.io; connect-src https://plausible.io` |
| Cloudflare Web Analytics | `script-src https://static.cloudflareinsights.com; connect-src https://cloudflareinsights.com` |
| Formspree (forms) | `connect-src https://formspree.io; form-action https://formspree.io` |

**Recommendation**: Prefer Cloudflare Web Analytics (free, no cookies, GDPR-compliant) over Google Analytics.

---

## PERIODIC AUDITS

### Monthly
- [ ] Run Lighthouse audit (Performance, Accessibility, Best Practices, SEO)
- [ ] Scan security headers: securityheaders.com
- [ ] Check for broken links
- [ ] Review `git log` — is commit history clean?

### Quarterly
- [ ] Full HTML validation on all pages (validator.w3.org)
- [ ] Full accessibility audit
- [ ] Review all third-party services — still needed?
- [ ] Check if external resources need updated SRI hashes
- [ ] Review CSP — still as restrictive as possible?
- [ ] Check Core Web Vitals in Google Search Console
