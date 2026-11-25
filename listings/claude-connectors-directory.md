# Claude Connectors Directory listing

Paste these into the listing form at claude.ai/directory/manage. Every edit
there waits for Anthropic's review, and Software Directory Policy 3.H asks us to
report material changes to tool or capability descriptions.

## One-liner (184/200)

XFA device security, read-only: ask which of your devices pass their security checks, which need fixing, and which have known vulnerabilities. Results include each device user's email.

## Description (2,039/2,000)

Ask about the devices in your XFA organization: which ones pass their security checks, which need fixing, and how that changes over time. XFA is user-driven device security that keeps work moving. It checks the security of every device when someone signs in to work apps, on company, personal and contractor laptops and phones, and warns people first. It takes no control of the device. People install the XFA app themselves at their first sign-in, and when a check fails they fix it themselves, with the Fix button where XFA offers one or a step by step guide. XFA also finds devices through your identity provider. This connector lets the assistant read those results. It cannot change anything.

What you can ask:
- Which devices do not meet our policy?
- What do jane@example.com's devices look like?
- Which checks does our policy require, and which only warn?
- Which devices are affected by a given CVE?

What it reads:
- Per device: the email of the person who uses it, their name and computer name where known, make and model, OS and browser with versions, and if they are up to date.
- Check results, such as disk encryption, screen lock and firewall, and versions of common work apps.
- If it meets your policy, verified (checked directly by XFA) or only discovered, tags and notes your admins gave it, and CVE ids on request.
- Your policies with their rules, your organization's settings and plan features, and your role.
- Company-wide figures, also day by day.

Limits:
- Read-only. It cannot change settings, policies, tags or devices, and it cannot start a fix. People fix their own devices in the XFA app.
- Only the organizations you approve when you connect, one at a time.
- Company-wide counts cover the last 30 days. Day by day figures: 30 days per step.
- Discovered devices show less than verified ones, and some details depend on your plan. A missing check means unknown, not failing.
- Software and vulnerability lookups describe software in general, not your devices.
