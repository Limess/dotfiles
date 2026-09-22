# Personal Preferences

## Workflow

- When executing a plan, do not pause between batches to ask for feedback. Continue straight through all tasks without prompting mid-progress.

## Code navigation & editing

- When the serena MCP server is connected (its tools appear in the deferred-tools list), prefer it over built-in Read/Grep for exploring code. Load its tools immediately via ToolSearch and call `initial_instructions` once per session before the first use.
- For discovery in a code file, use `get_symbols_overview` then `find_symbol` (with `include_body` only when you need the body) instead of reading whole files; use `find_referencing_symbols` to find call sites instead of grepping. This is dramatically cheaper on large files (measured ~27× fewer tokens on a 900-line file) and more targeted.
- Grep/Glob are still fine for content/name discovery; follow-up reads and reference searches should go through serena. Small files, or cases where you genuinely need the whole file, are the exception — a plain Read is fine there.
- For edits to code you've navigated with serena, use its symbolic edit tools (`replace_symbol_body`, `insert_*_symbol`, `rename_symbol`, `safe_delete_symbol`, `replace_content`).

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
- Default: do not hard-wrap prose, comments, docstrings, or markdown to a fixed column — write long lines and let the editor soft-wrap. This explicitly includes README and other documentation files you author or edit: write each paragraph and bullet as one long line, never manually broken at ~80 columns. Exception: if a configured linter/formatter enforces a line length that covers comments (e.g. ruff, `.editorconfig`), wrap to exactly that limit — never a self-chosen narrower width.

## Git
- Do not prefix branch names with `charlie/` (or any personal username). Name branches by their content instead (e.g. `npm-run-copy-silent`).
- Do not use subshells (e.g. `$(cat <<'EOF' ... EOF)`) in git commit messages. Use simple quoted strings instead.
- Never switch branches in a shared checkout. Do not run `git checkout <branch>`, `git switch`, or `git checkout -b` in the primary clone (or any directory another session may be using). Multiple Claude sessions share the same working tree and a branch switch changes their files underneath them.
- To work on a different branch, create a worktree instead and do the work there. Rebasing, cherry-picking, or checking out a PR branch counts as switching — use a worktree for those too.
- Always create and enter worktrees with the `EnterWorktree` tool, never with a manual `git worktree add`. Only `EnterWorktree` moves the session itself into the worktree, so the harness treats it as the project root: the sidebar "files changed" diff renders, relative paths resolve there, and the scratchpad/permissions apply to the right tree. A manual `git worktree add` leaves the session rooted in the original checkout — the diff panel then shows changed files and line counts but empty diffs, every path has to be an absolute one into a sibling directory, and I cannot review the change in the UI.
- If a task genuinely requires changing the branch of the primary checkout, stop and ask first.

## Security

- Do not read `.env*`, `profiles.clj`, or files under `~/.aws`, `~/.ssh`, or `~/.dbt` unless I explicitly request it.
- Do not run AWS or SSH commands except `aws sts get-caller-identity` without explicit approval.

## Agent attribution

- Anything posted on my behalf to a place other people read — GitHub PR descriptions and review comments, Slack messages, Linear tickets and comments — must be prefixed with a line marking it as agent-written, including the harness and model name when known and the 🤖 emoji. E.g. `🤖 Written by an agent (Codex, GPT-5.6).`
- The prefix goes at the top of the body, as its own line. Titles/subjects don't need it if the body has it.
- This is about honesty to human readers, so it applies even when the content is short or I dictated it closely.

## Pull Requests
- Keep PR titles and descriptions terse — a short summary and bullet points only.
- Do not include a test plan section unless the user has explicitly provided specific steps to test.
- Never open, raise, or create a pull request unless the current message explicitly asks for it — no exceptions. Adding a helper, fixing a comment, or finishing a task is NOT authorization to open a PR for it.
- Do not push, create PRs, or take other shared-state actions unless explicitly asked in the current turn. Don't infer authorization from earlier turns in the conversation (e.g. "I raised a PR last time" is not standing permission to do it again). Commit locally and stop; wait for the user to ask for the push/PR.
- When addressing PR comments, always reply to and resolve the review threads from automated reviewers that leave inline comments (e.g. CodeRabbit, Greptile) — one reply per thread saying how it was addressed (or why it was disregarded), then resolve it. For human reviewers, handle threads case by case: don't auto-resolve, and ask or leave them for me, since I may prefer to reply directly.
