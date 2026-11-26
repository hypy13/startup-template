---
name: api-contracts
description: Review or change API contracts across backend endpoints and clients, including OpenAPI schemas, generated types, pagination, validation, and compatibility.
---

# API contracts

- Identify the contract source and generation direction. Trace serializers or response models, the published schema, generated artifacts, and consumers. Check what the application returns through the route when these disagree.
- Preserve existing consumers when compatible evolution is in scope. Compare required versus omitted or nullable fields, status codes, error payloads, auth behavior, pagination, and enum values. Treat new response enum values as potentially incompatible with exhaustive client handling.
- Change the authoritative source and regenerate derived artifacts with the repo's command. If types are maintained by hand, change the backend and consumer types together and check representative response payloads. Use the repo's OpenAPI version and schema tooling.
- Verify producer behavior and at least one real consumer path. If a breaking change is requested, document the affected consumers and the order in which producers and consumers can migrate.

[OpenAPI specification](https://spec.openapis.org/oas/latest.html)
