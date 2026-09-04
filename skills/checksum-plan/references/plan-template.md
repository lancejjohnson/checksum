# [Change Name] Implementation Plan

> **For implementers:** Execute with the `checksum-execute` skill. Work tasks in
> order unless marked independent. Update a checkbox only after its check passed
> in this session.

**Status:** Draft
**Design:** [./design.md](./design.md)
**Goal:** [One sentence.]
**Tech:** [Languages, frameworks, key existing dependencies.]

## Global Constraints

- [Copied verbatim from the design. Every task implicitly includes these.]

## Completion Condition

[The machine-checkable definition of done, phrased so an evaluator reading only
terminal output can judge it. Exact commands, expected outcomes, and boundary
constraints. This block is ready to paste into `/goal` on hosts that support goals.]

> Example: `npm test` exits 0 with no failures, `npm run lint` reports 0 errors,
> and no files outside `src/retry/` and `tests/retry/` were modified.

---

### Task N: [Outcome, stated as a result]

**Files:**
- Create: `exact/path/new_file.py`
- Modify: `exact/path/existing.py`
- Test: `tests/exact/path/test_file.py`

**Interfaces:**
- Consumes: [exact signatures from earlier tasks or existing code]
- Produces: [exact names, parameters, return types later tasks rely on]

**Failure behavior:** [What this component does on bad input / partial failure,
from the design's edge-case section.]

**Acceptance checks** (expected values from the design, written before implementation):

```
Run: <exact command>
Expect: <specific output, count, or exit status>
```

**Steps:**

- [ ] [Concrete step stated by outcome and constraint — code blocks only where the
      exact content is the contract (test assertions, schemas, signatures);
      implementation bodies are written during execution, not here]
- [ ] […]
- [ ] Run the acceptance checks above and the neighboring tests they affect;
      record actual output.

---

## Full Verification

```
Run: <full suite / lint / typecheck / build commands, one per line>
Expect: <pass condition for each>
```

[The finish phase runs these fresh and traces each design success criterion to
evidence. Anything unlisted here will not be checked — list everything that matters.]
