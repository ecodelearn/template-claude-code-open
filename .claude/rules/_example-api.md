---
paths:
  - "src/api/**"
  - "src/routes/**"
  - "src/controllers/**"
  - "src/handlers/**"
---

> **TEMPLATE** — customize for your project or delete if not applicable.
> This rule loads automatically only when Claude works with files matching the paths above.
> Rename to `api.md` and remove this notice when ready.

# API conventions — [project-name]

<!-- Add your API-specific rules here. Examples: -->

<!-- ## Endpoints
- RESTful naming: plural nouns, no verbs (/users, not /getUsers)
- Versioning: /api/v1/...
- Standard response shape: { data, error, meta }

## Validation
- Validate all inputs at the boundary (zod / joi / class-validator)
- Never trust client-provided IDs for authorization — always verify ownership

## Error handling
- HTTP 400: client error (bad input)
- HTTP 401: unauthenticated
- HTTP 403: unauthorized (authenticated but no permission)
- HTTP 422: validation failed
- HTTP 500: server error — never leak stack traces to clients

## Security
- Sanitize all user inputs
- Parameterized queries only — never string concatenation in SQL
- Rate-limit sensitive endpoints (auth, password reset) -->
