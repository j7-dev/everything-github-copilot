---
description: Review React 18 / TypeScript code for security issues, hooks correctness, performance problems, accessibility violations, and modern React best practices.
---

Perform a comprehensive React 18 / TypeScript code review by invoking the `react-reviewer` agent.

Focus on:
1. **Security**: XSS via dangerouslySetInnerHTML, exposed secrets, unvalidated input
2. **React 18 Patterns**: Correct hook usage, concurrent features, error boundaries
3. **TypeScript**: No `any` types, proper type safety, typed props
4. **Performance**: Unnecessary re-renders, missing memoization, bundle size
5. **Accessibility**: ARIA labels, semantic HTML, keyboard navigation, color contrast

Run these diagnostics if available:
```bash
# Type checking
npx tsc --noEmit

# Linting
npx eslint src/ --ext .ts,.tsx

# Tests
npm test -- --coverage
```

Produce a structured review report:
- List each issue with `[CRITICAL]`, `[HIGH]`, `[MEDIUM]`, or `[LOW]` severity
- Include file path and line number
- Provide concrete fix suggestions

End with a verdict: **APPROVE** / **WARN** / **BLOCK**

$ARGUMENTS
