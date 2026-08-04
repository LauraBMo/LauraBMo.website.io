# laurabmo.com

Source for [laurabmo.com](https://laurabmo.com/) — a Hugo static site, built with
hand-written templates and no theme.

## Requirements

Hugo, extended edition, at the version pinned in [`.env`](.env) as `HUGO_VERSION`.
Nothing else — no submodules, no npm, no containers.

```bash
sudo dnf install hugo     # Fedora
hugo version              # must print +extended
```

The version must match the pin, because the build runs with `--panicOnWarning` and
different Hugo versions disagree about what is deprecated. To stop `dnf upgrade` from
moving it out from under you:

```bash
sudo dnf versionlock add hugo     # built into dnf5, no plugin needed
```

## Working on it

```bash
make serve    # http://localhost:1313/, live reload, drafts visible
make check    # the exact build check CI runs — must be clean before committing
make clean    # remove build output
```

Config is environment-split across `config/_default/`, `config/development/` (drafts and
future-dated content, verbose logging) and `config/production/`; Hugo merges them by
environment. `make serve` is development, `make check` is production.

## Layout

| Path | What |
|---|---|
| `content/` | pages, one directory per section |
| `layouts/` | all templates — `baseof`, `home`, `single`, `list`, plus `_partials/` and `_markup/` |
| `assets/css/` | `main.css`, the single stylesheet, plus vendored `katex.min.css` |
| `static/` | files served as-is: fonts, images, documents |
| `config/` | environment-split configuration |

## Deployment

Push to `main`. [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) builds at
the pinned Hugo version and runs `wrangler deploy`, publishing `public/` as a Cloudflare
Worker serving static assets — see [`wrangler.jsonc`](wrangler.jsonc). The custom domain is
attached to the Worker, so there is no `CNAME` file. Every other branch and every pull
request runs the same build check via [`ci.yml`](.github/workflows/ci.yml) without publishing.

Deploying needs two repository secrets: `CLOUDFLARE_ACCOUNT_ID`, and `CLOUDFLARE_API_TOKEN`
with the *Workers Scripts → Edit* permission.

## Conventions

See [`CLAUDE.md`](CLAUDE.md) for the full rules — no runtime JS, no third-party assets,
one stylesheet, stable URLs, and why each of those is there.
