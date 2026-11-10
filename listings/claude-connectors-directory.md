# Claude Connectors Directory listing

Paste these into the listing form at claude.ai/directory/manage. Every edit
there waits for Anthropic's review, and Software Directory Policy 3.H asks us to
report material changes to tool or capability descriptions.

## One-liner (194/200)

XFA device security, read-only: ask which of your organization's devices pass their security checks, which need fixing, and which have known vulnerabilities. Never shows owners' names or emails.

## Description (1696/2,000)

Ask about the devices in your XFA organization: which ones pass their security checks, which need fixing, and how that changes over time. XFA is user-driven device security. It checks the security of every device when someone signs in to work apps, on company-owned, personal and contractor laptops and phones, and warns people first. People install the XFA app themselves at their first sign-in, and when a check fails they fix it themselves, with the Fix button where XFA offers one or a step by step guide. XFA also finds devices through your sign-in system (your identity provider). This connector lets the assistant read those results. It cannot change anything, and it never shows the names or emails of the people who own the devices.

What you can ask:
- Which devices do not meet our policy, and what fails on each?
- Which devices have an out of date operating system, or disk encryption off?
- What do jane@example.com's devices look like?
- How many people still have no verified device?
- Which devices are affected by a given CVE?
- How has disk encryption changed over the last 90 days?

Limits:
- Read-only. It cannot change settings, policies or devices, and it cannot start a fix. People fix their own devices in the XFA app.
- Only the one organization you approve when you connect.
- It cannot see your XFA plan, your policy rules or your settings, for example which sign-ins are checked or which checks warn or block. Your XFA dashboard shows those.
- It covers devices seen in the last 30 days. Discovered devices show less than verified ones, and some details depend on your plan.
- Software version and vulnerability lookups describe software in general, not your devices.
