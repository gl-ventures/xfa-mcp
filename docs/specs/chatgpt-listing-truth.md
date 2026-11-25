# ChatGPT app listing: say what the customer tools really do

## Problem

`chatgpt-app-submission.json` was written before several tools and answers
changed, and was never brought up to date. Two sentences were false:

- "device results carry no names or emails of the people who use them":
  `list_devices` groups devices by the email of the person who uses them, and
  `list_user_devices` looks devices up by email. The listing's own example asks
  about jane@example.com.
- "It cannot see your XFA plan, your policy rules or your settings":
  `list_policies` returns the rules (which checks are on, thresholds, warn or
  block) and `get_organization` returns the settings and the plan's feature flags.

## Decision (Lars, 2026-11-25)

"let's improve the listing - it's weird that it was forgotten? ... don't mention
staff things here, look very good at this."

So the listing names only the customer tools and never the staff
(`system_admin_`) tools or internal analytics.

## Source of truth

gl-ventures/xfa-api `origin/main`, `lambdas/api-mcp`: `tool_customer.go`
(`customerRoutes`, descriptions are the OpenAPI's), `tool_versions.go`,
`main.go` (`instructionsText`). Per device fields: xfa-statistics-service
`models/models.go` `Shadow`. Customer tools are exactly 13: get_organization,
get_current_user, list_devices, list_user_devices, get_device, list_device_tags,
get_compliance_summary, get_posture_trends, list_policies, and the global
get_latest_version, list_versioned_software_catalog, get_software_version_info,
get_cves_for_version. All are read-only, closed world, not destructive
(`TestEveryToolSetsAllThreeHints`).

## Before / after

| Sentence | Before | After | Why |
| --- | --- | --- | --- |
| Intro end | It cannot change anything, and device results carry no names or emails of the people who use them. | It cannot change anything. | False: the email is the key of every device list. |
| Examples | (none about policy rules) | Added "Which checks does our policy require, and which only warn?" | `list_policies` returns rules. |
| Intended users | A person can only connect with their own XFA account, to an organization they have access to. | A person connects with their own XFA account, and sees what their role in each organization allows in the dashboard. | Connections can hold several organizations (XFA-4043); answers follow the role (`get_current_user`: Administrator or ReadOnly). |
| What it reads, per device | the operating system and version; if the OS and the last-used browser are up to date (the browser's name, not its version); security check results ...; policy; verified or discovered; CVEs on request | One bullet list. Per device: email, name, computer name where known, make and model, OS and version, browser and version, up to date. Checks (disk encryption, screen lock, firewall, antivirus, password manager, remote access settings) and versions of common work apps. Policy, verified or discovered, tags and notes. CVEs on request. Plus policies, organization settings and plan, company-wide figures, general software lookups. | `Shadow` carries `email`, `user`, `computer_name`, `manufacturer`, `model`, `browser_version`, the app versions, `tags`, `note`. The browser version is sent, so "name, not version" was false. `get_organization` returns settings and `feature_flags`. |
| Limit: organization | Only the one organization you approve when you connect. | Only the organizations you approve when you connect. It reads one organization at a time. | Multi-grant connections; every organization tool takes `organization_id`. |
| Limit: plan and policy | It cannot see your XFA plan, your policy rules or your settings, for example which sign-ins are checked or which checks warn or block. Your XFA dashboard shows those. | Removed. The reads are now listed under "What it reads". | False since `list_policies` returns rules; `get_organization` returns plan features and settings. |
| Limit: windows | Device lists and counts cover devices seen in the last 30 days; trends go back up to 180 days. | Counts of devices and people in the company-wide figures cover the last 30 days. Device lists follow the dashboard's 30 days unless you ask for another period. Day by day figures come 30 days at a time. | The 180 days is only a staff tool's option. `get_posture_trends` allows at most 30 days per call (`maxTrendWindow`); the 30 days in `list_devices` is the dashboard's default the tool text points to (`from_date` is optional). |
| Limit: software lookups | Software version and vulnerability lookups describe software in general, not your devices. | Moved up to "What it reads" as "General lookups ... These do not describe your devices." | Same fact, clearer place. |
| Limit: unknown | (none) | A missing check means unknown, not failing. | Same sentence as the server instructions. |
| Tools | 11 tools | 13 tools: added `list_user_devices` and `list_device_tags`, with annotations and justifications; `list_policies` justification now says "and their rules". | Both exist on origin/main. |
| Test cases | 5 | 8: added `list_user_devices`, `list_device_tags`, rules in `list_policies`. | Cover the added tools. |

## Not in the listing on purpose

- Staff tools and internal analytics.
- The Aikido `endpoint_token` in `list_policies`: xfa-api PR #988 removes it from
  answers. The listing says nothing about credentials either way, so it stays
  true before and after #988.

## Same fixes in the other listings (coordinator, 2026-11-25)

One topic, one PR: every listing says one thing.

| Where | Before | After |
| --- | --- | --- |
| Claude directory one-liner | Device results carry no names or emails. | Results include each device user's email. |
| Claude directory description | "...and device results carry no names or emails of the people who use them." | Removed. |
| Claude directory "What it reads" | One line: OS, up to date "(not the browser's version)", checks, policy, verified, CVEs | Bullet list as in the ChatGPT text (email, names, make and model, versions, checks, work apps, tags and notes, policies and rules, settings and plan, company-wide figures). |
| Claude directory limits | One organization; cannot see plan, policy rules or settings; lists and counts 30 days, trends 180 days | The organizations you approve, one at a time; company-wide counts 30 days, day by day in 30-day steps; unknown is not failing. The plan and rules line and the 180 days are gone. |
| Claude directory examples | 3 | 4, adding jane@example.com's devices and "which only warn". Description stays under 2,000 characters (header says 1,995). The intro lost "for fast-growing tech companies, often without an IT team", "for example before an audit...", and "company-issued" became "company". |
| gemini-extension.json | Device results carry no names or emails. | Device results include the email of the person who uses each device, and your policies and settings. |
| README intro | scoped to the one organization you approve; no names or emails | limited to the organizations you approve; results include the user's email, and the policies, settings and plan |
| README tools | list_devices "active in the last 30 days"; no list_user_devices or list_device_tags; list_policies "List policies"; "scoped to the signed-in user's org" | Added the two tools; list_policies says rules and warn or block; list_devices "grouped by the person who uses them (the dashboard shows the last 30 days)"; "limited to the organizations the signed-in user approved". |

## Reader check (haiku, zero context)

See the table below. Prompt: "you're an IT admin considering connecting this to
ChatGPT: what can it see and do? anything unclear?"

One fresh haiku reader, given only the listing text. Every answer matched the code:
it listed the email, names, device details, checks, app versions, tags, notes, policies,
organization settings and plan, company-wide figures; read-only; only approved
organizations, one at a time. No wrong answer about what is shared.

Remarks, none a misreading of what is shared or the risk (stop rule: ignored as
style or out of our control): "policy / compliant / pass checks" are three words
(kept, the dashboard uses them); jargon such as CVE and identity provider (kept,
the audience is IT admins); where ChatGPT stores the data (OpenAI's, not ours);
which plan hides which details (changes with plans; the listing says "depend on
your plan"); who may connect (not verified here, so not claimed).

## Left

- The ChatGPT directory entry needs a resubmission after this merges.

## How to validate

`python3 -m json.tool chatgpt-app-submission.json`; compare the `tools` keys with
`customerRoutes` and the four version tools on xfa-api `origin/main`.

## Claude directory reader (haiku, zero context)

Facts matched the code (emails and device details seen, read-only, approved
organizations only). One real finding: the example "affected by a given CVE"
seemed to contradict "lookups describe software in general". Fixed in both the
Claude and ChatGPT text: a software version lookup says nothing about your
devices, and device CVEs come with the device results (`add_cves`). Also reworded
the day by day limit. Not acted on: verified vs discovered (defined inline),
plan-dependent details, CVE and identity provider jargon, data retention at the
assistant (not ours).
