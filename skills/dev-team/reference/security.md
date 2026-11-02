# Security baseline

Security is layered. No single agent is trusted to catch everything, and the automated layers do not depend on AI judgment.

## Layer 1: rules every agent follows (put these in the project CLAUDE.md)

- Never commit secrets. Configuration comes from environment variables or a secret manager; `.env*` files are in `.gitignore`, and `.env.example` holds placeholders only.
- Validate all input on the server (type, length, format, allow-lists). Never trust client-side validation alone.
- Check authorization on the server for every request that reads or changes data. Prefer deny-by-default. Test the "other user's resource" case (IDOR).
- Use parameterized queries or the ORM. No string-built SQL.
- Encode output to prevent XSS. Sanitize user-generated HTML with a vetted library.
- Hash passwords with a modern algorithm (argon2id/bcrypt) via a maintained library. Never write your own crypto.
- Sessions/tokens: secure, httpOnly, SameSite cookies or short-lived tokens with rotation. Add CSRF protection where cookies authenticate.
- Rate-limit authentication and expensive endpoints.
- Logs: no passwords, tokens or full card/ID numbers; mask personal data.
- Use minimal privileges for database users, cloud roles and API keys.
- File uploads: check type and size, store outside the web root, and never execute them.
- Webhooks: verify signatures; handle them idempotently.
- Dependencies: pinned via lockfile, from official registries only. Review every new dependency (maintenance, popularity, license, known CVEs).
- Personal data: collect the minimum; define retention; support deletion/export where the law requires it (e.g. GDPR).

## Layer 2: automated scans (set up during onboarding; run in CI on every PR)

Pick what fits the stack. Prefer tools the project already uses.

| Purpose | Options |
|---|---|
| Static analysis (SAST) | Semgrep, CodeQL |
| Dependency vulnerabilities | `npm audit` / `pnpm audit`, `pip-audit`, `composer audit`, Dependabot/Renovate |
| Secret scanning | gitleaks (also as a pre-commit hook), GitHub secret scanning |
| Container/IaC | Trivy, Checkov |
| Dynamic scan on staging (DAST) | OWASP ZAP baseline |

Setting up CI or installing tools changes the project: propose the exact setup to the user and do it after a yes.

## Layer 3: security-reviewer agent

Runs for every task with the `security` flag (see risk-triage.md), using the OWASP Top 10 and ASVS-style checklist in its instructions. Findings use the standard format. Critical or significant findings block the PR.

## Layer 4: threat model per sensitive feature

For features with the security flag, the security-reviewer writes 5–10 lines in `.dev/tasks/<id>/threat-model.md`: assets, actors, entry points, abuse cases, and mitigations, each mapped to a test or control.

## Layer 5: periodic full audit (maintenance mode)

Monthly, or before each major release: a whole-system review, not only diffs. It covers auth flows end-to-end, authorization matrix, data flows of personal data, dependency tree, configuration, logging, backups. Some vulnerabilities only appear from combinations of individually harmless changes.

## Layer 6: humans

- The human Tech Lead reviews every PR with the security flag on auth, payments or personal data.
- Before launching a product with payments or sensitive data, recommend an **external penetration test** to the user.

## Hard limits for agents

- No access to production data or production secrets. Agents work with dev/staging and test data only.
- No disabling of security controls, scans or hooks to make something pass.
- If a real secret is found in the repo or history: stop, tell the user immediately, and recommend rotating it. Do not try to rewrite git history without the user's yes.
