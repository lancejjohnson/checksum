# Lifecycle and Phase Selection

## Artifact layout

Each full-weight change gets one directory:

```
docs/checksum/YYYY-MM-DD-<slug>/
  design.md   Status: Draft | Approved
  plan.md     Status: Draft | Approved | Active | Complete
```

The slug is short, kebab-case, and names the change (`2026-08-12-retry-budget`).
The date is the day the design started; it never changes across phases. Keeping
design and plan together means the plan can cite the design by relative link and
reviewers see the whole story in one place.

## Status semantics

| Status | Meaning | Who sets it |
|---|---|---|
| Draft | Written, not yet approved by the user | design/plan phase |
| Approved | User said yes to this exact content | design/plan phase, only after an explicit yes |
| Active | Execution has started against this plan | execute phase, before the first edit |
| Complete | All checks verified fresh at finish | finish phase, only after verification passes |

Never mark Approved on the user's behalf. "Looks good, but change X" is not
approval — make the change, then ask again.

## Staleness

An artifact is stale when its goal, constraints, or chosen approach no longer
describe the requested work — because the request changed, the repository changed
underneath it, or execution revealed the approach cannot work. Compare the artifact
against the request and the repository, not against memory.

Stale design → return to design. Stale plan under a current design → return to plan.
Record what changed and why at the top of the revised artifact so the history reads
forward. An approved artifact that gets revised drops back to Draft and needs
approval again.

## Resuming

On "resume" or "continue", find the newest artifact directory whose plan is not
Complete, re-read both artifacts fully, re-verify the last checked task's check
before trusting it, and route by the selection rules in the router skill. Checkboxes
are claims; fresh command output is evidence.

## Interrupted or abandoned work

If the user abandons a change, leave artifacts as they stand (Draft/Active is an
honest record). Never delete artifact directories without being asked.
