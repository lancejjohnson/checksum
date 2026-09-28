---
name: checksum-design
description: Write or revise a checksum design. Use when the checksum router selects the design phase - the design is absent, incomplete, or stale. Turns an idea into an approved design with observable success criteria.
---

# Checksum: Design

Design is the highest-leverage phase. When an agent settles data shapes, contracts,
failure behavior, and edge cases before writing code, the result is measurably better
than when structure emerges from incremental implementation decisions. Spend the
effort here, not on ceremony later.

Require preferences and a slug from the `checksum` router; if missing, run the router
first. Honor every directive in the `## design` preferences section.

## Understand before proposing

- Explore the repository first: relevant code paths, existing patterns, recent
  commits, prior `docs/checksum/` artifacts that touch the same area.
- For a bug: require the `checksum-debug`
  [diagnosis contract](../checksum-debug/references/diagnosis.md) first unless the
  cause is already confirmed by causal evidence. In either case require observed
  vs. expected behavior, a reproduction (or the exact reason it is blocked),
  causal evidence, and a regression condition. Carry those facts plus confidence
  and fix boundary into the design; do not make the design phase repeat or rewrite
  an existing investigation. If neither a diagnosis nor confirmed evidence exists,
  return to the router so it can invoke debug; do not diagnose inside design.
- Ask clarifying questions **one at a time** as soon as they are found, for
  anything that changes scope, behavior, risk, implementation choices,
  verification, or external effects. Prefer multiple-choice when the options
  are real. Record each answer and its source in the design, then revise affected
  sections. Do not defer a consequential question to an “open questions” list,
  copy it into a plan, or ask an implementer to decide. Use your judgment only
  for details that do not change any of those.
- If the request contains multiple independent subsystems, say so and decompose
  first — one design per independently shippable piece.

## Propose approaches

Present 2–3 genuinely different approaches with trade-offs. Lead with your
recommendation and why. YAGNI applies to every option: strip features nobody asked
for before presenting, and prefer the standard library and installed dependencies
over new ones.

Present the design in sections sized to their complexity and check in after each
section rather than dumping the whole design at once.

## Write the design

Write `<artifacts dir>/YYYY-MM-DD-<slug>/design.md` using the template at
[references/design-template.md](references/design-template.md) (or the preferences
`template:` override). Requirements that make the rest of the workflow function:

- **Success criteria must be observable** — each one names the command, behavior,
  or artifact that proves it. These become the plan's acceptance checks and the
  finish phase's verification matrix. "Works correctly" is not a criterion;
  "`GET /health` returns 200 with `{status: ok}` within 100ms" is.
- **Edge cases and failure behavior are design content**, not implementation
  details. Enumerate them here — malformed input, empty states, concurrency,
  partial failure — because whatever is missing here will be missing from the code.
- **Out of scope is explicit.** It is the only defense against scope creep during
  execution.

## Self-review, then the gate

Re-read with fresh eyes and fix inline:

1. Placeholders, TBDs, vague requirements
2. Sections that contradict each other
3. Requirements interpretable two ways — ask the user; record their answer
4. Scope too large for one plan — propose decomposition
5. Assumptions that contradict what the repository actually does

A design with an unanswered consequential question remains Draft or Blocked and
is ineligible for planning; approval cannot waive this gate. Bounded
non-material assumptions must be explicit decisions with evidence and an
impact-if-false, never disguised open questions.

Then set `**Status:** Draft`, show the user where it lives, and ask them to
review the question-complete design. **Stop and wait.** On an explicit yes, set
`**Status:** Approved` and report back to the router. On requested changes,
revise and ask again. Never start planning or implementation on an unapproved
design or one with unanswered questions.
