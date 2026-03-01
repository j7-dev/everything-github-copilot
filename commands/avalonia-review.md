---
description: Review Avalonia UI / C# code for MVVM architecture compliance, Avalonia vs WPF anti-patterns, CompiledBinding usage, and C# quality.
---

Perform a comprehensive Avalonia UI / C# code review by invoking the `avalonia-reviewer` agent.

Focus on:
1. **Security**: Hardcoded secrets, unvalidated input, file path traversal
2. **Avalonia Specifics**: Styles vs Resources, CompiledBinding, StyledProperty, TreeDataTemplate
3. **MVVM**: No code-behind logic, proper ViewModel structure, ICommand usage
4. **C# Quality**: async/await patterns, nullable handling, type safety
5. **Performance**: Virtualization for lists, binding mode optimization

Run these diagnostics if available:
```bash
# Build
dotnet build

# Tests
dotnet test

# Format
dotnet format --verify-no-changes
```

Produce a structured review report:
- List each issue with `[CRITICAL]`, `[HIGH]`, `[MEDIUM]`, or `[LOW]` severity
- Include file path and line number (and XAML line for .axaml files)
- Provide concrete fix suggestions, noting WPF → Avalonia corrections

End with a verdict: **APPROVE** / **WARN** / **BLOCK**

$ARGUMENTS
