# Personal Preferences

## Workflow

- When executing a plan, do not pause between batches to ask for feedback. Continue straight through all tasks without prompting mid-progress.

## Subagent model selection

Leave the Agent `model` unset by default, so the subagent uses the parent's model or the agent type's own. Never override an agent type's own model. Step down only when a wrong answer would be easy to spot, and when torn between Haiku and Sonnet, pick Sonnet:

- **Haiku**: work with nothing to decide, whose output is a list, path, count or rows the parent can check at a glance. Examples: running a query the parent supplies, targeted lookups such as "where is X defined" or "which files use Y", file renames, format conversions.
- **Sonnet**: scoped work producing an explanation or finding that the parent will check before building on it. Examples: code exploration that traces how pieces connect, data investigations where the subagent writes its own log, metric or SQL queries, and implementing fully specified work, with files, interfaces, behaviour and tests all decided. The brief tells the subagent to stop and report back if it hits anything the instructions don't cover. The parent reviews the diff before committing.
- **Parent's model** (leave `model` unset): anything that produces a decision or design that won't get a second look.

Haiku's savings matter when a subagent runs many times or reads a lot; on a one-off task a confidently wrong answer costs more than the difference.

Run a query inline when its output is small. Delegate when the output is bulky.

Every data brief asks for the exact query, the time window, row counts and a results link where the tool gives one, with findings kept separate from interpretation. When the parent's conclusion depends on the data, the brief asks for the rows, not a summary. Row sets too large to return go to a scratchpad file, and the subagent returns the path.

End every Agent `description` with the model and a short reason, e.g. `(Haiku: runs the parent's query)` or `(Fable: design tradeoffs)`.

## Code navigation & editing

- When the serena MCP server is connected (its tools appear in the deferred-tools list), prefer it over built-in Read/Grep for exploring code. Load its tools immediately via ToolSearch and call `initial_instructions` once per session before the first use.
- For discovery in a code file, use `get_symbols_overview` then `find_symbol` (with `include_body` only when you need the body) instead of reading whole files; use `find_referencing_symbols` to find call sites instead of grepping. This is dramatically cheaper on large files (measured ~27× fewer tokens on a 900-line file) and more targeted.
- Prefer serena where it saves real reading, such as large files and finding call sites. Grep/Glob are fine for content and name discovery, and a plain Read or grep is fine when it is quicker, such as for small files or when you need the whole file.
- For edits to code you've navigated with serena, use its symbolic edit tools (`replace_symbol_body`, `insert_*_symbol`, `rename_symbol`, `safe_delete_symbol`, `replace_content`).
- Serena's project root is fixed when the session starts (`--project-from-cwd`) and does not follow `EnterWorktree`. If the session has moved into a worktree since startup, or Serena's paths otherwise resolve outside the current worktree, do not use Serena's edit tools, because they would modify the other checkout. Use the built-in tools with worktree paths instead, and tell me that Serena is rooted elsewhere.

## Code Style

### Names carry the intent
- Prefer names that state intent and the rule they encode over a comment that explains them. A reader should get the why from the function, variable and test names alone.
- Name booleans and conditions after the rule they test, and pull a non-obvious condition into a named const rather than commenting it: `const noAliasLeftOnTicket = …`, `const latestIsSharedSession = slug === undefined`, `if (stoppedTriggerSessionsAreNeverResumed)`, not a bare `if (x && y)` under a `// trigger sessions are never resumed` comment.
- Put ordering, scope and qualifiers in the name when they are part of the contract: `sessionsNewestFirst`, `liveOrQueued`, `lowercasedAssignees`, `changedByThisEvent`, `TicketStateAfterEvent`, `acceptLinearDeliveryUnderTicketLock`, `MAX_TRIGGER_SLUG_WITHIN_SESSION_ID_LIMIT`.
- Name what a value means, not its mechanism: `changedByPerson` over `human`, `nothingHoldsSharedSession` over `sharedCleared`, `triggerTakenAwayByThisEvent` over `takenAway`, `recordDeliveryNeedingNoWork` over `recordHandled`.
- Write test names as the full rule including its reason or edge case, e.g. `"stops a label session when its label is removed, even by the agent itself as its last step"` or `"compares exact status names, so a status that shortens to the same session name still stops the session"`.
- Long names are fine. Don't trade clarity for brevity, but don't restate the type or the enclosing module either.

