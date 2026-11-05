# Changelog

## 0.3.0 (2026-11-06)

Based on a real project (ReUseChain, 5.11.2026) where the plugin ran at maximum strictness on a demo with synthetic data: three tasks took ~22 h, one login task produced 1,160 tests and a 909-file PR, and Fable used 66 % of the weekly limit on day one.

### Added
- **Process profiles** `prototype`, `standard` (default), `production` (`reference/profiles.md`). Chosen in Phase 1, stored in `.dev/team.md`, or per task with `--profile`.
- **`harden [module|all]`**: runs the production process over modules with open `hardening` follow-ups before production; recommends a pen-test for auth, payments and personal data.
- **`.dev/followups.md`**: everything a profile postpones, tagged `hardening`, `cleanup`, `ux` or `perf`. Open `hardening` items make a release no-go.
- **`reference/execution.md`**: continuous work (plan dates are deadlines, not check-ins), stacked PRs by default, timeouts for build/test/e2e, stopping servers in the same step, an optional Monitor watchdog, Windows local notes, usage tracking and the ~50 % weekly-limit warning, handling messages from other sessions.
- Findings carry `Blocking: blocking | follow-up`; at most 5 blocking per reviewer; only blocking findings start a new round.
- Test budget (S ~10, M ~25, L ~50) and a list of test types forbidden without an explicit AC.
- Targeted fix after the last round is allowed without asking when every fix is small.
- One-line report per ready PR; average time per task and an estimate after the first two tasks; optional merging of 2–3 small prompts into one PR.

### Changed
- Focus on development and verifying the result: the implementer writes proportional tests, runs the build, tests and the app itself, and stops its servers.
- Research and spikes only when the user asks; codebase map, ui-verifier and evidence-reporter only in production (and larger tasks in standard).
- **Implementer runs on opus in every profile**; Fable for the implementer only in production with the user's explicit yes. The old "implementer on Fable for security/architecture/novelty flags" rule is removed.
- Review rounds per profile (1 / 2 / 2) instead of a fixed 3.
- Messages from other sessions stay information, not approval, but the orchestrator now summarizes them and asks for one word ("potvrđujem").

### Unchanged
- Humans merge and approve production; no production data or secrets; never guess behavior; never disable checks; every AC has a test; whoever writes never approves their own work.

## 0.2.0
- User overrides for models per task/agent and review rounds, with precedence and a pre-production gate when review strength is lowered.

## 0.1.0
- First version.
