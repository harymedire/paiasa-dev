#!/usr/bin/env bash
# PAIASA DEV guard: PreToolUse hook for Bash.
# Active only in projects that contain a .dev/ folder (i.e. run by the PAIASA DEV team).
# Blocks: force-push, direct push to main/master, hard reset to a remote branch,
# and committing .env files. Exit code 2 blocks the call; stderr is shown to Claude.

input="$(cat)"

# Project dir: cwd from the hook input (JSON-escaped on Windows), else $PWD.
cwd="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | sed 's#\\\\#/#g')"
[ -n "$cwd" ] && [ -d "$cwd" ] || cwd="$PWD"

root="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || printf '%s' "$cwd")"
[ -d "$root/.dev" ] || [ -d "$cwd/.dev" ] || exit 0

# The Bash command (best effort without jq); fall back to the whole input.
cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(\([^"\\]\|\\.\)*\)".*/\1/p')"
[ -n "$cmd" ] || cmd="$input"

block() {
  echo "PAIASA guard blocked this command: $1" >&2
  echo "Humans merge to the default branch and approve force operations. Open a draft PR from a task branch instead." >&2
  exit 2
}

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push'; then
  if printf '%s' "$cmd" | grep -Eq -- '(--force([[:space:]]|$|=)|--force[^-]|[[:space:]]-f([[:space:]]|$)|[[:space:]]\+[^[:space:]]+)'; then
    block "force-push"
  fi
  if printf '%s' "$cmd" | grep -Eq '(^|[[:space:]:])(main|master)([[:space:]]|$)'; then
    block "direct push to main/master"
  fi
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+reset[[:space:]]+--hard[[:space:]]+[^[:space:]]*(origin|upstream)/'; then
  block "hard reset to a remote branch"
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+add[[:space:]].*\.env' && \
   ! printf '%s' "$cmd" | grep -Eq '\.env\.(example|sample|template)'; then
  block "adding a .env file (secrets must never be committed)"
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+commit'; then
  staged="$(git -C "$root" diff --cached --name-only 2>/dev/null | grep -E '(^|/)\.env($|\.)' | grep -Ev '\.env\.(example|sample|template)$')"
  if [ -n "$staged" ]; then
    block "a .env file is staged: $staged"
  fi
fi

exit 0