### Comments
- Comment only non-obvious *why*: intent, constraints, gotchas, invariants, links to context. Don't restate what the code does (`// increment counter`), echo a name, or teach language basics — prefer clear names and small functions over such comments.
- A docstring that paraphrases the function name and signature is redundant, even when it reads as helpful prose. Examples to delete:
  - `/** The meter evidence in a hybrid inverter's real-time reading. */` on `hybridGridMeterEvidence(psKey, response)`
  - `/** Build a Meter response from the grid readings of the smart meter wired to a hybrid inverter. */` on `buildHybridGridMeter(response, timezone): Meter`
  - `/** Read a meter asset backed by an iHomeManager's grid metering channel. */` on `getHomeEnergyManagerGridMeter(auth, info)`

  Keep only the part a reader couldn't get from the name, e.g. `/** Live power is left out: the iHomeManager's power point reads 0 on some sites while the counters move. */`
- Do keep comments that save a reader real effort: tricky algorithms, non-obvious regexes, workarounds for external bugs/quirks, units and invariants.
- Write comments and docstrings as if explaining to a PM: plain declarative sentences, shorthand and internal symbols expanded into what they mean, no terse fragments or jargon chains.
- Before finishing a change, check every comment you added against the code and tests: delete any that restates the code, repeats what a name or test already makes clear, or duplicates a comment elsewhere (keep it once, where the constraint is enforced).
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
- To work on a different branch, create a worktree instead and do the work there. Rebasing, cherry-picking, or checking out a PR branch counts as switching — use a worktree for those too. Inside a worktree this session created, switching branches and rebasing are fine: the rule protects checkouts other sessions use.
- Always create and enter worktrees with the `EnterWorktree` tool, never with a manual `git worktree add`. Only `EnterWorktree` moves the session itself into the worktree, so the harness treats it as the project root: the sidebar "files changed" diff renders, relative paths resolve there, and the scratchpad/permissions apply to the right tree. A manual `git worktree add` leaves the session rooted in the original checkout — the diff panel then shows changed files and line counts but empty diffs, every path has to be an absolute one into a sibling directory, and I cannot review the change in the UI.
- If a task genuinely requires changing the branch of the primary checkout, stop and ask first.

## Security

- Do not read `.env*`, `profiles.clj`, or files under `~/.aws`, `~/.ssh`, or `~/.dbt` unless I explicitly request it.
- Do not run AWS or SSH commands except `aws sts get-caller-identity` without explicit approval.
- Before reading credentials from 1Password with `op`, including indirectly through a script that calls `op` (for example a vendor `docs:refresh` that loads a portal login), tell me in the same message: which `op` operations will run, which items or credentials they fetch (vault and item names or IDs, never the values), how many reads to expect, and why each is needed. Every read shows me an approval prompt, so batch them and don't repeat reads. This applies to subagents too: put the same rule in their brief and pass their list of `op` operations on to me.

## Agent attribution

- Anything posted on my behalf to a place other people read — GitHub PR descriptions and review comments, Slack messages, Linear tickets and comments — must be prefixed with a line marking it as agent-written, including the harness and model name when known and the 🤖 emoji. E.g. `🤖 Written by an agent (Codex, GPT-5.6).`
- The prefix goes at the top of the body, as its own line. Titles/subjects don't need it if the body has it.
- This is about honesty to human readers, so it applies even when the content is short or I dictated it closely.

## Pull Requests
- Use the repo's PR template when it has one, keeping each section terse; otherwise keep PR titles and descriptions to a short summary and bullet points.
- Do not include a test plan section unless the user has explicitly provided specific steps to test.
- Open a PR when my request implies one, read in the context of the conversation: asking to raise, ship, land or merge a change; a follow-up change to work we have been putting up as PRs in this conversation; or a terse reply such as "pr", "open it", or a typo of one. Don't open one for exploratory or local-only work (a spike, a question, "try X", "just locally"). When it is genuinely unclear, push the branch and ask in one line.
- Pushing a branch never needs asking. Permission I give for a piece of work holds until that work is done: "merge it when ready" covers that PR through review and the merge queue. It does not carry over to unrelated tasks or to later sessions.
- When addressing PR comments, always reply to and resolve the review threads from automated reviewers that leave inline comments (e.g. CodeRabbit, Greptile) — one reply per thread saying how it was addressed (or why it was disregarded), then resolve it. For human reviewers, handle threads case by case: don't auto-resolve, and ask or leave them for me, since I may prefer to reply directly.
- When fixing review findings, fix without asking those the PR introduced, regressions from our own earlier fixes, and critical issues even when pre-existing (wrong data published, a failing poll or command, a security problem). For anything else, such as pre-existing findings on main or low-impact ones, list them back to me with a one-line impact each and get my approval before fixing them in the PR.
- Exception: comments I (Charlie, GitHub user `Limess`) leave on a PR myself are instructions for you. When I ask you to review PR comments or changes, address each of mine like a bot thread: make the change (or explain why not), reply, and resolve it.
- Agents post under my GitHub account too, so the agent marker is what tells my own comments apart: a comment from `Limess` without the 🤖 agent-written line is from me. Treat it as an instruction for the agent that owns the PR to address or fix, without waiting to be asked, unless it is obviously a reply to a human or clearly just an observation with nothing to act on or fix. A `Limess` comment that carries the agent marker was written by an agent and is not an instruction.
