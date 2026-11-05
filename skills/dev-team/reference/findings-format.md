# Review findings format (DEV)

Same structure as the PAIASA PM team, so both teams speak one language. Every reviewer agent writes `.dev/tasks/<task-id>/review-<agent>-r<N>.md`.

```markdown
### <AGENT-CODE>-<N>: <short title>
- Area: correctness | tests | security | architecture | performance | ui | maintainability | docs | risk
- Status: open | fixed | justified | escalated
- Severity: critical | significant | minor
- Blocking: blocking | follow-up
- Evidence: <file:line, diff hunk, command output, screenshot path>
- Problem: <what is wrong, and the concrete failure scenario: input/state → wrong result>
- Closure condition: <exactly what change or proof closes it>
```

Agent codes: `CR` code-reviewer, `SEC` security-reviewer, `ARC` architecture-guardian, `PERF` performance-engineer, `RISK` risk-guardian, `UI` ui-verifier.

## Severity

- **critical**: data loss or corruption, a security vulnerability that can be exploited, broken core flow, failing acceptance criterion, secret in the diff, an irreversible migration without a plan.
- **significant**: a bug in a realistic edge case, a missing test for an AC or a risky path, an authorization gap without proven exploitability, a performance budget missed, an architecture rule violated, an error not handled on a user path.
- **minor**: naming, readability, a small duplication, a docs gap with no behavior impact.

## Blocking vs follow-up

- **blocking**: must be fixed before this PR (any critical; a significant that breaks an AC, exposes data, or is exploitable in the current profile).
- **follow-up**: real, but can wait. The orchestrator copies it to `.dev/followups.md`, tagged `hardening` if it must be done before production.
- **At most 5 blocking findings per reviewer per round.** If you see more, rank them and put the rest as follow-ups.

The gate for the PR is **zero open blocking findings** from every reviewer that ran. Only blocking findings start a new round. Report only real problems with a concrete failure scenario. Don't pad with style nits, speculative "could be better" items, or test requests beyond the test budget (profiles.md); linters handle style.

## Implementer response

In `.dev/tasks/<task-id>/responses-r<N>.md`, for each finding: **fixed** (what changed), **justified** (why not, with evidence; goes to the decision record), or **escalated** (needs a human or the PM team).
