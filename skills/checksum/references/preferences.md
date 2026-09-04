# Preferences Format

Preferences are how the user grows this framework to fit them. They are plain
markdown — no schema, no loader script, no runtime dependencies. Any prose directive
under a phase heading is binding for that phase. Recognized settings below have
documented defaults; anything else is a free-form rule the phase skill must honor as
if it were written into the skill itself.

Recognized settings may also be written as YAML frontmatter at the top of the file
(flat `key: value` pairs, phase-scoped keys spelled `execute.testing`,
`finish.commit`, etc.). Frontmatter and headed sections are equivalent; if both set
the same key, frontmatter wins within its file. Free-form prose rules always live
under the phase headings.

Two locations, both optional:

| File | Scope |
|---|---|
| `~/.checksum/preferences.md` | every repository |
| `.checksum/preferences.md` | this repository (wins on conflict) |

Conflict is judged per directive, not per file: keep every directive that does not
contradict a project-level one.

## Recognized settings

### `## general`

- `artifacts dir: <path>` — where artifact directories are created.
  Default: `docs/checksum`.
- `activation: manual | suggest` — `manual`: run only when explicitly invoked.
  `suggest` (default): when a design-bearing change starts without checksum, offer it
  once and respect the answer.

### `## design`

- `template: <path>` — replaces the built-in design template.
- Free-form: questions to always ask, sections to always include, architectural
  values ("prefer boring technology", "no new dependencies without a listed
  alternative"), documentation style.

### `## plan`

- `template: <path>` — replaces the built-in plan template.
- Free-form: task sizing rules, commit conventions, review requirements.

### `## execute`

- `testing: spec-anchored | strict-tdd | lean` — default `spec-anchored`.
  See the execute skill's `references/testing.md` for what each mode means and the
  evidence behind the default.
- `goals: offer | auto | never` — default `offer`. Whether to propose (or set) a
  `/goal` completion condition when starting execution on a host that supports goals.
- `delegation: auto | inline | subagent-per-task` — default `auto`, which follows
  the host's best practice: fresh subagent per task where a dispatch tool exists
  (Claude Code), direct inline execution elsewhere (Codex). Set explicitly to
  override on either host.
- Free-form: linting/formatting expectations, commit cadence, logging rules.

### `## finish`

- `commit: <instruction or never>` — e.g. `make one conventional commit`.
  Default: ask.
- `push: <instruction or never>` — e.g. `push only when already on a branch`.
  Default: ask.
- `pr: <instruction or never>` — e.g. `open a PR with the repo template`.
  Default: ask.
- `review-depth: standard | deep` — default `standard`. Adversarial review always
  runs; `deep` additionally asks the reviewer to trace every design edge case to a
  test and inspect test honesty line by line.
- Free-form: changelog rules, PR description format, cleanup expectations.

Note: adversarial review and the user's local review gate before any git action are
built into the finish phase and are not preference-removable.

## Starter file

```markdown
---
execute.testing: spec-anchored
execute.goals: offer
---

# Checksum Preferences

## general
- activation: suggest

## execute
- Run the formatter before declaring any task complete.

## finish
- commit: make one conventional commit per completed plan
- push: ask first
```

## Growing preferences over time

When the user corrects the workflow itself ("always show me the diff before
committing", "stop writing tests for config files"), offer to record the correction
in the appropriate preferences section so it holds in future sessions. Never edit
preferences without asking.
