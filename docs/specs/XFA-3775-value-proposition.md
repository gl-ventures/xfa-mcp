# XFA-3775: marketplace listings use the xfa.tech value proposition

## Problem

The listing text for the XFA MCP server (README, MCP Registry, Gemini, Cursor,
ChatGPT) still called XFA "a BYOD device-trust platform" and described the server
as querying "device posture". xfa.tech now describes XFA differently, and the
server itself was renamed to "XFA device security" in
[gl-ventures/xfa-api#892](https://github.com/gl-ventures/xfa-api/pull/892).

## Source of truth

Lars, 2026-11-08: "the new value proposition is xfa.tech". Wording comes from
xfa.tech `public/llms.txt` on main and the server instructions in xfa-api#892
(`lambdas/api-mcp/main.go`, `instructionsText`):

- XFA checks every device at sign-in and guides people to fix issues themselves.
- Category word: "device security". Never "device trust".
- Fixing: a Fix button the person approves, or a step by step guide; XFA checks again.
- Company, personal and contractor laptops and phones, no MDM. Warns early, blocks
  only when the organization chooses to.
- The server: read-only, scoped to the one organization the signed-in user approves;
  answers questions about the organization's devices, their check results, how well
  they meet its policy, and software versions and CVEs.

## Decisions

- Only descriptive text changes. Names, ids, URLs and tool names stay the same
  (tool names checked against xfa-api#892).
- `server.json` gets a `title` of "XFA device security", matching the server's
  own title in xfa-api#892. Schema limit: 100 characters for `title` and
  `description`; the new description is 96.
- `server.json` version 0.1.2 → 0.1.3: the MCP Registry rejects a republish of an
  existing version. Gemini and Cursor manifest versions stay at 0.1.0 (the
  Gemini gallery crawls the repo; the Cursor listing is still pending review).
- ChatGPT `subtitle` kept to 30 characters, like the old one (28).
- Cursor keyword `device-trust` → `device-security`.
- `get_posture_trends` justifications in the ChatGPT file keep "posture": they
  describe the tool's data, not XFA.

## Before / after

| Where | Before | After |
| --- | --- | --- |
| README intro | XFA is a BYOD device-trust platform. This is XFA's remote MCP server — query your organization's device posture, compliance, policies, and software/CVE status from Claude, ChatGPT, Cursor, and other AI assistants. Read-only. | XFA checks every device at sign-in and guides people to fix issues themselves: they press Fix and approve the suggested fix, or follow a step by step guide, and XFA checks again. It covers company, personal and contractor laptops and phones with no MDM, warns people early, and blocks a sign-in only when your organization chooses to. / This is XFA device security, XFA's remote MCP server. Ask Claude, ChatGPT, Cursor and other AI assistants about your organization's devices, their check results, how well they meet your policy, and software versions and known vulnerabilities (CVEs). Read-only, and scoped to the one organization you approve when you sign in. |
| README tools: `get_compliance_summary` | Org-wide compliance summary | How well the organization meets its policy |
| README tools: `get_posture_trends` | Posture trends over time | Check results over time |
| server.json `title` | (none) | XFA device security |
| server.json `description` | XFA's remote MCP server — query device posture, compliance, policies & CVEs. Read-only. | XFA device security, read-only: your organization's devices, check results, compliance and CVEs. |
| server.json `version` | 0.1.2 | 0.1.3 |
| gemini-extension.json `description` | XFA's remote MCP server — query your organization's device posture, compliance, policies, and software/CVE status from Gemini. Read-only. | XFA device security in Gemini: ask about your organization's devices, their check results, how well they meet your policy, and software versions and CVEs. Read-only. |
| .cursor-plugin/plugin.json `description` | XFA's remote MCP server — query your organization's device posture, compliance, policies, and software/CVE status from an AI assistant. Read-only. | XFA device security in your AI assistant: ask about your organization's devices, their check results, how well they meet your policy, and software versions and CVEs. Read-only. |
| .cursor-plugin/plugin.json `keywords` | device-trust | device-security |
| ChatGPT `subtitle` | Query your device-trust data | Ask about your device security |
| ChatGPT `description` | XFA's remote MCP server lets your team query their organization's device posture, compliance summary, policies, and tracked-software/CVE status from ChatGPT. Read-only and scoped to the single organization the signed-in user approves. | XFA checks every device at sign-in and guides people to fix issues themselves, on company, personal and contractor laptops and phones, with no MDM. Ask ChatGPT about your organization's devices, their check results, how well they meet your policy, and software versions and known vulnerabilities (CVEs). Read-only, and scoped to the one organization the signed-in user approves. |
| ChatGPT test case `list_devices` expected output | … with their trust status. | … with their check results. |
| ChatGPT negative test case (weather) | … outside its device-trust workflows. | … outside its device security questions. |

`mcp.json` has no descriptions and is unchanged.

## How to validate

- `jq . <file>` parses for every JSON file.
- The `MCP Registry` workflow runs `mcp-publisher validate server.json` on this PR.
- `grep -rni 'device.trust'` finds nothing outside the changelog.

## Left

- Merge xfa-api#892 so the live server's title and instructions match.
- After merge to main, the `MCP Registry` workflow publishes 0.1.3 to the
  registry. Glama, Smithery, PulseMCP and mcp.so pick it up from there.
- Claude Connectors Directory: update the listing text by hand to match.
- ChatGPT app directory: resubmit `chatgpt-app-submission.json`.
- Cursor Marketplace: the listing is still pending; update the submission if
  Cursor reads the text from the form rather than `plugin.json`.
- Gemini: nothing to do, the gallery recrawls the repo.
