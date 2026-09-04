---
name: checksum-plan
description: Write or revise a checksum implementation plan from an approved design. Use when the checksum router selects the plan phase - the design is Approved and no current plan exists.
---

# Checksum: Plan

The plan translates an approved design into tasks an implementer can execute with
**zero conversation context** — a future session, a subagent, or the user's teammate.
Everything they need lives in the plan or the design it links to.

A plan **file** is a full-weight artifact. For light-weight work the same ceremony
runs in chat — see "Chat plans" at the end — and this skill's shaping and
acceptance-check rules apply unchanged.

Require preferences, a slug, and an Approved design from the `checksum` router.
If the design is missing or stale, return to the router. Honor every directive in
the `## plan` preferences section.

## Shape the work

Before writing tasks, read the code paths the design touches and decide:

- File responsibilities: which files are created or modified, and what each owns.
- Interfaces between tasks: exact names, signatures, and types that later tasks
  consume from earlier ones.
- Task boundaries: a task is the smallest unit with an independently verifiable
  outcome. Fold setup and scaffolding into the task that needs them; split only
  where a reviewer could reject one task while accepting its neighbor.
- Order: prefer a sequence where the system builds up working and testable at every
  step, not big-bang integration at the end.

Plan the smallest solution that satisfies the design. No unrequested abstractions,
no future scaffolding, no drive-by refactors that the design didn't call for.

## Acceptance checks are the heart of each task

Every task carries acceptance checks **derived from the design's success criteria
and edge cases — written now, before any implementation exists**. This is where
testing quality is won:

- Expected values come from the design, never from running the implementation later.
- Each check is an exact command plus its expected result.
- Cover the design's edge cases for this task, not just the happy path.
- For non-code work (config, docs, generated files), the check is the narrowest
  direct validator, with a note on why a unit test doesn't apply.

## Write the plan

Write `<artifacts dir>/YYYY-MM-DD-<slug>/plan.md` using the template at
[references/plan-template.md](references/plan-template.md) (or the preferences
`template:` override). Rules that make plans executable:

- **No placeholders.** "TBD", "add error handling", "similar to Task 2", or a step
  that says what without showing how are plan failures. Show real code, real
  commands, real expected output.
- **Global constraints copied verbatim** from the design — every task implicitly
  includes them.
- **A Completion Condition section** (see template): the machine-checkable statement
  of done, phrased so a goal evaluator reading only terminal output can judge it.

## Self-review, then the gate

Check the plan against the design with fresh eyes and fix inline:

1. Every design requirement and edge case maps to a task — list any gaps.
2. Placeholder scan (patterns above).
3. Interface consistency — names and signatures used in later tasks match where
   earlier tasks defined them.
4. Every check command can actually prove its expected result.

Set `**Status:** Draft`, show the user the path, ask for review, and **stop**.
On an explicit yes, set `**Status:** Approved` and report back to the router.

Never commit the plan or design files — artifacts stay out of changesets unless the
user explicitly asks (router `references/lifecycle.md`).

## Chat plans (light weight)

When the router classified the task as light, produce the plan in chat instead of a
file: the task list with files, interfaces where they matter, acceptance checks
(same derivation rules — expected values from the design/root cause, written before
implementation), and the completion condition. Keep it proportionate — a two-task
fix needs two tasks, not template headings. One explicit yes approves it; execution
tracks the tasks in the host's task tracker. If drafting the chat plan reveals more
scope than light warrants, say so and upgrade to full with artifacts.
