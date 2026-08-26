# XFA MCP

[XFA](https://xfa.tech) is a BYOD device-trust platform. This is **XFA's remote [Model Context Protocol](https://modelcontextprotocol.io) server** — query your organization's device posture, compliance, policies, and software/CVE status from Claude, ChatGPT, Cursor, and other AI assistants. Read-only.

This repository is the **connector package** for AI marketplaces. The MCP server itself is hosted by XFA at `https://mcp.xfa.tech/mcp`; nothing runs locally. Authentication is OAuth 2.0 (PKCE) — you sign in with your XFA account on connect.

## Where it's published

| Surface | Status | Where to submit / find |
| --- | --- | --- |
| Official MCP Registry | ✅ Live | `tech.xfa/xfa` · [registry.modelcontextprotocol.io](https://registry.modelcontextprotocol.io) |
| Glama | ⏳ Propagating from registry | [glama.ai/mcp/servers](https://glama.ai/mcp/servers) |
| Smithery | ⏳ Propagating from registry | [smithery.ai](https://smithery.ai) |
| PulseMCP | ⏳ Propagating from registry | [pulsemcp.com](https://www.pulsemcp.com) |
| mcp.so | ⏳ Propagating from registry | [mcp.so](https://mcp.so) |
| Cursor Marketplace | 🕒 Submitted — pending approval | [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish) |
| Claude Connectors Directory | ✅ Live | [claude.ai/directory/mcp-xfa-tech](https://claude.ai/directory/mcp-xfa-tech) |
| ChatGPT app directory | 🕒 Submitted — pending review | [Apps SDK submission](https://developers.openai.com/apps-sdk/app-submission-guidelines) |
| Gemini / Antigravity CLI | ✅ Installable · ⏳ gallery auto-crawl | `gemini-cli-extension` topic set; also via the MCP Registry |
| awesome-mcp-servers | 🕒 PR open — [#12739](https://github.com/punkpeye/awesome-mcp-servers/pull/12739) | Security section |

_Legend: ✅ live · ⏳ propagating (no action) · 🕒 pending. Update a row when its listing goes live._

> **Gemini note:** the Gemini CLI gallery has no submission form — it crawls public repos
> tagged with the `gemini-cli-extension` GitHub topic daily (already set). Gemini CLI merged
> into **Antigravity CLI** (June 2026); Antigravity discovers MCP servers via the MCP Registry,
> where this server is already live, so no separate Antigravity submission is needed.

## Install

### Cursor

One-click:

```
cursor://anysphere.cursor-deeplink/mcp/install?name=xfa&config=eyJ1cmwiOiJodHRwczovL21jcC54ZmEudGVjaC9tY3AifQ==
```

Or add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "xfa": { "url": "https://mcp.xfa.tech/mcp" }
  }
}
```

### Claude

Settings → Connectors → Add custom connector → URL `https://mcp.xfa.tech/mcp`.

### ChatGPT

Settings → Connectors → Add → MCP server URL `https://mcp.xfa.tech/mcp`.

### Gemini CLI

Install the extension:

```
gemini extensions install https://github.com/gl-ventures/xfa-mcp
```

The bundled `gemini-extension.json` points at the remote server; Gemini discovers OAuth from the server metadata and prompts you to sign in on first use.

### VS Code / Windsurf / Zed / other MCP clients

Point the client at the remote URL `https://mcp.xfa.tech/mcp` (streamable HTTP / SSE, OAuth 2.0).

## Tools

All tools are read-only. The live server is the source of truth — clients fetch the current tool list from the endpoint on every connection, so this list may lag the deployed server. See the [Connect an AI assistant](https://docs.xfa.tech/admin/connect-ai-assistant) docs for the maintained reference.

**Your organization** (scoped to the signed-in user's org)

| Tool | Description |
| --- | --- |
| `get_organization` | Get your XFA organization |
| `get_current_user` | Get the signed-in user |
| `list_devices` | List devices (active in the last 30 days) |
| `get_device` | Get a single device |
| `get_compliance_summary` | Org-wide compliance summary |
| `get_posture_trends` | Posture trends over time |
| `list_policies` | List policies |

**Software & vulnerabilities** (XFA's tracked-software catalog)

| Tool | Description |
| --- | --- |
| `get_latest_version` | Latest known version of a piece of software |
| `list_versioned_software_catalog` | List the software XFA tracks |
| `get_software_version_info` | Status of a specific software version |
| `get_cves_for_version` | CVEs affecting a software version |

## Authentication

OAuth 2.0 with PKCE (S256), scope `mcp:read`. On connect you are redirected to XFA to authorize; no API keys or tokens are stored in this package. The client auto-discovers the OAuth endpoints from the server's already-published metadata:

- `https://mcp.xfa.tech/.well-known/oauth-protected-resource`
- `https://mcp.xfa.tech/.well-known/oauth-authorization-server`

## Support

- Docs: https://docs.xfa.tech/admin/connect-ai-assistant
- Issues: https://github.com/gl-ventures/xfa-mcp/issues
- Email: support@xfa.tech

## Maintainers

The [`MCP Registry` workflow](.github/workflows/publish-registry.yml) validates `server.json`
on every change and publishes to the [official MCP Registry](https://registry.modelcontextprotocol.io)
on pushes to `main` (or via **Run workflow**). It authenticates by DNS against the
`v=MCPv1` TXT record on the `xfa.tech` apex.

To release a new version: bump `version` in `server.json`, merge to `main`.

Required repo secret: **`MCP_REGISTRY_KEY_PEM`** — the Ed25519 private key PEM
(pairs with the DNS TXT record). Keep the matching key backed up in a password manager.

## License

MIT — see [LICENSE](LICENSE).
