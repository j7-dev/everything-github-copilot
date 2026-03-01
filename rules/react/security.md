---
paths:
  - "**/*.tsx"
  - "**/*.ts"
  - "**/*.jsx"
  - "**/*.js"
---
# React Security

> This file extends [common/security.md](../common/security.md) with React specific content.

## XSS Prevention

```tsx
// WRONG: XSS vulnerability
<div dangerouslySetInnerHTML={{ __html: userContent }} />

// CORRECT: Sanitize before rendering HTML
import DOMPurify from 'dompurify'
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userContent) }} />

// BETTER: Avoid dangerouslySetInnerHTML entirely
<p>{userContent}</p>
```

## Secret Management

```tsx
// NEVER: Hardcoded secrets
const apiKey = "sk-proj-xxxxx"

// ALWAYS: Environment variables (Vite)
const apiKey = import.meta.env.VITE_API_KEY

if (!apiKey) {
  throw new Error('VITE_API_KEY not configured')
}
```

## Input Validation

Use Zod for schema-based validation:

```tsx
import { z } from 'zod'

const UserSchema = z.object({
  email: z.string().email('Invalid email format'),
  age: z.number().int().min(0).max(150),
  name: z.string().min(1).max(100),
})

const validated = UserSchema.parse(formInput)
```

## Authentication Headers

```tsx
// Correct: Authorization header
const response = await fetch('/api/data', {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
  },
})
```

## Agent Support

- Use **react-reviewer** agent for comprehensive security audits
