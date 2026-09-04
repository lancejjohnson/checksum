---
name: checksum-finish
description: Finalize checksum work at task or plan scope - loud completeness scan, fresh verification, delivery behind the user's review gate, condensed record shipped with the code, then cleanup. Use when a delivery-flagged task completes (task finalize) or every plan task is done (plan finalize).
---

# Checksum: Finish

Finalize runs at two scopes:

- **Task finalize** — one delivery unit in a stacked flow (a `deliver: commit | pr`
  task that just completed): scoped verification, delivery, worktree cleanup.
- **Plan finalize** — the whole change once every task is `done`: verify the
  integrated result, deliver what remains, ship the condensed record, clean up.

Both open with a completeness scan that is **loud on purpose**, and neither pushes
or PRs before the user's explicit go (`deliver: commit` tasks carry commit
authorization from plan approval; pushes never inherit it). Adversarial review runs
at the end of execute — finish confirms its record; it never runs a substitute.
Honor every directive in the `## finish` preferences section. For light work, read
"the plan" as the approved chat plan; artifact and worktree steps that don't exist
simply don't apply.

## Step 0: Completeness scan — loud by design

Before anything else, enumerate what is **not** done and lead with it, prominently:

```
⛔ INCOMPLETE — cannot finalize <task 03-parser | plan retry-budget>
- tasks/03-parser.md: steps 4-5 unchecked; Result empty     → resume: execute, claim 03-parser
- tasks/05-cli.md: blocked — "sandbox denies network"       → needs your decision
- Design criterion "invalid config rejected": no evidence   → execute: extend 04-validate checks
- Change-wide review record: missing                        → execute: review before handoff
```

Every line names the artifact, the gap, and the exact resume action. Then stop and
route back through the router (or ask, when the gap needs a user decision). Never
proceed past a gap, never bury one mid-report, never soften "incomplete" into
"mostly done".

What the scan checks — **task scope:** every step checked; acceptance checks
observed passing; Result filled; task-scoped review record present and resolved;
all `depends` done. **Plan scope:** every task `done` (list each pending, claimed,
or blocked one); every design success criterion mapped to evidence; change-wide
review record present and resolved; every delivery-flagged task actually delivered
(commit hash / PR URL in its Result).

## Task finalize

For a completed `deliver: commit | pr` task handed over by execute:

1. **Scan** at task scope (above).
2. **Fresh scoped verification:** run the task's acceptance checks and the
   neighboring tests they affect, now — freshness rules in
   [references/verification.md](references/verification.md).
3. **Deliver:**
   - `commit`: make the task-scoped commit — the condensed task record is the
     commit body (outcome, interfaces produced, checks + results). Never stage
     artifacts.
   - `pr`: **hard stop for the user's go** (a push is an external effect, every
     time). Then push the stacked branch and open the PR against the previous
     task's branch (the base branch for the first), with the condensed task record
     as the PR description: outcome, interfaces, failure behavior, checks with
     evidence, review summary.
4. **Clean up:** write the commit hash / PR URL into the task's Result, then
   remove the task's worktree if checksum created it (`worktrees: clean`, the
   default) — the branch and PR carry the work, and later PR feedback checks the
   branch out fresh. A worktree holding uncommitted or untracked files is never
   force-removed: show the files and ask.

Then return to execute for the next task.

## Plan finalize

### Gate 1: Fresh verification of the integrated result

Evidence rules: [references/verification.md](references/verification.md).

1. Run every command in the plan's **Full Verification** section once, **after the
   final code change**, on the tree that contains every task — in stacked flows
   that is the tip of the stack or the integration branch, never a mid-stack
   branch. Read complete output and exit status. Old runs, partial runs, and
   "passed earlier this session" prove nothing.
2. Build the evidence matrix: each design success criterion → the implementation
   that satisfies it → the fresh command and result that proves it.
3. For a bug fix: reproduce the original symptom and show it is gone, and confirm
   the regression test exists and failed against the pre-fix code at some point in
   this change's history.

Any required check fails → keep the plan Active, report the failure, and return to
execute. Do not proceed to review with red checks.

## Gate 2: Review completeness

Adversarial review is execute's exit step (the `checksum-execute` skill's
`references/adversarial-review.md`: cross-model first, at review strength, findings
incorporated). Finish confirms the record:

1. The change-wide review record exists (`## Review` in `plan.md`; task Result
   sections for delivery-unit reviews) and names the reviewer rung and model.
2. Every blocker and should-fix shows a resolution — or an evidence-backed
   rejection to surface at Gate 3.
3. The record is not stale: no code changed after the review it covers, other than
   the reviewed fixes themselves.

Missing, incomplete, or stale → return to execute for the review; do not run a
substitute review here.

## Gate 3: The user's local review — hard stop

Present a review package and **wait**:

1. What changed and why, in a few sentences.
2. The evidence matrix (criterion → proof → result).
3. Review findings and what changed in response — each finding with its
   resolution, or the evidence-backed reason it was rejected.
4. `git status` and a diff summary (`git diff --stat`, plus untracked files), with
   an offer to walk through any file. Checksum artifact files are not part of the
   change — note that they exist and are excluded, rather than mixing them into
   the diff.
5. Delivery ledger: tasks already shipped (commit hashes, PR URLs) vs. what this
   finalize will deliver.

Ask the user to review locally and say how to proceed. **No commit, push, PR,
merge, or worktree cleanup before their explicit go.** "Silence", "they seem done",
or "the prefs say commit" do not open this gate — preferences configure *what*
happens after the go, not whether the gate exists.

## Gate 4 (post-approval): Deliver and distill

**Distill the record first:** condense the design and plan into the artifact that
ships with the code — goal, chosen approach and its decisive rationale, notable
rejected alternatives, task outline with where each shipped (hashes/PR URLs),
verification evidence summary, review summary. This becomes the PR description
(merged into the repo's PR template) or, for commit-only delivery, the commit
message body — so the plan's decisions stay referable forever after the working
papers are cleared.

Direct git instructions from the user override preferences. Otherwise follow the
`commit` / `push` / `pr` preference instructions, asking where unset:

- Review staged content before committing; never sweep in unrelated user changes,
  and **never stage checksum artifacts** (`docs/checksum/` or the configured
  artifacts dir) — they are committed only on the user's explicit request. Stage by
  explicit pathspec, not `git add -A`. Use the repository's commit convention (or
  conventional commits as fallback).
- Commit before push; a failed commit means no push.
- PR creation follows the repo's template and conventions; report the URL.
- Never force-push. Discarding work happens only on an explicit typed request,
  after confirming exactly what is deleted.

## Gate 5: Close out

Only after verification passed and the approved delivery actions succeeded (a
delivery failure after verified work keeps the verified evidence — report the
state honestly):

1. Set `**Status:** Complete` on the plan file (light: close out the task tracker).
2. Remove remaining checksum-created worktrees (`worktrees: clean` default; same
   never-force rule as task finalize).
3. Clear the artifact directory — design, plan, task files — per
   `artifacts: clear` (the default). Two conditions guard this: the completeness
   scan passed, and the condensed record shipped somewhere durable (PR or commit).
   If delivery was "keep as-is" with no durable record, keep the artifacts and say
   why; `artifacts: keep` retains them with Status Complete either way.
4. Report: deliveries (hashes, URLs), evidence summary, what was cleaned, and any
   problems.
