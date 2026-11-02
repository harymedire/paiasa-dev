# Definition of Ready and Definition of Done

## Ready (before implementation starts)

A task is ready only when:
- [ ] Goal and acceptance criteria are present and each AC can be written as a test (the test-engineer confirms this).
- [ ] Interfaces, entities and rules it references are defined, or the task itself defines them.
- [ ] No dependency is unfinished (or it is stubbed by explicit agreement).
- [ ] It does not depend on an open user decision.
- [ ] Risk triage is done and the required agents are known.
- [ ] It fits in one reviewable PR.

If not ready: write `.dev/tasks/<id>/questions-for-pm.md` with precise questions, mark the task `blocked` in STATE.md, and continue with other ready tasks. **Never guess behavior.**

## Done (before a PR is offered to a human for merge)

- [ ] Every acceptance criterion is covered by an automated test. Tests were written from the ACs by the test-engineer and failed before the implementation.
- [ ] The full test suite, linter, type checker and build pass locally/CI. Output is saved as evidence.
- [ ] Code review: no open critical/significant findings.
- [ ] Risk guardian: no open critical/significant findings.
- [ ] Flag-specific reviews passed (security / architecture / performance), automated scans clean or justified.
- [ ] UI verified in a browser at mobile and desktop width if the task has UI. Screenshots saved.
- [ ] Docs updated: README/API docs/CHANGELOG/ADR as relevant; migrations documented with rollback.
- [ ] No secrets, debug code, commented-out code or unrelated changes in the diff.
- [ ] Evidence package written (`evidence-format.md`).
- [ ] PR opened as **draft** (or ready-for-review if the project allows), with the evidence summary. **Never merged by an agent.**

## Fix loop limit

Reviewer → implementer fix loops: **max 3** per task. After 3, or if the same finding reappears without new information, stop. Write the disagreement to `.dev/tasks/<id>/escalation.md` for the human Tech Lead, with both positions and evidence.
