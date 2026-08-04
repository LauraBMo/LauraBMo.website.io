---
name: cv-content
description: Voice and factual-sourcing rules for writing or editing bio, CV, and research content (/, /cv, /research) — use when drafting or revising Laura's academic/industry bio, CV entries, or the papers/talks/preprints list.
---

# CV / bio content

Covers `/` (bio landing), `/cv`, and `/research` — the job-search-facing content, which is this site's primary audience per `/home/laury/Dropbox/Web/CLAUDE.md`.

## Voice

Plain, specific, no marketing register. Mathematician writing for humans: precise claims, no inflated adjectives ("passionate", "cutting-edge", "world-class"), no filler. State what was done and where; let the work speak. This is stricter than `/writing`, which is allowed a more personal register.

## Sourcing facts — don't invent

CV/bio content is a factual record (positions, papers, dates, collaborators, funding). Never fabricate or round these:
- Existing paper/talk metadata lives in `content/about.md` and `content/papersextras/` (old structure, being migrated — see `hugo-site` skill) and in `static/documents/laurabmocv.pdf` / `static/documents/BrustengaMoncusiL-thesis.pdf`.
- BibTeX sources are in `static/bibtex/`.
- If a fact (a date, a title, a coauthor, a venue) isn't already present in the repo or given directly by the user in the conversation, ask rather than guessing or inferring from context (e.g. don't infer a defense date from a thesis filename).
- Preserve existing citation formatting conventions (journal, volume/issue, pages, then BibTeX/DOI/ArXiv links) when adding new entries — see the numbered list format in `content/about.md`.

## Scope boundary

This skill is about the words and facts. For where the content lives (file paths, section structure, layouts, draft flags), see the `hugo-site` skill and `/home/laury/Dropbox/Web/CLAUDE.md`.
