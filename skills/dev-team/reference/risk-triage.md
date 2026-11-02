# Risk triage

Every task gets a risk profile **before** implementation. Two layers, both mandatory. The union of the flags is what counts.

## Layer 1: judgment (orchestrator + codebase-analyst)

| Flag | Raise when |
|---|---|
| `architecture` | changes system structure, module boundaries, data model/schema, introduces a service, queue, cache or new infrastructure, or changes a public API contract |
| `clarity` | any requirement or acceptance criterion has more than one reasonable interpretation that changes behavior |
| `performance` | large data sets, lists without pagination, loops over DB/API calls, real-time, file processing, heavy pages, or a stated performance budget |
| `novelty` | no comparable pattern exists in the codebase, and no well-documented standard solution exists |
| `security` | auth, sessions, authorization/roles, payments, personal or sensitive data, file upload, user-generated content rendering, external webhooks, secrets, crypto, admin functions |

The prompt's own `risk_flags` (from the PM team) are always included, and can only be added to, never removed.

## Layer 2: deterministic rules (always applied, regardless of judgment)

Check the planned change, then re-check against the actual diff before review:

| Rule | Flags forced |
|---|---|
| Paths matching `auth`, `login`, `session`, `permission`, `role`, `acl`, `admin`, `payment`, `billing`, `checkout`, `webhook`, `crypto`, `secret`, `token` | security |
| Database migrations, schema files, ORM model changes | architecture, security (data) |
| New or upgraded dependency in any manifest/lockfile | security |
| Diff touches > 15 files or > 3 top-level modules | architecture |
| Changes to CI/CD, Docker, infrastructure-as-code, env config | security, architecture |
| New endpoint, or a query on a table expected > 10k rows | performance |
| Any `.env*`, key or certificate file in the diff | **block**: secrets must never be committed |

Projects can add rules in `.dev/risk-rules.md` (e.g. from the PM team's team.md "mandatory gates"). Read it if present.

## What each flag activates

| Flag | Required before PR | Agent |
|---|---|---|
| (always) | code review + risk guardian | code-reviewer, risk-guardian |
| architecture | ADR written and reviewed; architecture rules respected; human approval of the ADR for major changes | architecture-guardian |
| clarity | stop: questions file for the PM team; no implementation of the ambiguous part | orchestrator |
| performance | performance budget defined; query/bundle analysis; load test on staging for endpoints with a budget | performance-engineer |
| novelty | spike: research + 2–3 time-boxed prototypes + recommendation with uncertainty; human picks | researcher |
| security | security review with checklist; automated scans pass; human review for auth/payments | security-reviewer |

## Record

Write the profile at the top of `.dev/tasks/<task-id>/triage.md`:
```
Flags: security, performance
Layer 1 reasons: ...
Layer 2 rules hit: payment path, new dependency (stripe@x)
Activated: security-reviewer, performance-engineer
Human gates: security review of webhook handler by Tech Lead
```
