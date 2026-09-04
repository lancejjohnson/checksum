---
name: checksum-execute
description: Execute an approved checksum plan task by task with spec-anchored checks and fresh evidence. Use when the checksum router selects the execute phase - an Approved or Active plan has unchecked tasks or failing checks.
---

# Checksum: Execute

Execute the plan as written; the thinking already happened. Your job here is
faithful implementation, honest checks, and knowing when to stop and route back.

Require preferences and an approved plan from the `checksum` router — a plan file
for full-weight work, the approved chat plan for light work. Read the **entire plan
and the design** before editing anything. If either is stale, inconsistent, or has
a gap that blocks starting, return to the router — do not improvise around a broken
plan. Honor every directive in the `## execute` preferences section.

Before the first edit: set the plan file `**Status:** Active` (light: the task
tracker is the status), note any pre-existing uncommitted user changes (never mix
them into your work), and create a task-tracker entry per unchecked task.

## Choose the delegation mode

With `delegation: auto` (the default), the deciding question is whether a native
subagent dispatch tool is **in your current tool list** — not which brand of host
you are on. Claude Code ships one always (Task); Codex has one only when the user
enabled `features.multi_agent` (`spawn_agent` et al.); enabling it is the user
opting into multi-agent execution, so honor it.

- **Dispatch tool present** → **subagent-per-task**. Each task runs in a fresh
  context; the plan was written for a zero-context implementer, so hand it over
  whole. Follow [references/delegation.md](references/delegation.md) for the
  dispatch prompt, per-host dispatch mechanics, and the non-negotiable rule: the
  primary agent verifies every result itself — read the diff, rerun the acceptance
  checks. A subagent's "done" is a claim, not evidence.
- **No dispatch tool** (Codex default config, most other hosts) → **inline
  execution**, tasks in sequence. This is where the host's goals feature shines:
  per the `goals` preference, offer to set `/goal` using the plan's Completion
  Condition so the run continues autonomously across turns. Phrasing rules:
  [references/goals.md](references/goals.md).

An explicit `delegation:` preference overrides the auto choice on either host.
Parallel dispatch only for tasks the plan explicitly marks independent.

## The task loop

For each unchecked task, in plan order:

1. Mark it in progress.
2. Apply the testing policy from [references/testing.md](references/testing.md)
   using the `testing` preference (default `spec-anchored`): materialize the task's
   acceptance checks as real tests before or alongside the implementation, with
   expected values taken from the plan — never from running the code.
3. Implement the steps as written. Smallest change that satisfies the task; no
   scope beyond it.
4. Run the acceptance checks and the neighboring tests they affect. Read complete
   output.
5. **Refactor checkpoint:** compare what now exists against the design's structure.
   Tidy naming, duplication, and file placement within the task's scope while
   checks stay green. This scheduled pass replaces red-green ritual as the design
   pressure.
6. Check the checkbox only after you watched its checks pass in this session, and
   record actual output where the plan asks for it.

## When checks fail

Find the cause before editing further — read the error, trace it to the root, fix
the root. Never weaken a test, delete an assertion, or special-case the check to get
to green; if the check itself is wrong, that is a plan defect — say so and route
back through the router.

Three failed fix attempts on the same problem means the plan or design has a gap:
stop, summarize the evidence, and return to the router rather than thrashing.

## Stop and ask

Pause for the user when you hit: a missing dependency or credential, an instruction
you don't understand, scope growing past the design, any destructive action, or any
external effect (push, publish, third-party calls with side effects). Blocked is
reportable; guessing is not.

## Transition

When every task is checked with observed passing checks, report the plan path and
per-task results to the router — it will route to `checksum-finish`. Execute never
commits, pushes, or publishes; delivery belongs to finish, behind the user's review
gate.
