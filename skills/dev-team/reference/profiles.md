# Process profiles

The team's job is to **build the feature and verify that it works**. Research, ADRs, extra reviewers and large test suites are tools you use only when the profile or a real risk calls for them. Proportion beats ceremony.

## Choosing the profile

1. `--profile <name>` in the command (`/paiasa-dev:dev-team <prompt> --profile prototype`) sets it **for that run/task only**.
2. Otherwise the project profile in `.dev/team.md` (`Profile: standard`), or one stated in the prompt or the PM handoff.
3. Otherwise ask the user once in Phase 1, with one line per profile, and record the answer in `.dev/team.md`. If the user doesn't answer, use **standard**.

The user can change the project profile at any time; it applies from the next task (current task is not interrupted).

## The matrix

Prototype and standard share one simple flow: **make → check → ship** (SKILL.md Phase 3). They differ only in what gets a security review. Production is the full process.

| | prototype | standard (default) | production |
|---|---|---|---|
| Purpose | demos, synthetic data | normal work before production | going live; every `harden` run |
| Flow | make → check → ship | make → check → ship | full: tests first, map, all flagged reviewers, ui-verifier, evidence package |
| Tests | one per AC + negative access tests, written by the implementer | same | test-engineer, before the code |
| Self-check | implementer runs build, tests and the app | same | same + ui-verifier |
| Reviewers | code-reviewer (+ security-reviewer on login/auth and payments) | code-reviewer (+ security-reviewer on login/auth, payments and personal data) | code-reviewer + risk-guardian + every flagged reviewer |
| Rounds | 1 + small fix | 1 + small fix | 2 |
| Research / ADR | only if the user asks; short ADR for a new library or real architecture change | same | as flagged |
| Evidence | PR description | PR description | full package |
| Models | implementer opus; security-reviewer Fable | same | implementer opus (Fable only with the user's yes) |

Size of a task (S/M/L) comes from the prompt's `size`, or the orchestrator's estimate (S: ≤ ~5 files, M: ≤ ~15, L: more).

## Test budget (all profiles, guideline)

New tests per task: **S ~10, M ~25, L ~50**. Going over needs one sentence of justification in the PR.

Never write these without an explicit AC asking for them:
- byte-identical comparison of generated files (images, PDFs, archives);
- determinism across platforms or OSes;
- timing statistics, flaky-prone sleeps, benchmark assertions;
- self-tests of helper scripts or test utilities;
- matrices of every combination of inputs/roles/locales.

A test must protect a requirement or a realistic regression. "More tests" is not a goal.

## Follow-ups and hardening

In prototype and standard, everything deliberately postponed goes to `.dev/followups.md`:

```markdown
## FU-012 [hardening] Rate limit on /api/login
- Module: auth | From: P-04, SEC-2 (follow-up) | Date: 2026-11-06
- Why postponed: profile prototype, synthetic data
- Closure: rate limit + test, verified in `harden auth`
```

Use the tag `hardening` for anything that must be done before production (security, reliability, data handling, missing tests for risky paths). Other tags: `cleanup`, `ux`, `perf`.

**Release rule:** a production release is no-go while open `hardening` items exist for the modules in the release. They are closed only by `/paiasa-dev:dev-team harden <module|all>` (SKILL.md, "Harden").

## What no profile changes

- Humans merge and approve production.
- No production data or production secrets.
- Never guess behavior; ambiguity goes back to the PM team.
- Never disable a check, test, scan or hook to make something pass.
- Every AC has a test, and the build and tests pass before the PR.
- The implementer verifies its own work by running it, and a different agent reviews the diff.
