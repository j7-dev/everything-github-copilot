---
description: Review WordPress/PHP code for security vulnerabilities, coding standards compliance, performance issues, and WordPress best practices.
---

Perform a comprehensive WordPress/PHP code review by invoking the `wordpress-reviewer` agent.

Focus on:
1. **Security**: SQL injection, XSS, CSRF, capability checks, input sanitization
2. **WordPress Standards**: Hook patterns, naming conventions, `declare(strict_types=1)`, PHPDoc
3. **Performance**: Transient caching, query optimization, avoiding unbounded queries
4. **Architecture**: Singleton pattern, REST API structure, proper escaping

Run these diagnostics if available:
```bash
# Static analysis
composer lint && composer analyse

# Tests
composer test
```

Produce a structured review report:
- List each issue with `[CRITICAL]`, `[HIGH]`, `[MEDIUM]`, or `[LOW]` severity
- Include file path and line number
- Provide concrete fix suggestions

End with a verdict: **APPROVE** / **WARN** / **BLOCK**

$ARGUMENTS
