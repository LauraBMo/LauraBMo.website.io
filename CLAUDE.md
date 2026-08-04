# laurabmo.com

Hugo static site. Four audiences:
1. Academic/industry bio + CV (job search) — primary
2. SoftReminder landing + privacy policy
3. Personal writing / autobiographical essays — structure now, content later
4. Therapy/Helper promotion - structure now, content way later

## Sections
- `/`          bio landing
- `/cv`        CV
- `/research`  papers, talks, preprints
- `/softreminder`  app page + privacy policy
- `/writing`   personal essays; in nav from day one, may be empty
- `/help`    promotion and info about mental health, sexuality, transness

## Current state vs. target

The repo is mid-rebuild (branch `rebuild`), all of it uncommitted. The structural pass is
done: theme removed, own `layouts/`, own `assets/css/main.css`, new config, new deploy
workflow. What remains is content and polish.

Done:
- No theme. Submodule deinit'd, `.gitmodules` deleted, `themes/` gone. Templates are
  `layouts/{baseof,home,single,list}.html` plus `layouts/_markup/render-passthrough.html`.
- `googleAnalytics` removed. The only script on the site is the Cloudflare Web Analytics
  beacon, and it is off until the token is set — see below.
- Analytics is Cloudflare Web Analytics, wired up in `layouts/_partials/analytics.html`,
  gated on `hugo.IsProduction` and a non-empty `site.Params.cloudflareAnalyticsToken`.
  The token in `config/_default/params.toml` is still empty, so nothing is emitted yet;
  paste the token from the Cloudflare dashboard to turn it on.
- LaTeX renders at build time via Hugo's embedded KaTeX, `output: "htmlAndMathml"`.
  `assets/css/vendor/katex.min.css` and `static/fonts/*.woff2` are vendored and
  self-hosted; see `assets/css/vendor/README.md` before upgrading. The stylesheet is
  emitted only on pages that actually contain math.
- New sections exist as stubs: `content/_index.md`, `cv.md`, `research/_index.md`,
  `softreminder/_index.md`, `writing/_index.md`. Each carries a `STUB` HTML comment
  saying what is placeholder and what is sourced. Nav covers CV / Research /
  SoftReminder / Writing.

Not done:
- `/help` has no content and is not in the nav. `archetypes/help.md` exists so posts there will default to draft when the section is created.
- Old content is still on disk, untouched and still routed: `about.md`, `contact.md`, `bojos2021.md`, `bojos2022.md`, `papersextras/`. It has not been merged into the new sections — `/research` duplicates the bibliography from `about.md`. Decide per file whether to migrate, alias, or drop; don't assume a 1:1 mapping.
- `contact.md` now gives `laura@laurabmo.com`, but still lists the Copenhagen department postal address, which is also stale. The page needs migrating or dropping along with the rest of the old content — the address is in the footer sitewide via `params.toml`, so `/contact` may not need to exist at all.

When making changes, know which world you're in: the old pages, or the new structure. Ask if unclear.

## Commands

Hugo runs natively — `sudo dnf install hugo`, extended edition, version pinned in `.env` as
`HUGO_VERSION`. No containers, no submodules, no npm. The Docker/Traefik setup this repo
started with is gone: it ran Traefik v1 with the Docker socket mounted into a container,
which is a root-equivalent exposure, to buy a prettier local hostname than `localhost:1313`.

```bash
make serve    # http://localhost:1313/, live reload, drafts visible
make check    # the build check below
make clean    # remove build output
```

Config is environment-split: `config/_default/`, `config/development/` (draft/future
content, debug logging), `config/production/` — Hugo merges these based on
`HUGO_ENV`/`--environment`. `make serve` is development, `make check` is production.

Build check, the same command CI runs:
```bash
hugo --minify --gc --panicOnWarning
```
`--panicOnWarning` turns a deprecation warning into a failed build. That is deliberate:
the old theme called `.Site.IsServer`, removed in Hugo 0.120, and nobody noticed for
years because CI was pinned to 0.86.1.

