# XFA MCP

Remote [Model Context Protocol](https://modelcontextprotocol.io) server for [XFA](https://xfa.tech). Connect Claude, ChatGPT, Cursor, and other AI assistants to your XFA device-security data — query device posture, checks, and org compliance from inside your AI tools.

This repository is the **connector package** for AI marketplaces. The MCP server itself is hosted by XFA at `https://mcp.xfa.tech/mcp`; nothing runs locally. Authentication is OAuth 2.0 (PKCE) — you sign in with your XFA account on connect.

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

### VS Code / Windsurf / Zed / other MCP clients

Point the client at the remote URL `https://mcp.xfa.tech/mcp` (streamable HTTP / SSE, OAuth 2.0).

## Tools

<!-- TODO: list the tools the server exposes, e.g. -->
- `list_devices` — list enrolled devices and their trust status
- `get_device_posture` — posture and failed checks for a device
- `get_org_compliance` — org-wide compliance summary

## Authentication

OAuth 2.0 with PKCE. On connect you are redirected to XFA to authorize; no API keys or tokens are stored in this package. The client discovers OAuth endpoints from the server's `/.well-known` metadata.

## Support

- Docs: https://docs.xfa.tech
- Issues: https://github.com/gl-ventures/xfa-mcp/issues
- Email: support@xfa.tech

## License

MIT — see [LICENSE](LICENSE).
