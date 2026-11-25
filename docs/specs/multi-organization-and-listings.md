# README and listings: one connection covers the organizations you approve

## Problem

One AI assistant connection reads every organization the person ticks on the
connect screen, at most 12. The README still said "scoped to the one
organization you approve".

## Decision

Change the README line. The listing texts (`chatgpt-app-submission.json`,
`listings/claude-connectors-directory.md`) also said "one organization". They
are what was submitted to OpenAI and Anthropic, so changing them means a
resubmission. That is done in the same change (part 2 below), which also fixes the other false sentences in the listings.

The limit of 12 organizations per connection is the same on the connect screen
and on the server. Merge after the connect screen allows several organizations.
The public docs page "Connect an AI assistant" describes the same behavior.

## Validate

Read the README on the branch. No code changes.

## Left

The ChatGPT and Claude directory entries need a resubmission after this merges (see part 2).

## Part 2: listings say what the customer tools really do

### Problem

`chatgpt-app-submission.json` was written before several tools and answers
changed, and was never brought up to date. Two sentences were false:

- "device results carry no names or emails of the people who use them":
  `list_devices` groups devices by the email of the person who uses them, and
  `list_user_devices` looks devices up by email. The listing's own example asks
  about jane@example.com.
- "It cannot see your XFA plan, your policy rules or your settings":
  `list_policies` returns the rules (which checks are on, thresholds, warn or
  block) and `get_organization` returns the settings and the plan's feature flags.

### Decision

Customer-facing text only: the listing names only the tools a customer's
connection offers.

### Source of truth

The live server's tool list and its server instructions. The tools a
customer's connection offers are exactly 13: get_organization,
get_current_user, list_devices, list_user_devices, get_device, list_device_tags,
get_compliance_summary, get_posture_trends, list_policies, and the global
get_latest_version, list_versioned_software_catalog, get_software_version_info,
get_cves_for_version. All are read-only, closed world, not destructive.

### Before / after

