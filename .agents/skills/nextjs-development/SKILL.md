---
name: nextjs-development
description: Implement or debug Next.js and React application code, including App Router routes, server and client boundaries, data fetching, forms, and rendering failures.
---

# Next.js development

- Locate the app package, installed Next.js version, package manager, and router in use. Preserve the existing router, data layer, UI components, and form patterns. Check the installed version's docs before relying on caching defaults or dynamic route APIs.
- In the App Router, keep route layouts and data access on the server where possible. Put the client boundary around the UI that needs browser APIs or React state. Pass serializable props across it and keep credentials and privileged data access in server-only code.
- Trace each request from the visible route through the fetcher, rewrite or route handler, and upstream service. Browser requests and server rendering can have different base URLs and cookie behavior. For authenticated data, verify that the chosen cache scope cannot serve one user's data to another.
- Validate and authorize mutations at the server boundary. Reflect pending, validation, and failure states using the repo's form and error patterns. Preserve keyboard navigation, accessible names, and focus behavior when changing interactive UI.
- Use the package's type, lint, and relevant test commands. Check the changed route through its normal entry point. Run a production build when the change affects rendering mode, bundling, or server and client boundaries.

[Next.js App Router documentation](https://nextjs.org/docs/app)
