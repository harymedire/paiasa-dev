# Evidence package

How much evidence depends on the profile (profiles.md):

| Profile | Where | Contents |
|---|---|---|
| prototype | the PR description (no separate file) | AC table (AC → test → pass), CI or local test result line, 2–4 screenshots for UI, follow-ups added |
| standard | `.dev/evidence/<prompt-id>.md`, one screen, written by the orchestrator | the same, plus reviewers that ran and their verdicts, deviations |
| production | full package below, written by the evidence-reporter | everything below |

Short form (prototype/standard):

```markdown
## Evidence: P-04 Login
| AC | Test | Result |
|---|---|---|
| AC1 | auth.spec.ts › "logs in with valid credentials" | pass |
Build/tests: pass (142 tests, CI run <link>) · Reviews: CR ok, RISK ok, SEC ok (1 follow-up → FU-012)
Screens: <links> · Deviations: none
```

## Full package (production)

Written by the evidence-reporter for every production task. It goes back to the PM team (`/paiasa-pm:pm-team accept <path>`) and to the human reviewers. It must be verifiable: link or attach every artifact. A claim without an artifact is not evidence.

Path: `.dev/evidence/<prompt-id>-<slug>.md`, with artifacts in `.dev/evidence/<prompt-id>/` (screenshots, test logs, scan reports, load-test results).

```markdown
# Evidence: <prompt id> <title>
- Prompt: <path or id>
- Branch / PR: <branch>, <PR URL or "local only">
- Commit(s): <sha>
- Date: <YYYY-MM-DD>
- Risk flags: <...>  | Human gates required: <...>

## Acceptance criteria
| AC | Status | Test(s) | Evidence |
|---|---|---|---|
| AC1 | met | tests/booking.spec.ts › "rejects overlapping slot" | test log line / screenshot |
| AC2 | not met | | reason |

## Checks
| Check | Result | Artifact |
|---|---|---|
| Unit/integration tests | 142 passed, 0 failed | logs/tests.txt |
| Lint / typecheck / build | pass | logs/build.txt |
| Code review | 0 open blocking | review.md |
| Risk guardian | 0 open | risk.md |
| Security review + scans | pass / n.a. | security.md, scans/ |
| Architecture (ADR) | ADR-004 approved by <human> / n.a. | docs/adr/004.md |
| Performance | p95 210 ms @ 200 rps (budget 300) / n.a. | perf/k6.txt |
| UI verification | mobile + desktop screenshots | screens/ |

## Staging
URL, test account reference (never the password), what to click to see the feature.

## Deviations from the prompt
Better approach taken / scope differences / assumptions made, with reason. These go to the PM decision log.

## Open items
Known limitations, follow-ups, questions for PM.
```
