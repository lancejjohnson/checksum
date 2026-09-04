---
status: pending
claimed-by:
depends: []
deliver: plan
---

# Task NN: [Outcome, stated as a result]

**Plan:** [../plan.md](../plan.md) · **Design:** [../design.md](../design.md)
(Global constraints in the plan apply to this task.)

**Files:**
- Create: `exact/path/new_file.py`
- Modify: `exact/path/existing.py`
- Test: `tests/exact/path/test_file.py`

**Interfaces:**
- Consumes: [exact signatures from dependency tasks or existing code]
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

## Result

[Filled on completion: commands run, actual output summary, deviations from the
task and why. If blocked: what was tried and what blocks.]
