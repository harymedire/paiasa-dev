# Process profiles

The team's job is to **build the feature and verify that it works**. Research, ADRs, extra reviewers and large test suites are tools you use only when the profile or a real risk calls for them. Proportion beats ceremony.

## Choosing the profile

1. `--profile <name>` in the command (`/paiasa-dev:dev-team <prompt> --profile prototype`) sets it **for that run/task only**.
2. Otherwise the project profile in `.dev/team.md` (`Profile: standard`), or one stated in the prompt or the PM handoff.
3. Otherwise ask the user once in Phase 1, with one line per profile, and record the answer in `.dev/team.md`. If the user doesn't answer, use **standard**.

The user can change the project profile at any time; it applies from the next task (current task is not interrupted).

## The matrix

| | prototype | standard (default) | production |
|---|---|---|---|
| Purpose | demos, synthetic data, throwaway or early product | normal feature work before production | going live, real users or real data; also every `harden` run |
| Code map | no; implementer reads the relevant files | no; implementer reads the relevant files | codebase-analyst map for M/L tasks |
| Research / spike | only if the user asks | only if the user asks, or a novelty flag that blocks implementation (ask first, one line) | novelty flag → spike as before |
| ADR | only for a new library or a real architecture change (short, 10–20 lines) | significant decisions only | as before |
| Tests | one per AC + negative access tests (other user, no login, wrong role) where auth exists | one per AC + edge cases named in the AC or triage + negative access tests | test-engineer writes tests from ACs **before** the code, as before |
| Who writes tests | implementer | implementer (test-engineer only for L tasks or when the implementer asks) | test-engineer |
| Self-check before review | implementer runs build + tests, starts the app, walks the main flow, stops the server | same | same + ui-verifier for UI tasks |
| Reviewers | 1: code-reviewer (also covers the risk checklist) | code-reviewer + risk-guardian; security-reviewer on auth, payments, personal data; architecture-guardian on real architecture changes | code-reviewer + risk-guardian + every flagged reviewer, as before |
| Review rounds | 1; only `blocking` findings are fixed, the rest go to followups | 2 | 2 + targeted fix |
| Fable | security-reviewer on auth and payments only | security-reviewer and architecture-guardian on flagged tasks | as standard; implementer on Fable only with the user's explicit yes |
| Evidence | in the PR description: AC table, CI/test result, 2–4 screenshots for UI | short `.dev/evidence/<id>.md` (one screen) | full evidence package |
| ui-verifier / evidence-reporter | no (implementer and orchestrator) | only for larger UI tasks | yes |
| "CI must fail" proof PRs | no | once per repo | once per repo |
| Lighthouse / perf runs | no | one run when a page budget exists | as performance flag requires |

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
