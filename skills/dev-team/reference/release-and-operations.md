# Release, production and maintenance

## Environments

| Environment | Who deploys | Data |
|---|---|---|
| dev (local) | agents | fake/seed data |
| staging | agents (release-engineer), after tests pass | test data only, never production copies with personal data |
| production | **human only**, or an agent after an explicit human "yes" for that specific release | real data, never accessed by agents |

## Release checklist (release-engineer prepares; a human approves production)

`.dev/releases/<version>.md`:
- [ ] Scope: merged PRs and prompt ids in this release.
- [ ] All evidence packages complete, PM acceptance done (or explicitly waived by the user).
- [ ] CI green on the release commit; security scans clean or justified.
- [ ] Migrations: tested on a staging copy, reversible or with a documented forward-fix plan, timed for large tables.
- [ ] Feature flags for risky features; default state defined.
- [ ] Staging smoke test passed (scripted, with output saved).
- [ ] Rollback plan: exact steps, the time it takes, who can run it.
- [ ] Monitoring: error tracking, uptime, key metrics/alerts exist for the new features.
- [ ] Backups verified (a restore test within the last 30 days for production databases).
- [ ] Release notes (user-facing) and CHANGELOG.
- [ ] **Human approval recorded** (name, date) before the production deploy.

After the deploy: smoke test in production (read-only checks), 30–60 min of watching errors and metrics, then record the result in the release file.

## Runbooks (`.dev/runbooks/`)

Created during the first release and kept current:
- `deploy.md`: how to deploy and how to roll back.
- `incident.md`: severity levels, who to call, first steps, communication, and a postmortem template (blameless, with actions).
- `backup-restore.md`: what is backed up, where, retention, and restore steps with the last tested date.
- `secrets-rotation.md`: where each secret lives and how to rotate it.
- `monitoring.md`: dashboards, alerts, thresholds, and what each alert means.

## Maintenance mode (`/paiasa-dev:dev-team maintain`)

Run regularly (weekly light, monthly full). Each item becomes a normal task with triage and review:
1. **Dependencies**: list outdated/vulnerable packages; group safe patch updates in one PR; handle major updates as separate tasks with changelog review.
2. **Security**: run all scans; monthly full audit per security.md Layer 5.
3. **Errors & incidents**: read error tracking/logs that the user exports or connects (never production data dumps), group by root cause, and create fix tasks with reproduction steps.
4. **Performance**: compare against budgets; find regressions; create tasks.
5. **Technical debt**: review the debt register (ADRs and tech-assessment shortcuts) and propose what to repay.
6. **Architecture review report for the human Tech Lead (monthly)**: where the system is heading as a whole, coupling hotspots, growth risks. This is the one review that looks at the trend, not at individual diffs.
7. **Backups & runbooks**: verify the last restore test date and update stale runbooks.

Output: `.dev/maintenance/<YYYY-MM-DD>.md` with findings, created tasks, and decisions needed from the user.
