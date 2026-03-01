---
paths:
  - "**/*.cs"
  - "**/*.axaml"
---
# Avalonia Security

> This file extends [common/security.md](../common/security.md) with Avalonia/C# specific content.

## Secret Management

```csharp
// NEVER: Hardcoded secrets
private const string ApiKey = "sk-proj-xxxxx";

// ALWAYS: Environment variables or secure storage
var apiKey = Environment.GetEnvironmentVariable("API_KEY")
    ?? throw new InvalidOperationException("API_KEY not configured");
```

## Secure Credential Storage

For desktop apps, use the OS credential store — never plain files:

```csharp
// Use Microsoft.Extensions.SecretManager or
// Windows: DPAPI / Windows Credential Store
// macOS: Keychain
// Linux: libsecret / Secret Service API
```

## Input Validation

```csharp
using CommunityToolkit.Diagnostics;

public void ProcessInput(string input)
{
    Guard.IsNotNullOrEmpty(input, nameof(input));
    Guard.IsLessThanOrEqualTo(input.Length, 1000, nameof(input));

    // Process validated input
}
```

## File Path Validation

```csharp
// Validate file paths to prevent traversal
var basePath = Path.GetFullPath(baseDirectory);
var fullPath = Path.GetFullPath(Path.Combine(basePath, userInput));

if (!fullPath.StartsWith(basePath, StringComparison.OrdinalIgnoreCase))
{
    throw new UnauthorizedAccessException("Path traversal detected");
}
```

## Agent Support

- Use **avalonia-reviewer** agent for comprehensive security audits
