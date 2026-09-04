# Lifecycle and Phase Selection

## Artifact layout

Each full-weight change gets one directory:

```
docs/checksum/YYYY-MM-DD-<slug>/
  design.md              Status: Draft | Approved
  plan.md                Status: Draft | Approved | Active | Complete
                         (overview: goal, global constraints, completion
                          condition, task index)
  tasks/NN-<task-slug>.md  one file per task, tracked via frontmatter
```

Tasks are separate files so agents can claim them independently, dependencies can
gate order, and delivery can happen per task (stacked commits/PRs). Task
frontmatter:

```yaml
---
status: pending          # pending | claimed | done | blocked
claimed-by:              # link/id of the claiming session, set on claim (see below)
depends: []              # task ids (filename stems) that must be done first
deliver: plan            # plan | commit | pr
---
```

`claimed-by` is an audit trail, not just a lock: use the most durable session
reference the host exposes, so the conversation that did the work stays reachable
after the fact.

| Host | Value |
|---|---|
| Delta | `delta://thread/$DELTA_CURRENT_THREAD_ID` (env var; renders as a thread link) |
| Claude Code / Codex | the session id if the host exposes one; else `<host> <date>` |
| Dispatched subagent | the primary session's reference plus ` agent=<child label>` |

| Task status | Meaning | Who sets it |
|---|---|---|
| pending | Not yet picked up | plan phase |
| claimed | An agent is working it; `claimed-by` says who | the claiming agent, before its first edit |
| done | Acceptance checks observed passing | the verifying agent only |
| blocked | Cannot proceed; reason recorded in the file | whoever hit the wall |

**Claiming protocol:** a task is claimable when its status is `pending` and every
task in `depends` is `done`. Set `status: claimed` + `claimed-by` before the first
edit, `done` only after observed passing checks, `blocked` with a written reason
instead of thrashing. A `claimed` task whose claimant is gone (stale session) may be
reclaimed — re-verify any partial work first. The numeric filename prefix suggests
default order; `depends` is the hard gate.

**Delivery flag:** `plan` (default) delivers everything together at finish;
`commit` makes a task-scoped commit once the task is done and verified — approving
a plan that carries `deliver: commit` flags *is* the explicit authorization for
those local commits; `pr` additionally pushes a stacked branch/PR, which is an
external effect and always gets a per-delivery user go (or a finish preference
saying otherwise).

The slug is short, kebab-case, and names the change (`2026-08-12-retry-budget`).
The date is the day the design started; it never changes across phases. Keeping
design and plan together means the plan can cite the design by relative link and
reviewers see the whole story in one place.

Artifact files exist only for **full-weight** changes. Light work carries the same
ceremony in chat: the approved chat plan takes the plan file's place, and task
tracking takes the checkboxes' place.

## Artifacts stay out of changesets

Checksum artifacts are the agent's working papers. **Never stage or commit anything
under the artifacts directory unless the user explicitly asks in this session** —
no preference enables it silently.

- When creating the first artifact in a repository, offer once to add the
  artifacts directory to `.gitignore`. If declined, keep the exclusion by staging
  discipline instead: stage by explicit pathspec and never `git add -A` from a
  directory that would sweep artifacts in.
- At finish, artifact files are not part of the change: exclude them from the diff
  presented for review (note their existence instead) and from any commit.
- "Commit the plan too" from the user is an ordinary explicit request — honor it
  for that changeset only.

## Status semantics

| Status | Meaning | Who sets it |
|---|---|---|
| Draft | Written, not yet approved by the user | design/plan phase |
| Approved | User said yes to this exact content (including task delivery flags) | design/plan phase, only after an explicit yes |
| Active | Execution has started against this plan | execute phase, before the first edit |
| Complete | All tasks done and verified fresh at plan finalize | finish phase, only after verification passes |

Complete is the end of the artifacts' life: plan finalize distills the design and
plan into the shipped record (PR description or commit body) and then clears the
artifact directory (`artifacts: clear`, the default) — decisions live on with the
code; working papers don't outlive it.

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
Complete, re-read the design, plan, and task files, re-verify the most recently
`done` task's checks before trusting them, and route by the selection rules in the
router skill. Statuses and checkboxes are claims; fresh command output is evidence.

## Interrupted or abandoned work

If the user abandons a change, leave artifacts as they stand (Draft/Active is an
honest record). Outside plan finalize's close-out (which clears them only after the
condensed record has shipped durably), never delete artifact directories without
being asked.
