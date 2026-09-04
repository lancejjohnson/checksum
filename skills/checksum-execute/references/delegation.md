# Subagent-Per-Task Execution

Used on hosts with a subagent dispatch tool (Claude Code and equivalents) when
`delegation` is `auto` or `subagent-per-task`. The value: each task gets a fresh
context with no accumulated drift, and the primary agent stays cheap enough to act
as a real reviewer between tasks.

## Dispatch prompt

Give each subagent everything — it has no conversation memory. Include verbatim:

```
You are implementing one task from an approved plan. Do exactly this task; nothing
more. Do not commit, push, or touch files outside the task's file list.

## Global constraints
<plan's Global Constraints section, verbatim>

## Testing policy
<the selected mode's rules from testing.md, verbatim>

## Your task
<the full task section from the plan, verbatim: files, interfaces, failure
behavior, acceptance checks, steps>

## Report format
When done, report: files created/modified; each acceptance check command with its
actual complete output; anything that deviated from the task and why.
```

## Primary-agent verification (non-negotiable)

After each subagent reports:

1. Read the actual diff — not the report.
2. Rerun the task's acceptance checks yourself; read complete output.
3. Check conformance: files touched match the task list; interfaces match what the
   plan says later tasks consume; no scope creep, placeholders, or weakened tests.
4. Only then check the checkbox.

A subagent report of success is a claim. Verification is yours.

## Failure handling

- Review found problems → dispatch one focused fix subagent with the findings.
- Same task fails review twice → take it over inline; something about the task
  needs judgment the dispatch loop lacks.
- The fix reveals a plan defect → stop dispatching and return to the router.

## Parallelism

Dispatch concurrently only tasks the plan explicitly marks independent, and verify
each result separately before checking any of their boxes.
