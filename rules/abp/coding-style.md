---
paths:
  - "**/*.cs"
  - "**/Domain/**"
  - "**/Application/**"
  - "**/EntityFrameworkCore/**"
---
# ABP Framework / C# Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with ABP Framework 9.x / DDD specific content.

## Layer Responsibility (DDD)

Never violate layer boundaries:

| Layer | Allowed | Forbidden |
|-------|---------|-----------|
| Domain | Entities, Domain Services, Repository interfaces | EF Core, HTTP, Application Services |
| Application | Application Services, DTOs, ObjectMapper | EF Core DbContext, direct DB |
| Infrastructure | EF Core, Repository implementations | Business logic, domain rules |
| API/Web | Controllers, Pages | Business logic, direct DB |

## Domain Entity Pattern

```csharp
public class Order : AggregateRoot<Guid>
{
    public string CustomerName { get; private set; }
    public OrderStatus Status { get; private set; }

    // Required private constructor for ORM
    private Order() { }

    public Order(Guid id, [NotNull] string customerName) : base(id)
    {
        CustomerName = Check.NotNullOrWhiteSpace(customerName, nameof(customerName));
        Status = OrderStatus.Pending;
    }

    // Domain behavior as methods
    public void Confirm()
    {
        if (Status != OrderStatus.Pending)
            throw new BusinessException("Order:CannotConfirmNonPendingOrder");

        Status = OrderStatus.Confirmed;
        AddLocalEvent(new OrderConfirmedEvent(Id));
    }
}
```

## Application Service Pattern

```csharp
public class OrderAppService : ApplicationService, IOrderAppService
{
    private readonly IRepository<Order, Guid> _orderRepository;

    public OrderAppService(IRepository<Order, Guid> orderRepository)
    {
        _orderRepository = orderRepository;
    }

    public async Task<OrderDto> GetAsync(Guid id)
    {
        var order = await _orderRepository.GetAsync(id);
        return ObjectMapper.Map<Order, OrderDto>(order);
    }
}
```

## DTO Pattern

DTOs are plain data containers — no business logic:

```csharp
public class OrderDto : EntityDto<Guid>
{
    public string CustomerName { get; set; } = string.Empty;
    public OrderStatus Status { get; set; }
    public DateTime CreatedAt { get; set; }
}
```

## Immutability

Use ``private set`` in entities, return new DTOs from mapping:

```csharp
// WRONG: Exposing mutable state
public string Name { get; set; }

// CORRECT: Controlled mutation via domain methods
public string Name { get; private set; }

public void UpdateName([NotNull] string name)
{
    Name = Check.NotNullOrWhiteSpace(name, nameof(name));
}
```

## Reference

See agent: `abp-reviewer` for comprehensive ABP code review.
See skill: `abp-framework` for detailed patterns and DDD guidance.
