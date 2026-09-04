---
name: checksum
description: Start or resume the checksum workflow (design → plan → execute → finish) for building features, fixing bugs, or refactoring behavior. Use when the user invokes checksum explicitly, or when a code change is large or risky enough to deserve a written design and plan. Do not use for read-only questions, trivial edits, or when dispatched as a subagent with a narrow task.
---

# Checksum: Workflow Router

Checksum is a four-phase loop: **design → plan → execute → finish**. This skill decides
what weight the task deserves, which phase applies, and hands off to the phase skill.
Every phase ends at a decision point; this skill picks the next one.

Core principles, in priority order:

1. **Direct user instructions beat preferences, which beat framework defaults.**
2. **Design before code.** Upfront design (data shapes, contracts, edge cases) is the
   highest-leverage quality step for an agent — more than any testing ritual.
3. **Evidence before claims.** No phase completes on "should work." Fresh command
   output or it did not happen.
4. **Approval gates never scale down.** Ceremony shrinks with the task; the human's
   yes before implementation does not.

## Step 1: Load preferences

Read these files if they exist (both may apply; the project file wins where they conflict):

1. `~/.checksum/preferences.md` — user-wide preferences
2. `.checksum/preferences.md` — project preferences, at the repository root

Preferences are plain markdown: a `## <phase>` heading per phase plus an optional
`## general` section, containing prose directives the phase skills must obey. The
format and recognized settings are documented in [references/preferences.md](references/preferences.md).
If neither file exists, use the defaults stated in each skill — never invent a
preferences file, and never treat its absence as an error.

Carry the relevant preference sections into every phase you run or delegate.

## Step 2: Classify the weight

Say the classification out loud so the user can override it:

- **Spike** — a feasibility question whose output is an answer, not kept code.
  State the question and probe in 2–3 sentences, get a nod, investigate cheaply,
  report a recommendation. Anything built is labeled throwaway. No artifacts.
- **Light** — a small, bounded change to a flow that already exists in this repo.
  Most bug fixes and debugging outcomes land here. The full ceremony happens **in
  chat, with no artifact files**: a short design (approach, files touched — and for
  bugs, the reproduction and root cause) plus a chat plan (task list with
  acceptance checks, per the plan skill's shaping rules). For small changes,
  present both in one message with one approval; **stop and wait for the yes**,
  then run execute and finish as normal, with the approved chat plan standing in
  for the plan file.
- **Full** — new capabilities, new components, interface changes, anything with
  persistence, security, concurrency, or external effects. All four phases with
  written artifacts. The artifact is what scales between light and full — the
  ceremony (design thinking, acceptance checks, approval, verification) is
  identical.

When in doubt, don't assume — present the choice with a one-line cost/benefit and
your recommendation, and let the user pick the weight. When complexity grows
mid-task, stop, describe what changed, and ask whether to upgrade; never silently
continue at the old weight, and never change weight in either direction without the
user's call.

## Step 3: Select the phase (full weight)

Artifacts live in `docs/checksum/YYYY-MM-DD-<slug>/` (overridable via preferences):

- `design.md` — the design, with `**Status:** Draft | Approved`
- `plan.md` — the plan overview, with `**Status:** Draft | Approved | Active | Complete`
- `tasks/NN-<task-slug>.md` — one claimable file per task, tracked in frontmatter
  (`status: pending | claimed | done | blocked`, `depends`, `deliver`)

Use the slug the user named; otherwise match the change being discussed against
existing artifact directories. Then select the first phase that applies:

1. **design** — no design exists, or it is incomplete or stale (its goal,
   constraints, or approach no longer describe the requested work).
2. **plan** — design is Approved but no current plan (overview + task files) exists.
3. **execute** — plan is Approved or Active with tasks not yet `done` (pending,
   claimed, or blocked) or with failing checks.
4. **finish** — every task file is `done` and verified, plan status still Active.

A plan with `**Status:** Complete` is closed; a new request gets a new slug.
Details and staleness rules: [references/lifecycle.md](references/lifecycle.md).

Artifacts are working papers, not deliverables: **never stage or commit anything
under the artifacts directory unless the user explicitly asks** — rules in
lifecycle.md.

## Step 4: Hand off

Invoke the phase skill and follow it exactly:

| Phase | Skill |
|---|---|
| design | `checksum-design` |
| plan | `checksum-plan` |
| execute | `checksum-execute` |
| finish | `checksum-finish` |

After each phase reports, return to Step 3 and select again. Stop early only when
the user asked for design-only or plan-only work.

## Gates and interrupts

- Never begin implementation before the design is approved — for light tasks the
  design is two sentences in chat, but the approval is still a hard stop.
- Pause and ask when you hit real ambiguity, growing scope, a destructive action,
  or an external effect (push, publish, API calls with side effects).
- If an artifact turns out stale mid-phase, return to the earlier phase. Do not
  patch around a wrong design from inside execute.
