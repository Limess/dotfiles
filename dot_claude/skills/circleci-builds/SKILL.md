---
name: circleci-builds
description: Inspect, watch, and debug CircleCI builds (runs/workflows/jobs) for the current project using the circleci CLI. Use when checking CI status, investigating a failed build, fetching job logs/artifacts/test results, watching a run after a push, or rerunning/triggering workflows. Not for orbs, config validation, contexts, or other CircleCI management.
---

# CircleCI CLI

The `circleci` CLI infers the project from the current repo's git remote and the branch from the checkout, so inside a project directory most commands need no arguments. Override with `--project gh/org/repo` and `--branch <name>` (with `--project`, branch defaults to `main`, not the local checkout).

## ID hierarchy

Run (a trigger firing) → workflows → jobs → steps. Each level's IDs appear in the level above's output:

- `circleci run list` / `run get` → run IDs
- `circleci run get` → workflow IDs and job IDs (`--json` includes both)
- `circleci job get <job-id>` → numbered steps

## Status checks

```bash
circleci run get                 # latest run on current branch: workflows, jobs, statuses
circleci run get --json          # same, machine-readable
circleci run get <run-id>        # specific run
circleci run list                # recent runs (all branches); -B for current branch only
circleci run list --limit 20    # max is 20 — higher values fail with "Invalid page size"
```

JSON fields for `run get`: `id, phase, outcome, current_outcome, branch, tag, revision, created_at, errors[], workflows[].id/name/phase/outcome/duration/jobs[].id/name/phase/outcome/type`.

## Debugging a failed build

1. Find the failing job (jobs still running have no `outcome` yet, so match `failed` explicitly rather than excluding `succeeded`):
   ```bash
   circleci run get --json --jq '[.workflows[].jobs[]] | unique_by(.id) | .[] | select(.outcome == "failed") | {name, outcome, id}'
   ```
   (`unique_by(.id)` dedupes jobs — the API sometimes returns the same workflow twice, repeating its jobs.)
2. Get its steps with exit codes and durations:
   ```bash
   circleci job get <job-id>
   ```
3. Fetch output for the failed step (step numbers from step 2; they are sparse, e.g. 0, 1, 99, 101…):
   ```bash
   circleci job output get <job-id> --step-num <n>          # full output of one step
   circleci job output list <job-id>                        # all steps, but only the LAST 200 lines of each
   circleci job output list <job-id> --tail 0               # all steps, full output (can be very long)
   ```
   Piped output is auto-rendered to plain text (ANSI stripped, progress redraws collapsed). `--execution <i>` selects the executor for parallel jobs.
4. Test failures (requires the job to use `store_test_results`) — often the fastest route to the cause, since `testresult get` includes the full failure message/traceback:
   ```bash
   circleci testresult list <job-id>              # failed tests only (default); --all for pass/skip too
   circleci testresult get <job-id> <test-name>   # full message + traceback for one test
   ```
5. Artifacts (e.g. coverage reports):
   ```bash
   circleci job artifact <job-id>                       # list
   circleci job artifact <job-id> --output ./artifacts  # download
   ```

## Watching a run (e.g. after push)

```bash
circleci run watch                    # latest run on current branch, blocks until done
circleci run watch --sha <sha>        # polls up to 2m for the run to appear — use right after git push
circleci run watch --failfast         # exit as soon as any job fails
```

Exit codes: 0 succeeded, 1 failed, 5 run not found (`--sha` poll expired), 6 cancelled, 8 timed out (default timeout 30m, `--timeout`).

The `--sha` discovery poll is hard-coded at 2m and runs regularly take longer than that to appear after a push (webhook/queueing delay), so exit 5 usually means "not there yet", not "won't exist". Retry on exit 5 only, so real outcomes (1/6/8) propagate:

```bash
for i in 1 2 3 4 5; do
  circleci run watch --sha "$sha" -q; rc=$?
  [ "$rc" -ne 5 ] && exit "$rc"
done
exit 5    # still not found after ~10m — check the push actually triggered a run
```

Alternatively, wait for the run to show up in `run list -B` (its `id`, matched by `revision`), then `circleci run watch <run-id>` — watching by ID has no discovery window.

## Mutating commands (confirm with the user before running)

```bash
circleci workflow rerun <workflow-id>                # rerun all jobs
circleci workflow rerun <workflow-id> --from-failed  # rerun only failed jobs
circleci run trigger [--branch main] [--parameter key=value]
circleci run cancel <run-id>
circleci workflow cancel <workflow-id>
```

## Older runs: the REST API escape hatch

`run list` only covers recent runs — for a project that hasn't built lately it returns "No runs found" even though pipelines exist. A run ID is a pipeline ID (same UUID), so find older pipeline IDs via the REST API and pass them to `run get`:

```bash
circleci api api/v2/project/gh/org/repo/pipeline --jq '.items[:10][] | {id, created_at, branch: .vcs.branch}'
circleci run get <run-id>
```

`circleci api <path>` is authenticated automatically; paths are relative to `/api/v3`, so prefix `api/v2/...` explicitly for v2 endpoints. `circleci project get` (run in the repo) shows the project slug, ID, and default branch.

## Scripting gotchas

- On `run`/`job`/`workflow`/`testresult` commands, `--jq` only works together with `--json`; alone it is silently ignored and you get markdown. `circleci api` is the exception: it has no `--json` flag (JSON is its only output) and `--jq` works by itself.
- `--jq` is built in — the `jq` binary is not needed.
- Add `-q` to suppress informational stderr lines (e.g. "Fetching latest run…") when capturing output.
- Errors come back as JSON on stdout with `"error": true` even with `--json` — check for that key, not just exit code, when parsing.
- Human-readable output is markdown with emoji shortcodes (`:white_check_mark:`); prefer `--json` for anything programmatic.
- `circleci run open` / `job open` / `workflow open` open the browser — useless in headless sessions; print the URL from `job get` instead.
