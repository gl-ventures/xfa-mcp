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

- User-driven device security. Main value: "Verify device security at sign-in"; "Discover all devices" comes second.
- When a check fails, people fix it themselves.
- Category word: "device security". Never "device trust".
- Fixing: a Fix button the person approves, where XFA offers one, or a step by step
  guide; XFA checks again.
- Company, personal and contractor laptops and phones, no MDM. Warns people first;
  your organization's settings decide what gets blocked.
- The server: read-only, scoped to the one organization the signed-in user approves;
  answers questions about the organization's devices, their check results, how well
  they meet its policy, and whether the OS and last-used browser are up to date, and known vulnerabilities (CVEs).

## Decisions

- Lars, 2026-11-09: the two feature names are "Discover all devices" and "Verify
  device security at sign-in". "Discovery" and "Enforcement" are out.
- Lars, 2026-11-09: "XFA checks every device" stays in the README and ChatGPT
  text. It is the marketing value; application filters and Skip managed devices
  are the exception.
- 2026-11-09: "blocks only when your organization chooses" became "depends on the
  organization's policy and plan", because the plan decides too.
- 2026-11-09: "software versions and CVEs" read as an inventory of the
  organization's software. Per device the server only knows the OS and last-used
  browser; the version tools read XFA's global catalog. Listings now say "whether the OS and
  last-used browser are up to date".
- Only descriptive text changes. Names, ids, URLs and tool names stay the same
  (tool names checked against xfa-api#892).
- `server.json` gets a `title` of "XFA device security", matching the server's
  own title in xfa-api#892. Schema limit: 100 characters for `title` and
  `description`; the new description is 95.
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
| README intro | XFA is a BYOD device-trust platform. This is XFA's remote MCP server — query your organization's device posture, compliance, policies, and software/CVE status from Claude, ChatGPT, Cursor, and other AI assistants. Read-only. | [XFA](https://xfa.tech) is user-driven device security that keeps work moving. Its main value is **Verify device security at sign-in**: XFA checks every device at sign-in and warns people first. People are prompted to install the XFA app themselves at their first sign-in, and they fix issues themselves: they press Fix and approve the suggested fix where XFA offers one, or follow a step by step guide, and XFA checks again. It covers company, personal and contractor laptops and phones, with no IT team or MDM needed; your organization's settings decide what gets blocked. XFA can also **Discover all devices** through your identity provider. |
| README tools: `get_compliance_summary` | Org-wide compliance summary | How well the organization meets its policy |
| README tools: `get_posture_trends` | Posture trends over time | A few check figures over time |
| server.json `title` | (none) | XFA device security |
| server.json `description` | XFA's remote MCP server — query device posture, compliance, policies & CVEs. Read-only. | XFA device security, read-only: which devices pass their checks or have known vulnerabilities. |
| server.json `version` | 0.1.2 | 0.1.3 |
| gemini-extension.json `description` | XFA's remote MCP server — query your organization's device posture, compliance, policies, and software/CVE status from Gemini. Read-only. | XFA device security in Gemini, read-only: see which of your organization's devices pass their security checks, which need fixing, and which have known vulnerabilities (CVEs). Never shows owners' names or emails. |
| .cursor-plugin/plugin.json `description` | XFA's remote MCP server — query your organization's device posture, compliance, policies, and software/CVE status from an AI assistant. Read-only. | XFA device security, read-only: see which of your organization's devices pass their security checks, which need fixing, and which have known vulnerabilities (CVEs). Never shows owners' names or emails. |
| .cursor-plugin/plugin.json `keywords` | device-trust | device-security |
| ChatGPT `subtitle` | Query your device-trust data | See which devices pass checks |
| ChatGPT `description` | XFA's remote MCP server lets your team query their organization's device posture, compliance summary, policies, and tracked-software/CVE status from ChatGPT. Read-only and scoped to the single organization the signed-in user approves. | Ask about the devices in your XFA organization: which ones pass their security checks, which need fixing, and how that changes over time. XFA is user-driven device security. It checks the security of every device when someone signs in to work apps, on company-owned, personal and contractor laptops and phones, and warns people first. People install the XFA app themselves at their first sign-in, and when a check fails they fix it themselves, with the Fix button where XFA offers one or a step by step guide. XFA also finds devices through your sign-in system (your identity provider). This connector lets the assistant read those results. It cannot change anything, and it never shows the names or emails of the people who own the devices. (then what you can ask, intended users, what it reads, limits) |
| ChatGPT test case `list_devices` expected output | … with their trust status. | … with their check results. |
| ChatGPT negative test case (weather) | … outside its device-trust workflows. | … outside its device security questions. |

`mcp.json` has no descriptions and is unchanged.

## How to validate

- `jq . <file>` parses for every JSON file.
- The `MCP Registry` workflow runs `mcp-publisher validate server.json` on this PR.
- `grep -rni 'device.trust'` finds nothing outside the changelog and this spec.

## Review (2026-11-09)

A second fresh review found: the server returns no browser version, only the
last-used browser's name and whether it is up to date; no tool returns sign-in
data, so the Registry line no longer says "sign-in checks".

- Lars, 2026-11-09: "XFA checks every device" and "warns people first" stay in the README and ChatGPT text. They are the marketing value; settings are the exception.

- Lars, 2026-11-09: Verify device security at sign-in is the actual value (self-install, Fix buttons); user-driven leads (2026-10-12); Discover all devices comes second.

- Assumption, Lars can veto (2026-11-10): the Registry, Gemini and Cursor descriptions lead with the same message as the README, not only with what you can ask the server.

## Research and final copy (2026-11-10)

Lars rejected leading the short listings with the pitch on assumption and asked
for research, then a fresh read of xfa.tech. Findings: about 7 in 10 official
one-liners open with what you can do (Linear, Atlassian, GitHub); value-first
ones switch to actions in the next sentence. Anthropic policy 2.B wants listing
text to match what the connector does, and this connector only reads results.
Claude listing edits wait for review; an OpenAI change is a new reviewed
version, so the first submission must already be defensible.

So: short fields (Registry 100, Claude one-liner 200, ChatGPT subtitle 30,
Cursor, Gemini) say what you can ask, read-only, and that owners' names and
emails are never shown. Long descriptions (ChatGPT, Claude directory) open with
Lars's message in the site's words, then what you can ask, intended users,
what it reads and its limits. The Claude directory text lives in
`listings/claude-connectors-directory.md`, ready to paste.

Zero-context readers (haiku, sonnet, gpt-5.6-luna) as an IT admin: all three
got what it does, that it changes nothing, and that it never shows owners'
names. Fixed from their notes: Registry line was 105 characters; privacy wording
differed per surface; "XFA" unexplained in short lines; "your rules" vs "XFA's
checks". Kept on Lars's decision: "every device", "warns people first",
"user-driven".

## Left

- Merge xfa-api#892 so the live server's title and instructions match.
- After merge to main, the `MCP Registry` workflow publishes 0.1.3 to the
  registry. Glama, Smithery, PulseMCP and mcp.so pick it up from there.
- Claude Connectors Directory: update the listing text by hand to match.
- ChatGPT app directory: resubmit `chatgpt-app-submission.json`.
- Cursor Marketplace: the listing is still pending; update the submission if
  Cursor reads the text from the form rather than `plugin.json`.
- Gemini: nothing to do, the gallery recrawls the repo.
- Notify Anthropic of the changed descriptions (Software Directory Policy 3.H).
- The GitHub repo topic `device-trust` should change to match; not done in this PR.
