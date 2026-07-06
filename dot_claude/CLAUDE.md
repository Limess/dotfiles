# Personal Preferences

## Workflow

- When executing a plan, do not pause between batches to ask for feedback. Continue straight through all tasks without prompting mid-progress.

## Code Style

### Comments
- Comment only non-obvious *why*: intent, constraints, gotchas, invariants, links to context. Don't restate what the code does (`// increment counter`), echo a name, or teach language basics — prefer clear names and small functions over such comments.
- Do keep comments that save a reader real effort: tricky algorithms, non-obvious regexes, workarounds for external bugs/quirks, units and invariants.
- These rules govern comments *you write*. Leave existing comments alone in code you're editing for other reasons — only remove or rewrite one if it's wrong, stale, or on a line you're already changing.

### Docstrings
- Follow the project's existing docstring convention (e.g. Google/NumPy/JSDoc) where one is in consistent use. Keep them terse — one line for simple functions; document params/returns/raises/side-effects only where the contract isn't obvious from the signature. Don't pad, and don't truncate accuracy to hit "terse".

### Don't narrate edits
- Comments and code describe the code as it is *now*, not the edit, task, or conversation that produced it. Never write `// now uses X`, `// changed to Y`, `// fixed per review`, `// as requested` — diff commentary belongs in the commit message. This applies to names too: no `New`/`Old`/`V2` suffixes that encode change history. Never leave commented-out code as a record of what was there before.
- Rationale about the code as it stands is fine (that's the "why" above). References to *past* behaviour or prior decisions need a durable, citable source — an ADR, an issue/ticket, or specific prior git history — cited explicitly.

### Line wrapping
- Default: do not hard-wrap prose, comments, docstrings, or markdown to a fixed column — write long lines and let the editor soft-wrap. Exception: if a configured linter/formatter enforces a line length that covers comments (e.g. ruff, `.editorconfig`), wrap to exactly that limit — never a self-chosen narrower width.

## Git
- Do not use subshells (e.g. `$(cat <<'EOF' ... EOF)`) in git commit messages. Use simple quoted strings instead.

## Pull Requests
- Keep PR titles and descriptions terse — a short summary and bullet points only.
- Do not include a test plan section unless the user has explicitly provided specific steps to test.
- Do not push, create PRs, or take other shared-state actions unless explicitly asked in the current turn. Don't infer authorization from earlier turns in the conversation (e.g. "I raised a PR last time" is not standing permission to do it again). Commit locally and stop; wait for the user to ask for the push/PR.

@RTK.md
