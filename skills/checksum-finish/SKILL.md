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

Both open with a completeness scan that is **loud on purpose**, and neither delivers
anything before the user's explicit local-review go. A `deliver` flag records the
intended boundary, not authorization. Adversarial review runs at the end of execute
— finish confirms its record; it never runs a substitute. Honor every directive in
the `## finish` preferences section. For light work, read "the plan" as the approved
chat plan; artifact and worktree steps apply only when a retained diagnosis or
checksum-created worktree actually exists.

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

What the scan checks:

- **Task scope:** every step checked; acceptance checks observed passing; Result
  filled; task-scoped review record present and resolved; all `depends` done. For a
  permanent defect fix, the regression condition was observed failing against
  broken behavior and its command plus failing result are recorded, or its approved
  `### Reproduction exception` and passing proxy check are present. For
  containment, the suppression check was observed failing before containment and
  passing after it.
- **Plan scope:** every task `done` (list each pending, claimed, or blocked one);
  every design success criterion mapped to evidence; change-wide review record
  present and resolved; every delivery-flagged task actually delivered (commit hash
  / PR URL in its Result). A task explicitly changed to `deliver: plan` is part of
  plan delivery instead. An isolated task still pending granular delivery remains
  incomplete and pauses plan finalize.
- **Active containment at either scope:** risk, rollback, monitoring, removal
  condition, explicit owner, and a durable follow-up outside the current plan's
  completion set.
- **Unconfirmed-cause correction at either scope:** residual risk, rollback,
  falsifying/monitoring signal, explicit owner, and durable follow-up outside the
  current plan's completion set.
- **Blocked-reproduction exception at either scope:** exact blocker, strongest
  proxy check, residual risk, and explicit user-acceptance reference.

Missing fields block task or plan finalize. Neither scope can close active
containment or an unconfirmed-cause correction unless user acceptance is captured
in the diagnosis/approved plan and the intended shipped record includes a
resolvable durable follow-up: an external issue/ticket URL or identifier, or a
stable heading in a committed project tracking file outside the checksum artifacts
directory. For an open diagnosis, that follow-up must contain its current evidence,
confidence, next investigation signal, and operational-risk block. A
blocked-reproduction exception instead requires its own explicit acceptance
reference; it does not require a follow-up. Gate 3 presents the acceptance for
confirmation. A missing or stale follow-up is incomplete: ask before creating or
updating an external tracker item, or return to plan/execute to add and review an
in-repo tracking entry, then rerun the scan. If the user chooses keep-as-is at Gate
3, only an already populated external tracker can be the permanent risk record;
otherwise report that no durable code record shipped and retain the artifact or
light task-tracker state without closing the operational state.

## Task finalize

For a completed `deliver: commit | pr` task handed over by execute:

1. **Scan** at task scope (above).
2. **Fresh scoped verification:** run the task's acceptance checks and the
   neighboring tests they affect, now — freshness rules in
   [references/verification.md](references/verification.md).
3. **Local review — hard stop:** present the task-scoped form of the Gate 3 package
   (outcome, evidence, review resolutions, operational risk, status/diff, intended
   delivery) and wait for explicit user approval. No commit, push, PR, or worktree
   cleanup before the go. A no-go does not force delivery: offer to pause with the
   task still pending delivery, revise the work, or explicitly change `deliver` to
   `plan` so it rolls into plan finalize **only when its changes already live in the
   integration tree**. Isolated branch/worktree changes cannot be deferred into plan
   delivery without moving them: leave that delivery pending, preserve and report
   the worktree path, branch, and status, and pause. Record the choice in Result;
   changing scope, dependencies, or behavior still returns the plan to Draft for
   approval.
4. **Deliver:**
   - `commit`: make the task-scoped commit — the condensed task record is the
     commit body (outcome, interfaces produced, checks + results, review summary,
     observed-red or suppression-check evidence for defects, and any containment,
     unconfirmed-cause correction, or blocked-reproduction exception with every
     field required by Step 0). Never stage artifacts.
   - `pr`: push the stacked branch and open the PR against the previous task's
     branch (the base branch for the first), with the condensed task record as the
     PR description: outcome, interfaces, failure behavior, checks with evidence,
     review summary, defect red/suppression evidence, and the same Step 0
     operational-risk record when applicable.
5. **Clean up:** write the commit hash / PR URL into the task's Result, then
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
3. For a permanent bug fix: reproduce the original symptom and show it is gone,
   confirm the regression test exists, and cite its recorded command and failing
   pre-fix result. If the user explicitly accepted a blocked-reproduction exception,
   run the approved proxy check instead and carry the blocker and residual risk into
   the evidence matrix; do not describe it as observed-red.
4. For containment: run the suppression check and label its passing evidence as
   symptom suppression, not correction. Do not claim it satisfies the permanent
   regression condition.

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
4. Any active containment, unconfirmed-cause correction, or blocked-reproduction
   exception, including the fields its Step 0 rule requires.
5. `git status` and a diff summary (`git diff --stat`, plus untracked files), with
   an offer to walk through any file. Checksum artifact files are not part of the
   change — note that they exist and are excluded, rather than mixing them into
   the diff.
6. Delivery ledger: tasks already shipped (commit hashes, PR URLs) vs. what this
   finalize will deliver.

Ask the user to review locally and say how to proceed. **No commit, push, PR,
merge, or worktree cleanup before their explicit go.** "Silence", "they seem done",
or "the prefs say commit" do not open this gate — preferences configure *what*
happens after the go, not whether the gate exists.

## Gate 4 (post-approval): Deliver and distill

**Distill the record first:** condense the design and plan into the artifact that
ships with the code — goal, chosen approach and its decisive rationale, notable
rejected alternatives, task outline with where each shipped (hashes/PR URLs),
verification evidence summary, review summary, and any accepted containment with
its owner and removal follow-up, or unconfirmed-cause correction with its residual
risk and follow-up, or blocked-reproduction exception with its blocker, proxy
check, and residual risk. For permanent defect fixes, include the observed-red
command and failing result; for containment, include the suppression-check evidence.
If diagnosis remains open, confirm Step 0 already verified that the durable
follow-up contains its current evidence, confidence, and next investigation signal.
This becomes the PR description
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
3. Clear the artifact directory — diagnosis, design, plan, and task files — per
   `artifacts: clear` (the default). Two conditions guard this: the completeness
   scan passed, and the condensed record shipped somewhere durable (PR or commit).
   If delivery was "keep as-is" with no durable record, keep the artifacts and say
   why; `artifacts: keep` retains them with Status Complete either way.
4. Report: deliveries (hashes, URLs), evidence summary, what was cleaned, and any
   problems.