That check only predicts CI if the local Hugo matches `HUGO_VERSION`. It does not do so by
itself — `dnf upgrade` will move Hugo eventually. Hold it with
`sudo dnf versionlock add hugo`, and when you do bump, bump `.env` in the same commit.
The 0.148 → 0.162 bump needed two source changes (`languageCode` → `locale` in config,
`.Language.LanguageCode` → `.Language.Locale` in `baseof.html`), and neither is backward
compatible, so local and CI cannot straddle a bump.

Two workflows, both reading `HUGO_VERSION` from `.env`:
- `.github/workflows/ci.yml` — build check on pull requests and on every branch except `main`. Does not publish.
- `.github/workflows/deploy.yml` — same check on `main`, then `wrangler deploy` to Cloudflare Workers via `cloudflare/wrangler-action`. Needs two repo secrets, `CLOUDFLARE_API_TOKEN` (permission *Workers Scripts → Edit*) and `CLOUDFLARE_ACCOUNT_ID`.

Hugo runs in the workflow, not in Cloudflare's build system, so the `HUGO_VERSION` pin and
`--panicOnWarning` stay in the repo rather than in a dashboard setting. The custom domain is
attached to the Worker, not in the repo — there is no `CNAME` file any more.

`wrangler.jsonc` holds the project name and points at `public/`. It declares no `main`
script, so the Worker serves static assets with no code running per request. Cloudflare is
folding Pages into Workers, which is why this is a Worker and not a Pages project — Pages
still works but is not where new features go. The Worker is created on the first deploy;
there is nothing to set up in the dashboard beforehand.

No submodules to initialise — `git clone` is enough.

## Rules
- No JS at runtime unless a feature genuinely needs it. Code that runs during
  `hugo build` and ships static markup does not count as JS on the site.
- No third-party assets. Self-host everything — fonts, CSS, JS — through Hugo Pipes.
  (Hotlinking Google Fonts was held to breach GDPR by a Munich court in 2022; the same
  reasoning covers any CDN.)
- Cloudflare Web Analytics is the one exception to both rules above: a third-party script,
  loaded at runtime from `static.cloudflareinsights.com`. It is allowed because it is
  cookieless (so no consent banner), it gives per-path page views with bot traffic filtered
  out automatically, and the beacon host is Cloudflare — who already terminate TLS for every
  request to this site, so no party learns anything about visitors that it did not already
  see. It is implemented in the repo, in `layouts/_partials/analytics.html`, rather than
  through Cloudflare's automatic edge injection, so that what ships to visitors stays
  visible in the repo. The partial emits nothing unless `hugo.IsProduction` and
  `site.Params.cloudflareAnalyticsToken` (in `config/_default/params.toml`) is non-empty;
  an empty token means analytics is off, which is the case in development.
- No other analytics, no trackers. Any further third-party script: ask first.
- Own templates in `layouts/`. No theme submodules, no npm.
- Ship exactly one stylesheet, Hugo Pipes fingerprinted with SRI. The source may be split
  across `assets/css/*.css` and concatenated once `main.css` outgrows ~400 lines. The
  vendored `katex.css` is the one permitted exception.
- Every page must render legibly with CSS disabled. Mathematical expressions are exempt —
  they may rely on the vendored `katex.css`.
- URL scheme is stable. Moving a page requires an `aliases:` entry at the old path so
  inbound links keep working. Ask first.
- Posts in `/writing` and `/help` default to `draft: true`. Never flip a draft to
  published without me asking.
- Build check before any commit: `hugo --minify --gc --panicOnWarning` clean, no warnings.
  CI runs the same check on pull requests, not only on deploys from `main`.
- Commit and push only when I say so. The one standing exception is `progress.org`: when
  you have changed it, offer to run the `progress-sync` skill, which commits that file
  alone and pushes it after showing the diff and asking. Offer — never do it unasked.
- Keep `progress.org` current. When a task in it is finished, mark it `DONE` with a
  `CLOSED:` stamp in the same turn; when new work appears, add it as `TODO`/`NEXT` with
  tags and a priority rather than leaving it in the conversation only.

## Voice
Plain, specific, no marketing register. Mathematician writing for humans.
`/writing` is allowed a different, more personal register than the rest of the site.
