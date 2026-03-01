---
paths:
  - "**/*.cs"
  - "**/Application/**"
  - "**/Web/**"
---
# ABP Framework Security

> This file extends [common/security.md](../common/security.md) with ABP Framework specific content.

## Authorization

Always use permission-based authorization in Application Services:

```csharp
[Authorize(OrderPermissions.Orders.Default)]
public async Task<OrderDto> GetAsync(Guid id)
{
    return ObjectMapper.Map<Order, OrderDto>(
        await _orderRepository.GetAsync(id)
    );
}

[Authorize(OrderPermissions.Orders.Create)]
public async Task<OrderDto> CreateAsync(CreateOrderDto input)
{
    // ...
}
```

## Input Validation

Use ABP's ``Check`` and Data Annotations:

```csharp
public class CreateOrderDto
{
    [Required]
    [MaxLength(OrderConsts.MaxCustomerNameLength)]
    public string CustomerName { get; set; } = string.Empty;

    [Range(0.01, double.MaxValue)]
    public decimal Amount { get; set; }
}
```

## Secret Management

```csharp
// NEVER: Hardcoded secrets
private const string ApiKey = "sk-proj-xxxxx";

// ALWAYS: ABP Options pattern with environment-backed configuration
public class MyServiceOptions
{
    public string ApiKey { get; set; } = string.Empty;
}

// appsettings.json (development only)
// Use environment variables or Azure Key Vault for production
```

## Multi-Tenancy Security

Never bypass ABP's automatic data filters:

```csharp
// ABP automatically adds TenantId filter — never add manually
var orders = await _orderRepository.GetListAsync(); // Filtered automatically

// Intentional cross-tenant access (requires special permission)
using (CurrentTenant.Change(tenantId))
{
    var tenantOrders = await _orderRepository.GetListAsync();
}
```

## REST API Security

```csharp
// WRONG: Open endpoint
[HttpGet]
[AllowAnonymous]
public async Task<List<OrderDto>> GetAllAsync() // Exposes all data!

// CORRECT: Protected endpoint
[HttpGet]
[Authorize(OrderPermissions.Orders.Default)]
public async Task<PagedResultDto<OrderDto>> GetListAsync(GetOrderListDto input)
```

## Agent Support

- Use **abp-reviewer** agent for comprehensive security audits
