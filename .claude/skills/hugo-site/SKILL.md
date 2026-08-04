---
name: hugo-site
description: Build, preview, and structural rules for the laurabmo.com Hugo site — use when building the site, adding/moving pages or sections, editing layouts/CSS, or touching config/theme/deploy setup.
---

# Hugo site (laurabmo.com)

This repo is mid-rebuild from an old theme-based single-page site to a hand-built
four-section site. See `/home/laury/Dropbox/Web/CLAUDE.md` for the full rules and the
current-state-vs-target breakdown — read it before making structural changes.

## Commands

Hugo runs natively (extended edition, version pinned in `.env` as `HUGO_VERSION`).
No containers, no submodules, no npm — `git clone` is enough.

```bash
make serve    # http://localhost:1313/, live reload, drafts visible
make check    # hugo --minify --gc --panicOnWarning — must be clean before any commit
make clean
```

The local Hugo must match `HUGO_VERSION`, or `make check` stops predicting CI. Hold it with
`sudo dnf versionlock add hugo`; bump `.env` in the same commit as any upgrade.

## Rules (already in CLAUDE.md, repeated because they're easy to violate by habit)

- No JS at runtime unless a feature genuinely needs it. Code that runs during `hugo build`
  and ships static markup doesn't count.
- No third-party assets — no CDN fonts, no CDN CSS. Self-host through Hugo Pipes.
- One exception to both of the above: Cloudflare Web Analytics, in
  `layouts/_partials/analytics.html`, gated on `hugo.IsProduction` and a non-empty
  `site.Params.cloudflareAnalyticsToken`. Cookieless, bot-filtered, and the beacon host is
  Cloudflare, who already terminate TLS for the site. Kept in the repo rather than
  edge-injected so what ships to visitors is visible here. No other trackers or analytics;
  any further third-party script, ask first.
- Own templates in `layouts/`. No theme, no npm.
- Single CSS file in `assets/css/main.css`, Hugo Pipes fingerprinted with SRI. The vendored
  `assets/css/vendor/katex.min.css` is the one permitted extra stylesheet.
- Every page must render legibly with CSS disabled — check this by disabling CSS in the
  browser, not just by eyeballing the markup. Maths is exempt; it may rely on `katex.css`.
- URL scheme is stable — do not restructure paths without asking first. A move needs an
  `aliases:` entry at the old path.
- `/writing` and `/help` posts default to `draft: true`. Never flip a draft to published
  without being asked.
- Commit and push only when told to.

## Section map

| Path | Purpose |
|---|---|
| `/` | bio landing |
| `/cv` | CV |
| `/research` | papers, talks, preprints |
| `/softreminder` | app page + privacy policy |
| `/writing` | personal essays, different/more personal register, drafts by default |
| `/help` | mental health / sexuality / transness promotion and info |

## Migration notes

- The theme is gone: submodule deinit'd, `.gitmodules` deleted, `themes/` removed, and
  `theme =` and `googleAnalytics` are out of `config/_default/config.toml`.
- Old content (`content/about.md`, `content/bojos2021.md`, `content/bojos2022.md`,
  `content/contact.md`, `content/papersextras/`) predates the new section structure.
  Don't assume it maps 1:1 onto `/cv` or `/research` — check with the user before
  reorganizing or deleting it.
- Layouts and partials go under `layouts/` at the repo root.
