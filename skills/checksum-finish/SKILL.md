---
name: checksum-finish
description: Verify, adversarially review, and deliver a completed checksum plan. Use when the checksum router selects the finish phase - every plan task is checked and the plan is still Active. Nothing is committed, pushed, or PR'd before the user's local review.
---

# Checksum: Finish

Finish is three gates in strict order: **fresh verification → review completeness →
the user's local review**. Only after all three does any git action happen. None of
the gates is skippable, whatever the task size. (Adversarial review itself runs at
the end of execute, per delivery unit — finish confirms it happened; it does not
run it.)

Require preferences and a completed plan from the `checksum` router — an Active
plan whose task files are all `done`, or for light work the approved chat plan with
every tracked task done. If a task or its evidence is incomplete, report it and
return to the router. Honor every directive in the `## finish` preferences section.
(For light work, read "the plan" below as the approved chat plan.)

**Scoped delivery mode:** execute hands single tasks here when their `deliver: pr`
flag fires (stacked PRs). Run the same gates scoped to that task — its acceptance
checks fresh, its task-scoped review record present, the user's go — then push the
stacked branch and open the PR against the previous task's branch (or the base for
the first). The full-plan finish below still runs once everything is done.

## Gate 1: Fresh verification

Evidence rules: [references/verification.md](references/verification.md).

1. Run every command in the plan's **Full Verification** section once, **after the
   final code change**. Read complete output and exit status. Old runs, partial
   runs, and "passed earlier this session" prove nothing.
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

Ask the user to review locally and say how to proceed. **No commit, push, PR,
merge, or worktree cleanup before their explicit go.** "Silence", "they seem done",
or "the prefs say commit" do not open this gate — preferences configure *what*
happens after the go, not whether the gate exists.

## Gate 4 (post-approval): Deliver

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

Set `**Status:** Complete` on the plan file (light: close out the task tracker)
only after verification passed and the approved delivery actions succeeded (a delivery failure after verified work keeps
verified evidence — report the state honestly). Report artifact paths, evidence,
commit hash or exact worktree state, and any problems.