| Sentence | Before | After | Why |
| --- | --- | --- | --- |
| Intro end | It cannot change anything, and device results carry no names or emails of the people who use them. | It cannot change anything. | False: the email is the key of every device list. |
| Examples | (none about policy rules) | Added "Which checks does our policy require, and which only warn?" | `list_policies` returns rules. |
| Intended users | A person can only connect with their own XFA account, to an organization they have access to. | A person connects with their own XFA account, and sees what their role in each organization allows in the dashboard. | Connections can hold several organizations; answers follow the role (`get_current_user`: Administrator or ReadOnly). |
| What it reads, per device | the operating system and version; if the OS and the last-used browser are up to date (the browser's name, not its version); security check results ...; policy; verified or discovered; CVEs on request | One bullet list. Per device: email, name, computer name where known, make and model, OS and version, browser and version, up to date. Checks (disk encryption, screen lock, firewall, antivirus, password manager, remote access settings) and versions of common work apps. Policy, verified or discovered, tags and notes. CVEs on request. Plus policies, organization settings and plan, company-wide figures, general software lookups. | Device results carry the email, user name, computer name, make, model, browser version, app versions, tags and note. The browser version is sent, so "name, not version" was false. `get_organization` returns settings and the plan's features. |
| Limit: organization | Only the one organization you approve when you connect. | Only the organizations you approve when you connect. It reads one organization at a time. | Multi-grant connections; every organization tool takes `organization_id`. |
| Limit: plan and policy | It cannot see your XFA plan, your policy rules or your settings, for example which sign-ins are checked or which checks warn or block. Your XFA dashboard shows those. | Removed. The reads are now listed under "What it reads". | False since `list_policies` returns rules; `get_organization` returns plan features and settings. |
| Limit: windows | Device lists and counts cover devices seen in the last 30 days; trends go back further. | Counts of devices and people in the company-wide figures cover the last 30 days. Device lists follow the dashboard's 30 days unless you ask for another period. Day by day figures come 30 days at a time. | `get_posture_trends` allows at most 30 days per call; the 30 days in `list_devices` is the dashboard's default the tool text points to (`from_date` is optional). |
| Limit: software lookups | Software version and vulnerability lookups describe software in general, not your devices. | Moved up to "What it reads" as "General lookups ... These do not describe your devices." | Same fact, clearer place. |
| Limit: unknown | (none) | A missing check means unknown, not failing. | Same sentence as the server instructions. |
| Tools | 11 tools | 13 tools: added `list_user_devices` and `list_device_tags`, with annotations and justifications; `list_policies` justification now says "and their rules". | Both exist on origin/main. |
| Test cases | 5 | 8: added `list_user_devices`, `list_device_tags`, rules in `list_policies`. | Cover the added tools. |

### Not in the listing on purpose

- Anything a customer's connection does not offer.
- Credentials. The listing says nothing about them either way.

### Same fixes in the other listings

One topic, one PR: every listing says one thing, and it matches the README wording of part 1 (organizations you approve, up to 12 per connection).

| Where | Before | After |
| --- | --- | --- |
| Claude directory one-liner | Device results carry no names or emails. | Results include each device user's email. |
| Claude directory description | "...and device results carry no names or emails of the people who use them." | Removed. |
| Claude directory "What it reads" | One line: OS, up to date "(not the browser's version)", checks, policy, verified, CVEs | Bullet list as in the ChatGPT text (email, names, make and model, versions, checks, work apps, tags and notes, policies and rules, settings and plan, company-wide figures). |
| Claude directory limits | One organization; cannot see plan, policy rules or settings; lists and counts 30 days, trends further back | The organizations you approve, one at a time; company-wide counts 30 days, day by day in 30-day steps; unknown is not failing. The plan and rules line and the longer trend period are gone. |
| Claude directory examples | 3 | 4, adding jane@example.com's devices and "which only warn". Description stays under 2,000 characters (header says 1,995). The intro lost "for fast-growing tech companies, often without an IT team", "for example before an audit...", and "company-issued" became "company". |
| .cursor-plugin/plugin.json | Device results carry no names or emails. | Device results include the email of the person who uses each device. |
| gemini-extension.json | Device results carry no names or emails. | Device results include the email of the person who uses each device, and your policies and settings. |
| README intro | scoped to the one organization you approve; no names or emails | scoped to the organizations you approve when you sign in, up to 12 per connection (part 1); results include the user's email, and the policies, settings and plan |
| README tools | list_devices "active in the last 30 days"; no list_user_devices or list_device_tags; list_policies "List policies"; "scoped to the signed-in user's org" | Added the two tools; list_policies says rules and warn or block; list_devices "grouped by the person who uses them (the dashboard shows the last 30 days)"; "limited to the organizations the signed-in user approved". |

### Reader check (zero context)

Prompt: "you're an IT admin considering connecting this to ChatGPT: what can it
see and do? anything unclear?"

One fresh reader, given only the listing text. Every answer matched the code:
it listed the email, names, device details, checks, app versions, tags, notes, policies,
organization settings and plan, company-wide figures; read-only; only approved
organizations, one at a time. No wrong answer about what is shared.

Remarks, none a misreading of what is shared or the risk (stop rule: ignored as
style or out of our control): "policy / compliant / pass checks" are three words
(kept, the dashboard uses them); jargon such as CVE and identity provider (kept,
the audience is IT admins); where ChatGPT stores the data (OpenAI's, not ours);
which plan hides which details (changes with plans; the listing says "depend on
your plan"); who may connect (not verified here, so not claimed).

### Left

- The ChatGPT directory entry needs a resubmission after this merges.

### How to validate

`python3 -m json.tool chatgpt-app-submission.json`; compare the `tools` keys with
the 13 tools the live server lists for a customer's connection.

### Claude directory reader (zero context)

Facts matched the code (emails and device details seen, read-only, approved
organizations only). One real finding: the example "affected by a given CVE"
seemed to contradict "lookups describe software in general". Fixed in both the
Claude and ChatGPT text: a software version lookup says nothing about your
devices, and device CVEs come with the device results (`add_cves`). Also reworded
the day by day limit. Not acted on: verified vs discovered (defined inline),
plan-dependent details, CVE and identity provider jargon, data retention at the
assistant (not ours).

## Handover / current state

This section lets anyone pick the work up from the branch alone.

- **State (2026-11-25):** pull request open, not a draft. The public-text check
  (`scripts/check-public.sh`) passes. No review yet, so not approved.
- **Decisions:**
  - 2026-11-25: the listing-truth work that first lived in a separate pull
    request (now closed) is folded into this one, so there is one change and
    one topic: the README and every listing say the same thing (part 2).
  - The limit of 12 organizations per connection is the same on the connect
    screen and on the server (see Decision above).
  - Customer-facing text only: no code changes, tool names, ids and URLs stay.
- **Merge order:** merge after the dashboard connect screen allows several
  organizations in one connection, because the README and listings describe
  that behaviour.
- **Left:** after merge, resubmit the ChatGPT and Claude directory entries
  (the texts in `chatgpt-app-submission.json` and
  `listings/claude-connectors-directory.md` are what those reviewers read).
- **Next step:** owner review of the diff, then code review. Re-check the 13
  tool names against the live server's tool list right before merge.
- **Open questions:** none.
