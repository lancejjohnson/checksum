---
name: checksum-debug
description: Diagnose bugs, failing tests or builds, performance regressions, integration failures, and unexpected behavior before proposing a permanent fix. Use on a reported defect, when primary checksum execution hits an unexplained failure, or for investigation-only work. Produces evidence and a fix boundary, then returns to the normal light/full flow. Do not use when dispatched as a narrow implementation subagent; stop and report raw failure evidence to the primary instead.
---

# Checksum: Debug

Debug is an entry and recovery mode, not a fifth lifecycle phase. Its product is a
diagnosis: reproducible evidence, a causal explanation with stated confidence, and
the boundary of a permanent fix. It may end without a code change.

Use `## debug` and `## general` preferences passed by the calling checksum skill.
If none were passed — including direct investigation-only use — load them yourself
using the router's
[preferences contract](../checksum/references/preferences.md). Do not require a
design or plan before diagnosis.

If you are a narrow implementation subagent, stop here and report the raw failure
evidence to the dispatching primary. The primary owns debug preference loading,
hypothesis accounting, diagnosis state, and router decisions.

## Preserve the failure

Before changing production code:

1. Record observed vs. expected behavior, the exact command or steps, complete
   errors and warnings, environment facts that may matter, and whether the failure
   is deterministic.
2. Reproduce it. For an intermittent failure, measure frequency or conditions
   instead of calling one passing run fixed.
3. Check recent changes and find the closest working example in the same repository.

If reproduction is blocked, state exactly why and gather the next-best evidence.
Do not fill the gap with a plausible story.

## Find the failing boundary

- Trace bad state backward from the symptom to where it first becomes wrong.
- In multi-component paths, inspect input and output at each boundary to locate the
  failing layer before drilling into it.
- Add the smallest temporary diagnostic instrumentation needed. Keep it visibly
  diagnostic and remove it before handoff unless the user approves pursuing it as
  durable observability through the normal checksum flow.
- Compare working and failing paths; list material differences before deciding
  which one matters.

## Test one hypothesis at a time

State one falsifiable hypothesis: **cause**, **evidence supporting it**, and the
**result that would disprove it**. Run the smallest diagnostic experiment that
changes one variable. Record the result before forming the next hypothesis.

Do not stack speculative fixes. Before an experiment edits production code, record
the baseline diff and keep the edit local and uncommitted. Revert it immediately
after recording the result. It may survive only by becoming either an explicitly
approved containment or an approved permanent fix delivered through the normal
checksum flow; debug itself never turns an experiment into production work. At
handoff, inspect the full diff and disclose any diagnostic change that remains. A
passing experiment confirms only what it tested.

After the configured hypothesis limit (default 3) without a confirmed path, stop,
show the evidence, and ask the user whether to investigate a new direction, revisit
the architecture or assumptions, or pause. Repetition is an escalation signal, not
proof that the architecture is wrong. An explicit choice to continue grants a fresh
budget; record that extension and its direction in the diagnosis contract.

## Produce the diagnosis

Use [references/diagnosis.md](references/diagnosis.md). Label root-cause confidence:

- **confirmed** — a causal experiment or trace identified the source;
- **probable** — converging evidence, but no direct causal confirmation;
- **unknown** — the evidence bounds the failure but not its source.

For a permanent fix, define the smallest fix boundary and a regression condition
derived from the original symptom. The execute testing policy must observe that
condition fail against the broken behavior before fixing it, except when the user
explicitly accepts that reproduction is blocked under the testing policy's narrow
exception.

For full-weight active work, record the concise diagnosis in the affected task's
`## Diagnosis` section. For light fixes, put a complete `## Diagnosis` block and
the exact regression condition in the explicit approved chat plan, mirror it into
the host's task tracker when one exists, and restate it at execute handoff. Do not
rely on an unstructured earlier exchange or unstated conversation memory. For
diagnosis-only work, present it in chat.

Do not create a standalone diagnosis file by default. If the user asks to retain
one, choose a short failure slug and place it at
`<artifacts dir>/YYYY-MM-DD-<slug>/diagnosis.md`; reuse that directory if the work
later becomes full weight. Like designs and plans, it is a working paper: never
stage or commit it unless the user explicitly asks, and include it in normal
artifact cleanup if the work later resumes. For diagnosis-only work, say that it
persists until the user asks to clear it.

## Containment before cause

Operational recovery and permanent correction are different jobs. With the default
`containment: allow-with-approval`, propose containment only when delay has real
cost. Label it temporary and define its risk, rollback, monitoring, explicit owner,
removal condition or deadline, and a
[durable follow-up](../checksum/references/lifecycle.md#durable-operational-follow-up)
outside the current plan's completion set. Get user approval to pursue it, then
return to the router: application requires at least a light design and plan, an
executable check that the containment restores the affected behavior, the normal
execute adversarial review, human local-review gate, and finish delivery record.
Keep the diagnosis and containment open. `containment: require-cause` forbids
deployed containment until a causal path is confirmed; `uncertain-fix:
require-cause` separately forbids a permanent production correction at probable or
unknown confidence. Both still permit local, reverted diagnostic edits.

## Handoff

- Diagnosis only or external/environmental cause: report evidence, confidence, and
  next observable signal; stop.
- Permanent fix: return to the `checksum` router with the diagnosis. If confidence
  is probable or unknown, the router first asks whether to investigate further,
  proceed with that uncertainty, or stop. Proceeding requires the residual-risk
  record defined by the router. Then let the router recommend a weight and the user
  confirm or override it; do not make the diagnosis itself imply heavier ceremony.
- Approved containment: return to the router for the light/full build flow; debug
  has authorized no production edit or delivery.
- Unexpected execute failure: update the affected task with the diagnosis, then
  return to the router's confidence gate. Resume execute only when the cause is
  confirmed, or the user explicitly chooses to proceed under the uncertain-fix
  policy, and the approved plan still describes the correct fix. Otherwise revise
  the plan/design or continue investigating before editing.
