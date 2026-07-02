# Personal Preferences

## Workflow

- When executing a plan, do not pause between batches to ask for feedback. Continue straight through all tasks without prompting mid-progress.

## Code Style
- Avoid unnecessary line breaks in comments, docstrings, or markdown unless enforced by a linter. Do not hard-wrap prose to a fixed width — modern editors handle wrapping appropriately, so write comments and prose as long lines and let the editor make them readable.

## Git
- Do not use subshells (e.g. `$(cat <<'EOF' ... EOF)`) in git commit messages. Use simple quoted strings instead.

## Pull Requests
- Keep PR titles and descriptions terse — a short summary and bullet points only.
- Do not include a test plan section unless the user has explicitly provided specific steps to test.
- Do not push, create PRs, or take other shared-state actions unless explicitly asked in the current turn. Don't infer authorization from earlier turns in the conversation (e.g. "I raised a PR last time" is not standing permission to do it again). Commit locally and stop; wait for the user to ask for the push/PR.

@RTK.md
