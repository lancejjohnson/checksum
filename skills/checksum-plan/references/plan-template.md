# [Change Name] Implementation Plan

> **For implementers:** Execute with the `checksum-execute` skill. Tasks live in
> `tasks/` as separate claimable files; claim before working, respect `depends`,
> and mark `done` only after observed passing checks.

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

## Task Index

| Task | Outcome | Depends | Deliver |
|---|---|---|---|
| [`tasks/01-<slug>.md`](tasks/01-<slug>.md) | [one line] | — | plan |
| [`tasks/02-<slug>.md`](tasks/02-<slug>.md) | [one line] | 01-<slug> | plan |

## Full Verification

```
Run: <full suite / lint / typecheck / build commands, one per line>
Expect: <pass condition for each>
```

[The finish phase runs these fresh and traces each design success criterion to
evidence. Anything unlisted here will not be checked — list everything that matters.]
