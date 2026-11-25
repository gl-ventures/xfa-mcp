# Marketplace listings use the xfa.tech value proposition

## Problem

The listing text for the XFA MCP server (README, MCP Registry, Gemini, Cursor,
ChatGPT) still called XFA "a BYOD device-trust platform" and described the server
as querying "device posture". xfa.tech now describes XFA differently, and the
server is titled "XFA device security".

## Decisions

- Wording follows the xfa.tech site. Main value: "Verify device security at
  sign-in"; "Discover all devices" comes second. Category word: "device security",
  never "device trust".
- When a check fails, people fix it themselves: a Fix button they approve where
  XFA offers one, or a step by step guide; XFA then checks again.
- Company, personal and contractor laptops and phones, no MDM. XFA warns people
  first; the organization's settings decide what gets blocked.
- "XFA checks every device" stays in the README and ChatGPT text: it is the
  product message, and application filters and skipped managed devices are the
  exception.
- The server is read-only and answers questions about the organization's devices,
  their check results, how well they meet its policy, and known vulnerabilities (CVEs).
- Only descriptive text changes. Names, ids, URLs and tool names stay the same.
- `server.json` gets a `title` of "XFA device security". Schema limit: 100
  characters for `title` and `description`; the new description is 94.
- `server.json` version 0.1.2 to 0.1.3: the MCP Registry rejects a republish of an
  existing version. Gemini and Cursor manifest versions stay at 0.1.0.
- ChatGPT `subtitle` kept to 30 characters, like the old one (28).
- Cursor keyword `device-trust` becomes `device-security`.
- `get_posture_trends` justifications in the ChatGPT file keep "posture": they
  describe the tool's data, not XFA.
- Short fields (Registry 100, Claude one-liner 200, ChatGPT subtitle 30, Cursor,
  Gemini) say what you can ask and that it is read-only. Long descriptions
  (ChatGPT, Claude directory) open with the product message in the site's words,
  then what you can ask, what it reads and its limits; ChatGPT also has intended
  users. "People who use the devices", not "owners", on every surface.
- The Claude directory text lives in `listings/claude-connectors-directory.md`,
  ready to paste.
- Listings describe only what a customer's connection offers (customer-facing
  text only).

## Before / after (main points)

| Where | Before | After |
| --- | --- | --- |
| README intro | XFA is a BYOD device-trust platform ... query your organization's device posture ... | XFA is user-driven device security that keeps work moving; Verify device security at sign-in; Discover all devices. |
| README tools: `get_compliance_summary` | Org-wide compliance summary | How well the organization meets its policy |
| README tools: `get_posture_trends` | Posture trends over time | A few check figures over time |
| server.json `title` | (none) | XFA device security |
| server.json `description` | XFA's remote MCP server, query device posture, compliance, policies & CVEs. Read-only. | XFA device security, read-only: which devices pass their checks or have known vulnerabilities. |
| server.json `version` | 0.1.2 | 0.1.3 |
| Gemini, Cursor `description` | remote MCP server, query device posture ... | XFA device security, read-only: see which devices pass their security checks, which need fixing, and which have known vulnerabilities (CVEs). |
| Cursor `keywords` | device-trust | device-security |
| ChatGPT `subtitle` | Query your device-trust data | See which devices pass checks |
| ChatGPT `description` | Query posture, compliance, policies and CVEs | Opens with what you can ask, then the product message, what it reads and its limits. |

`mcp.json` has no descriptions and is unchanged.

## How to validate

- `jq . <file>` parses for every JSON file.
- The `MCP Registry` workflow runs `mcp-publisher validate server.json` on pull requests.
- `grep -rni 'device.trust'` finds nothing outside the changelog and this spec.
- Zero-context readers given only the rendered text understood who it is for and
  that it is read-only.

## Left

- After merge to main, the `MCP Registry` workflow publishes 0.1.3 to the registry.
- Claude Connectors Directory: update the listing text by hand to match.
- ChatGPT app directory: resubmit `chatgpt-app-submission.json`.
- Cursor Marketplace: update the submission if Cursor reads the text from the
  form rather than `plugin.json`.
- The GitHub repo topic `device-trust` should change to match.
