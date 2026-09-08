# Diagnosis Contract

The diagnosis is compact enough for chat and complete enough that a different
agent can design or implement the fix without repeating the investigation.

```markdown
## Diagnosis

**Observed:** [exact behavior]
**Expected:** [exact behavior]
**Reproduction:** `<command or numbered steps>`
**Reproducibility:** [always / N of M runs / conditions / blocked and why]
**Environment:** [only facts that can affect the result]

### Evidence

- [Observation, command, or trace and what it establishes]
- [Working-vs-failing comparison]

### Hypotheses tested

1. [Hypothesis] — [experiment] — [confirmed / disproved / inconclusive]

**Investigation budget:** [N hypotheses used; any user-approved extension and its
new direction]

### Root cause

**Confidence:** confirmed | probable | unknown

[The causal path supported by evidence. Separate facts from inference.]

### Residual risk (only when proceeding at probable or unknown confidence)

For a correction pursued at **probable** or **unknown** confidence:

**Residual risk:** [what the inferred cause or correction may miss]
**Rollback:** [exact reversal]
**Falsifying / monitoring signal:** [observation and threshold]
**Owner:** [person or durable team identity]
**Follow-up:** [external issue/ticket or committed project tracker anchor; its entry
must contain current evidence, confidence, next investigation signal, residual
risk, owner, and completion condition]
**Approved by:** [explicit user approval reference]

### Fix boundary

[The smallest behavior or component a permanent correction must change, plus what
must remain unchanged.]

**Regression condition:** [check derived from the original symptom that must fail
against the broken behavior and pass after the fix, or the approved proxy below]
**Observed-red evidence:** [execute fills before fixing: exact command and failing
result, or a reference to the approved reproduction exception]

### Reproduction exception (only when reproduction is blocked)

**Blocker:** [why the original symptom cannot be run]
**Proxy check:** [strongest executable substitute and what it proves]
**Residual risk:** [what the proxy cannot establish]
**Accepted by:** [explicit user approval reference]

### Containment (only when approved)

**Temporary action:** [action]
**Risk:** [what it can worsen or hide]
**Rollback:** [exact reversal]
**Monitoring:** [signal and threshold]
**Remove when:** [condition or deadline]
**Owner:** [person or durable team identity]
**Follow-up:** [external issue/ticket or committed project tracker anchor; its entry
must contain current evidence, confidence, next investigation signal, containment
risk, owner, and removal condition]
**Approved by:** [explicit user approval reference]
```

Do not write a design or implementation plan inside the diagnosis. It establishes
facts and boundaries; the checksum router chooses the ceremony for the fix.
