# Definition of Ready and Definition of Done

## Ready (before implementation starts)

A task is ready only when:
- [ ] Goal and acceptance criteria are present and each AC can be checked by a test.
- [ ] Interfaces, entities and rules it references are defined, or the task itself defines them.
- [ ] No dependency is missing. An unmerged dependency is fine: branch from it (stacked PR, execution.md).
- [ ] It does not depend on an open user decision.
- [ ] Risk triage is done, the profile is known, and the required reviewers are known.
- [ ] It fits in one reviewable PR.

If not ready: write `.dev/tasks/<id>/questions-for-pm.md` with precise questions, mark the task `blocked` in STATE.md, and continue with other ready tasks. **Never guess behavior.**

## Done (before a PR is offered to a human for merge)

All profiles:
- [ ] Every AC is covered by an automated test; the tests stay within the test budget (profiles.md).
- [ ] Build, tests, lint and typecheck pass (with timeouts); the orchestrator re-ran them.
- [ ] The implementer ran the app and walked the main flow; servers it started are stopped.
- [ ] Zero open **blocking** findings from every reviewer that ran; follow-ups are in `.dev/followups.md`.
- [ ] No secrets, debug code, commented-out code or unrelated changes in the diff.
- [ ] Evidence: the PR description (prototype/standard), the full package (production).
- [ ] PR opened as **draft** (or ready-for-review if the project allows). **Never merged by an agent.**

Production adds:
- [ ] Tests were written from the ACs by the test-engineer and failed before the implementation.
- [ ] Flag-specific reviews passed; automated scans clean or justified.
- [ ] UI verified by the ui-verifier at mobile and desktop width.
- [ ] Docs updated: README/API docs/CHANGELOG/ADR as relevant; migrations documented with rollback.

## Fix loop limit

Review rounds per profile: **prototype 1, standard 1, production 2**, each followed by an allowed small fix (a user override in `.dev/team.md` wins). Only blocking findings start a new round.

After the last round, a **targeted fix** is allowed without asking the user when every remaining fix is small (configuration, a few lines, the order of steps). The reviewer who raised the finding re-checks only that point. If a fix is not small, or the same finding reappears without new information, stop and write `.dev/tasks/<id>/escalation.md` for the human Tech Lead (or the person the override names), with both positions and evidence.
