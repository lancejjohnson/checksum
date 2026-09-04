# Adversarial Review

The review's stance: **assume the implementation is wrong somewhere and go find it.**
Its inputs are the design, the plan, and the full diff (tracked and untracked) —
not the conversation, and not the implementer's explanations.

## Reviewer dispatch prompt (subagent-capable hosts)

```
You are reviewing a completed implementation you did not write. Be adversarial:
your job is to find what is wrong, missing, or dishonest before a human relies on
it. Judge only from the documents and diff below; implementer intent doesn't count.

## Design
<design.md, verbatim>

## Plan
<plan.md, verbatim, with checkboxes as claimed>

## Diff
<full diff including untracked files>

Work the checklist below. Report findings as:
- BLOCKER: incorrect behavior, unmet design criterion, dishonest test/evidence
- SHOULD-FIX: real problems that can ship behind a follow-up only if the user says so
- NIT: style and polish
Cite file:line for every finding. If you find nothing in a category, say what you
checked to conclude that.
```

## Checklist (both dispatch and inline review)

**Conformance**
1. Every design success criterion is actually implemented — point to where.
2. Every design edge case has handling — point to it. Missing handling is a blocker.
3. Interfaces match what the plan declared later tasks and callers consume.
4. Global constraints hold across the whole diff.

**Scope**
5. Nothing implemented beyond the design (unrequested features, speculative
   abstraction, drive-by refactors).
6. No unrelated or pre-existing user changes swept into the work.

**Honesty**
7. Tests assert real behavior: no expected values computed by running the code
   under test, no assertions on mocks as outcomes, no weakened or deleted
   assertions relative to the plan's acceptance checks.
8. Checked checkboxes correspond to checks that actually exist and pass.

**Hygiene**
9. No placeholders, TODOs, commented-out code, or debug output.
10. No secrets, credentials, or local paths in the diff.
11. Errors are handled per the design's failure behavior, not swallowed.

**Deep mode** (`review-depth: deep`): additionally map every design edge case to a
specific test by name, and read each new test asking "what production bug would
this fail to catch?"

## Triage

Blockers: fix before the user review gate (substantive fixes return to execute and
re-verify). Should-fix: present to the user at the review gate with a
recommendation. Nits: list them; fix only if trivial and in scope.
