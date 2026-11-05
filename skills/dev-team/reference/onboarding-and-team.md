# Onboarding a project and shaping the team

## Project state: `.dev/STATE.md`

```markdown
# DEV state
- Project: <name> | Repo: <path / remote> | Default branch: <main>
- Mode: new | resume | adopt-existing | maintain
- Stack: <languages, frameworks, DB, hosting>
- Commands: test=<...> lint=<...> typecheck=<...> build=<...> run=<...> e2e=<...>
- Git host / tickets: <GitHub|GitLab|none> / <Jira|ClickUp|files>
- Team file: .dev/team.md (from PM team.md: yes/no)
- Last updated: <date>

## Tasks
| Prompt | Status (queued/ready/blocked/in-progress/in-review/pr-open/merged/accepted) | Branch | PR | Notes |

## Waiting on humans
- <PR review / ADR approval / production approval / question>

## Next step
<exactly what the next run should do first>
```

## New project

1. Confirm the stack with the PM handoff (README project rules, tech-assessment if supplied). If none is given, propose a stack with reasons and ask the user once.
2. Scaffold the minimum with the framework's official generator: repo, test runner, linter/formatter, typecheck, `.gitignore`, `.env.example`, and a README with run/test commands.
3. Write the project **CLAUDE.md** (see below).
4. Propose CI (tests, lint, build, security scans) and project hooks (see below). Apply them after the user's yes.
5. Fill `.dev/STATE.md`.

## Adopting an existing project (someone else started it)

Do not change code before you understand it.
1. **codebase-analyst** → `.dev/audit/codebase-map.md`: structure, stack, conventions, how to run/test, test coverage, dependency health, obvious risks.
2. Run the existing tests/build and record the result honestly, even if broken.
3. **security-reviewer** (audit mode) + automated scans → `.dev/audit/security.md`.
4. **architecture-guardian** (audit mode) → `.dev/audit/architecture.md`: current architecture, debt, coupling hotspots, missing ADRs.
5. Write `.dev/audit/health-report.md`: a summary for the user with prioritized improvement proposals (each one a candidate task, with effort/risk/benefit). **Don't refactor without approval.** New features come first; improvements go in as separate tasks when they make the new work safer or faster.
6. Write or extend CLAUDE.md to match the conventions the code **actually** uses.

## Project CLAUDE.md (in the repo root, shared with human developers)

Keep it short and factual:
- What the product is (2 lines) and where the PM docs are.
- Stack and versions; how to run, test, lint, build.
- Conventions: structure, naming, error handling, logging, i18n.
- Architecture rules (what must not depend on what).
- Security rules (security.md Layer 1, adapted).
- Definition of done (link).
- Environments and who may deploy where.

## Project hooks (proposed during onboarding, written to `.claude/settings.json` after a yes)

Deterministic checks that do not depend on an agent remembering:
- **PostToolUse on Edit|Write**: run the formatter/linter on the changed file (fast commands only).
- **Stop** (optional): run the fast test subset before the agent ends a turn.
Keep hooks fast (seconds). Slow suites belong in CI.

The PAIASA DEV plugin also ships a guard hook that is active only in projects that contain a `.dev/` folder. It blocks force-push, pushing directly to main/master, `git reset --hard` on remote branches, and committing `.env` files.

## Shaping the agent team from `team.md`

If the user supplies the PM team's `team.md` (or the PM handoff folder):
1. Copy it to `.dev/team.md`.
2. **Extra specialist agents**: for each one, create a project agent file `.claude/agents/<name>.md` with frontmatter (`name`, `description`, `tools`, `model`) and focused instructions built from team.md and the relevant official docs (fetch them; link them in the agent). Spawn them by plain name (`subagent_type: "<name>"`). Tell the user which agents you created; they live in the repo, so the human team gets them too.
3. **Model overrides**: record them in `.dev/team.md` and pass them as the Agent tool `model` parameter when spawning that agent for that task. Tier mapping: **top → `fable`**, **strong → `opus`**, **fast → `sonnet`**.
4. **Mandatory gates**: append them to `.dev/risk-rules.md` so triage enforces them.
5. Project-specific rules → CLAUDE.md.

Without team.md the default team is used. You may still create a specialist agent yourself if the project clearly needs one (e.g. payments, maps, ML). Say why in one line.

## Default models (in each agent's frontmatter)

| Agent | Model | Why |
|---|---|---|
| architecture-guardian, security-reviewer | fable | hardest judgment; costly mistakes |
| implementer, test-engineer, code-reviewer, risk-guardian, performance-engineer, release-engineer, researcher | opus | strong coding and review across long tasks |
| codebase-analyst, ui-verifier, evidence-reporter | sonnet | mapping, browser checks, assembly; fast |

For a task with `architecture`, `security` or `novelty` flags, spawn the **implementer with `model: "fable"`**, unless a user override in `.dev/team.md` says otherwise.

## User overrides

The user can change models, review rounds and reviewers at any time (typical case: a demo phase on synthetic data with a full review planned before production). Record each override as a block in `.dev/team.md`; never delete old blocks, mark them `superseded`.

```markdown
## Override O-2: demo phase
- Date: 2026-11-06 | Status: active | Effective from: next task after P-02 (current task not interrupted)
- Reason (user's words): demo uses synthetic data only; full security review before production (plan §4.2, ToR 7.1)
- Models per task:
  - P-03, P-05, P-10, P-11: implementer=fable, security-reviewer=fable; architecture-guardian=fable on P-05, P-11
  - all other tasks: implementer=opus, security-reviewer=opus, architecture-guardian=opus
- Unchanged: code-reviewer, risk-guardian run on every task (their default models)
- Review rounds: max 2, then escalate to <the user>
- Pre-production gate added: RR-7 in .dev/risk-rules.md
```

### Resolving the model and the round limit

Before spawning an agent for a task, take the first rule that matches:
1. an active user override naming this task and this agent;
2. an active user override naming this agent for "all other tasks" or for all tasks;
3. a model override from the PM `team.md`;
4. the flag rule above (implementer on fable for architecture/security/novelty);
5. the agent's frontmatter default.

Round limit: the active override's value, else the PM `team.md` value, else 3. Write the resolved model per agent and the round limit into the task's `triage.md`, so the evidence package shows what ran.

What an override cannot change: the non-negotiable rules, code-reviewer and risk-guardian on every task, a security review on tasks with a security flag (only its model and rounds can change), tests from acceptance criteria, humans merging and approving production. If a request would break one of these, say which rule and ask.

### Pre-production gate for lowered review strength

When an override makes review weaker than the defaults (cheaper model, fewer rounds, a reviewer skipped), append to `.dev/risk-rules.md`:

```markdown
## RR-7 (pre-production gate, from override O-2)
- Before any production release: a full security review (security-reviewer and architecture-guardian on fable, max 3 rounds) of the modules changed by tasks <list> must pass with zero open critical/significant findings.
- Source: user override O-2 (<date>); plan reference if given (e.g. plan §4.2, ToR 7.1).
```

The release-engineer and the orchestrator treat this gate as blocking at release (SKILL.md Phase 4). It is closed only with evidence, never by a later override that just removes it. Removing it needs the user's explicit yes for that.
