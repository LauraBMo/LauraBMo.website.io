---
name: progress-sync
description: Commit and push progress.org on its own, after showing the diff and confirming. Use when progress.org has been edited and the user wants it saved to the remote, or when finishing a work session that changed it.
---

# Sync progress.org

Commits `progress.org` **alone** and pushes it, after showing what changed and getting a
yes. Never bundles other files — this is a bookkeeping commit, not a code commit.

## Steps

1. Check there is something to do:

   ```bash
   git status --short progress.org
   ```

   If it is unchanged, say so and stop. Do not create an empty commit.

2. Show the diff — the actual changed lines, not a summary:

   ```bash
   git diff progress.org        # or git diff --cached if already staged
   ```

3. Summarise in one or two lines: which headings changed state, which were added.
   Name the tasks. "Marked *Register laurabmo.com* DONE, added two items under Content"
   beats "updated progress".

4. **Ask for confirmation before committing**, using AskUserQuestion — commit and push,
   commit only, or cancel. This confirmation is required. It is what reconciles this
   skill with the standing rule in CLAUDE.md that commits and pushes happen only when
   the user says so, so never skip it or infer consent from the request that triggered
   the skill.

5. On confirmation, stage only this file and commit:

   ```bash
   git add progress.org
   git commit -m "Update progress.org: <short specific summary>"
   ```

   Keep the subject under ~65 characters and specific. No body needed.

6. Push if that is what was chosen:

   ```bash
   git push
   ```

   If the branch has no upstream, use `git push -u origin HEAD` and say which branch.

## Rules

- **Only `progress.org`.** If other files are also modified, do not stage them and do not
  offer to. Mention that they are still uncommitted and leave them alone.
- **No `--force`, no amending** a commit that is already pushed.
- If the push is rejected because the remote moved, do not force. Report it and suggest
  `git pull --rebase`.
- Do not run the Hugo build. `progress.org` sits at the repo root, outside `content/`,
  so it does not affect the site and does not need a build check.
- If the working tree is on `main`, say so before committing — this project develops on
  branches, and `main` triggers a deploy.
