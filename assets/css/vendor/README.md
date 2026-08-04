# Vendored third-party assets

Nothing here is written by us. Files are byte-identical to their upstream release so
that upgrading is a straight overwrite and `sha256sum` is meaningful.

## katex.min.css

- Version: 0.16.22
- Source: https://github.com/KaTeX/KaTeX/releases/download/v0.16.22/katex.tar.gz
- sha256: 19095127357ed6d29fe0a63a6b000c913a89f7f1963b765dd3715e97c9852e75

The matching fonts live in `static/fonts/`. Only the 20 `.woff2` files are shipped; the
`.woff` and `.ttf` fallbacks in the tarball are dropped, since woff2 has been supported
by every current browser since 2016. `layouts/_partials/head-katex.html` strips the
corresponding `src` entries and rewrites `url(fonts/…)` to `url(/fonts/…)` at build time,
which is why this file can stay unmodified.

### Upgrading

1. Download the new `katex.tar.gz` from the KaTeX releases page.
2. Overwrite `katex.min.css` here and `static/fonts/*.woff2`.
3. Update the version and sha256 above.
4. Check that the `@font-face` `src` syntax still matches the two regexes in
   `head-katex.html` — if upstream reorders or reformats those declarations, the strip
   silently stops working and the browser will request `.woff`/`.ttf` files that
   aren't there.
5. Keep it roughly in step with the KaTeX that Hugo embeds for `transform.ToMath`;
   a large version gap between the markup generator and this stylesheet will show up
   as subtly broken spacing.
