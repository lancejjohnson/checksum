# checksum

A minimal, evidence-driven development workflow for coding agents:

**design → plan → execute → finish**

One plugin, two hosts (Claude Code and Codex), zero runtime dependencies — the
entire framework is markdown. Built to start small and grow with your preferences.

## Philosophy

- **Design is where quality is won.** Data shapes, contracts, and edge cases get
  decided before code exists. Evidence shows this beats letting architecture emerge
  from incremental implementation — or from incremental tests.
- **Tests as spec, not ritual.** Acceptance checks are written into the plan from
  the design, before implementation, and become real tests during execution.
  Strict in-loop red-green TDD is available as a preference, not imposed — research
  on agents doing TDD shows the ritual costs 3-8x tokens without reliable quality
  gains. Observed-red stays mandatory where it's cheap and meaningful: bug-fix
  regressions.
- **Evidence over claims.** No phase completes on "should work". Fresh command
  output, complete and read, or the claim isn't made.
- **The artifact scales, the ceremony doesn't.** Every change gets design thinking,
  a plan with acceptance checks, your approval, and verified evidence — but only
  full-weight changes get artifact files. Light work (most bug fixes) runs the
  whole ceremony in chat. And whatever the weight: your yes before implementation,
  and your local review before any commit/push/PR, never scale away.
- **Artifacts are working papers.** Design and plan docs are never committed unless
  you explicitly ask — they stay out of every changeset.
- **Host-adaptive.** On Claude Code, execution dispatches a fresh subagent per task
  with the primary agent verifying every result. On Codex, execution runs inline
  and plugs the plan's completion condition into `/goal` for long autonomous runs.

## Install

### Claude Code

```
/plugin marketplace add plukevdh/checksum
/plugin install checksum@checksum
```

### Codex

Install from a local clone (or a repo marketplace once published):

```bash
git clone https://github.com/plukevdh/checksum
```

Then add it via `/plugins` → install from path, or copy `skills/*` into
`~/.codex/skills/`. To use goals during execution, enable them once:
`codex features enable goals`.

## Use

Invoke the router and describe the change:

- Claude Code: `/checksum:checksum <what you want to build>`  (or just describe the
  task — the skills activate when relevant)
- Codex: `$checksum <what you want to build>`

The router classifies the task (spike / light / full), routes through the phases,
and stops at every gate:

| Phase | Output (full weight) | Gate |
|---|---|---|
| design | `docs/checksum/YYYY-MM-DD-<slug>/design.md` | you approve the design |
| plan | `.../plan.md` — tasks with spec-derived acceptance checks | you approve the plan |
| execute | implementation, task by task, evidence per task | agent stops on blockers |
| finish | fresh verification + adversarial review + review package | **you review locally before any git action** |

Light-weight tasks run the same phases and gates with design and plan presented in
chat instead of files. Artifact files are never committed unless you ask.

Resume any time with "resume checksum" — phase selection is driven by the artifacts
and their status lines, not session memory.

## Make it yours

Preferences are plain markdown — any sentence you write under a phase heading is
binding. Project file wins over the global one:

- `~/.checksum/preferences.md` — everywhere
- `.checksum/preferences.md` — this repo

```markdown
---
execute.testing: spec-anchored
execute.goals: offer
---

## design
- Always propose at least one approach with no new dependencies.

## finish
- commit: one conventional commit per plan
- push: only when already on a feature branch
```

Recognized settings and defaults: [skills/checksum/references/preferences.md](skills/checksum/references/preferences.md).
When you correct the workflow mid-session, the agent offers to record the
correction as a preference — that's the intended way this framework grows.

## Layout

```
skills/
  checksum/            router: weight classification, phase selection, preferences
  checksum-design/     design phase + template
  checksum-plan/       plan phase + template
  checksum-execute/    execute phase + testing policy, goals, delegation refs
  checksum-finish/     finish phase + verification, adversarial review refs
.claude-plugin/        Claude Code manifest + marketplace
.codex-plugin/         Codex manifest
.agents/plugins/       Codex repo marketplace
```

## Provenance

What was taken from (and deliberately changed against) obra/superpowers,
leoxlin/smolpowers, testdouble/han, and the current research on agents and TDD:
[docs/influences.md](docs/influences.md).

## License

MIT
