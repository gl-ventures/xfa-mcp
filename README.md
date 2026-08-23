# XFA MCP

Remote [Model Context Protocol](https://modelcontextprotocol.io) server for [XFA](https://xfa.tech). Connect Claude, ChatGPT, Cursor, and other AI assistants to your XFA device-security data — query device posture, checks, and org compliance from inside your AI tools.

This repository is the **connector package** for AI marketplaces. The MCP server itself is hosted by XFA at `https://mcp.xfa.tech/mcp`; nothing runs locally. Authentication is OAuth 2.0 (PKCE) — you sign in with your XFA account on connect.

## Where it's published

| Surface | Status | Listing |
| --- | --- | --- |
| Official MCP Registry | ✅ Live | `tech.xfa/xfa` — [registry.modelcontextprotocol.io](https://registry.modelcontextprotocol.io) |
| Glama | ⏳ Auto-crawled from the registry | |
| Smithery | ⏳ Auto-crawled from the registry | |
| PulseMCP | ⏳ Auto-crawled from the registry | |
| mcp.so | ⏳ Auto-crawled from the registry | |
| Cursor Marketplace | ⬜ Not yet submitted | [publish](https://cursor.com/marketplace/publish) |
| Claude Connectors Directory | ⬜ Not yet submitted | |
| ChatGPT app directory | ⬜ Not yet submitted | |
| Gemini CLI | ✅ Installable · ⬜ gallery pending | `gemini extensions install …` |

_Legend: ✅ live · ⏳ propagating · ⬜ to do. Update this table when a listing goes live._

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
