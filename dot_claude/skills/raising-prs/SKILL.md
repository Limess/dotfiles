---
name: raising-prs
description: Write succinct pull request descriptions covering the problem, root cause, the logical change, and the Linear ticket — without describing code changes in depth. Fills in the repo's own PR template when it has one. Use when raising, opening, or drafting a PR, or when writing or revising a PR description or body.
---

# Raising PRs

The diff already shows the code, and the Linear ticket already states the problem. A PR description exists to tell a reviewer **what we did, logically** — enough to judge whether the approach is right before reading a line.

Be succinct. Each section is a sentence or two, not a paragraph block.

## The repo's PR template comes first

Before writing, look for the repo's PR template: `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, a `.github/PULL_REQUEST_TEMPLATE/` folder, `docs/pull_request_template.md`, or `pull_request_template.md` at the root (any letter case). When one exists:

- Fill in the template. Its sections, their order, its labels and its length limits replace the **Structure** below. Do not add sections the template lacks.
- Keep fields that automations read exactly as the template writes them, e.g. vendor-service's `## Expected outcome` with its `Metric`, `Baseline`, `Expected` and `Verify` lines. Post-merge jobs and merge gates parse them, so a reworded label or a moved value silently drops the PR out of those checks.
- Follow any style guide the template links to, and the template's own instructions about its comments (some want instructional comments removed, some want metadata comments kept).
- Where the template or its guide conflicts with a rule below, the template wins. The rules below still apply wherever the template leaves room: be succinct, don't narrate the investigation, don't restate the ticket.
- Put the ticket where the template puts links (e.g. a `Context:` line). Add the closing `Fixes <TICKET>` line only when the template has no place for it.

Use the **Structure** below only when the repo has no PR template.

## Structure

Use `##` sections, in this order:

```markdown
## Problem

One or two lines. The ticket covers it; do not restate it at length — just enough that the PR stands alone in a review queue.

## Root cause

Include this section only when we actually found one. It is the part the ticket usually cannot contain, so it earns its space. Also use it to flag that the problem turned out to differ from what the ticket described, since the reviewer arrives holding the ticket's version.

## Change

The behaviour that differs now and why that fixes the cause. Use the system's concepts (timestamps, polling, caching, auth), not its syntax.

## Expected impact

Optional. The observable outcome a reviewer can verify after deploy — cadence, volume, error rate.
```

Close with `Fixes <TICKET>` on its own line, outside any section — e.g. `Fixes HE-3122`. Bare ticket ID.

Drop any section that has nothing real to say. A PR with only **Problem** and **Change** is fine.

## Do not

- **Do not describe code changes in depth.** No `file.ts:123` references, no function names, no quoted snippets, no per-file walkthrough. If a reviewer needs that, they read the diff.
- **Do not re-litigate the problem** the ticket already documented — no restated metrics, evidence, or background. Link and move on.
- **Do not include a test plan** unless the user gave specific steps to test.
- **Do not restate the title** as the first line of the body.
- **Do not narrate the investigation** — what you tried, what you ruled out, which agent found what. The conclusion is the deliverable; the root cause is part of the conclusion, the path to it is not.

## Formatting

Any code location, class, function, field, or variable name that does appear (system-concept terms used per the **Change** section's own rule, not the file/function references banned above) is wrapped in backticks — e.g. `config.lastUpdated`, `ProblemError`, `startTime`.

## Title

Follow the repo's title rule when its CLAUDE.md, AGENTS.md or PR template sets one. Otherwise use the scoped format: `[package-name] <what you changed>`. One package — the one with the most relevant change. Never the `@enode/` prefix.

## Before pushing

Only push or open a PR when the user asks in the current turn. Approval on a previous PR is not standing permission.

## Example

Title: `[sungrow] Stop stamping battery config.lastUpdated from telemetry`

```markdown
## Problem

Sungrow batteries were permanently fast-polling at 2 min instead of 7.

## Root cause

We reported the device's telemetry sample time as the battery `config.lastUpdated` time. Downstream that reads as "the config just changed", re-arming the fast-poll window on every poll so it never expired.

## Change

`config.lastUpdated` is now left unset, so the consumer synthesizes one only when the operation mode actually changes — a permanently-open window becomes a real post-change one.

## Expected impact

Cadence returns to ~7 min, partnership call volume drops ~26%, 429 rate to near zero.

Fixes HE-3122
```

Note what is absent: no filenames, no function names, no restated quota metrics from the ticket. Root cause gets the most space because it is the one thing the ticket could not already say.
