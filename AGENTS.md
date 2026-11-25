# AGENTS.md

This repository is PUBLIC and customer-facing. Everything in it, including
specs, changelog, commit messages and PR text, is readable by anyone.

## Rules

- Describe only what a customer's connection offers: the customer tools, their
  fields and their limits.
- Never mention staff or system-administrator tools, internal analytics,
  internal role names, other repositories' internal pull requests or code paths,
  people's names, test accounts, or infrastructure.
- Specs in `docs/specs/` are public too. Write them for that audience: the
  problem, the decisions and why, how to validate, what is left. Say "customer-facing
  text only" where a decision is about scope; do not quote internal chat.
- Listings (README, `server.json`, `chatgpt-app-submission.json`,
  `gemini-extension.json`, `.cursor-plugin/plugin.json`,
  `listings/`) must match what the live customer tools do.

## Check before every push

CI runs `scripts/check-public.sh` on every pull request and on main. Run it
locally first:

```
scripts/check-public.sh
```

It fails when a tracked file matches `staff`, `system_admin`, `system admin`,
`internal`, `athena` or `analytics_` (case-insensitive). Real false positives go
in `scripts/check-public-allowlist.txt`, one `path:line text` entry per line
(a fixed string matched against the `git grep -n` output line).
