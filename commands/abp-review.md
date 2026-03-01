---
description: Review ABP Framework / C# code for DDD architecture compliance, proper layering, authorization, multi-tenancy patterns, and ABP best practices.
---

Perform a comprehensive ABP Framework / C# code review by invoking the `abp-reviewer` agent.

Focus on:
1. **Security**: Missing authorization attributes, exposed entities, unvalidated input, multi-tenancy bypass
2. **DDD Architecture**: Proper layer boundaries, AggregateRoot usage, domain invariants
3. **ABP Patterns**: Application Services, DTOs, ObjectMapper, Repository usage
4. **C# Quality**: async/await patterns, nullable handling, unit of work
5. **Multi-Tenancy**: Correct data isolation, ``CurrentTenant.Change()`` usage

Run these diagnostics if available:
```bash
# Build solution
dotnet build

# Run tests
dotnet test

# Check EF migrations
dotnet ef migrations list
```

Produce a structured review report:
- List each issue with `[CRITICAL]`, `[HIGH]`, `[MEDIUM]`, or `[LOW]` severity
- Include file path, line number, and **DDD layer** (Domain/Application/Infrastructure/API)
- Provide concrete fix suggestions with corrected code examples

End with a verdict: **APPROVE** / **WARN** / **BLOCK**

$ARGUMENTS
