---
name: playwright-e2e
description: Write, run, and debug Playwright Test suites for browser journeys, frontend and API integration, cross-browser regressions, and CI failures.
---

# Playwright end-to-end testing

- Read the existing Playwright config, projects, fixtures, and scripts. Use the configured base URL and test stack. If bootstrapping a suite is in scope, follow the repo's package manager and define how the runner starts the application or connects to a test instance.
- Exercise a user-visible journey through the normal app entry point. If the purpose is to verify frontend and backend integration, keep the real endpoint in that path. Stub external dependencies when they are outside the behavior under test.
- Use role and label locators and retrying assertions against visible outcomes. Use stable test IDs when the UI has no good semantic locator. Synchronize with a relevant UI state or network event when necessary.
- Seed isolated data and use a separate account per worker when tests mutate shared user state. Treat saved browser storage as credentials and use test accounts and environments.
- Run the affected spec with the configured browser project first. Diagnose failures from the first meaningful error, browser console, and trace. Compare local and CI app startup, environment, and browser versions before changing timeouts or retries.

[Playwright Test best practices](https://playwright.dev/docs/best-practices)
