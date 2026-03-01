---
paths:
  - "**/*.cs"
  - "**/test/**"
  - "**/tests/**"
  - "**/*.Tests.csproj"
---
# ABP Framework Testing

> This file extends [common/testing.md](../common/testing.md) with ABP Framework specific content.

## Framework

Use **xUnit** with ABP''s test framework:
- `Volo.Abp.TestBase` for unit tests
- `Volo.Abp.EntityFrameworkCore.TestBase` for integration tests

## Domain Layer Test

```csharp
public class OrderTests : AbpIntegratedTest<BookStoreTestModule>
{
    [Fact]
    public void Should_Not_Confirm_Non_Pending_Order()
    {
        var order = new Order(Guid.NewGuid(), "Customer");
        order.Confirm(); // First confirm is OK

        Assert.Throws<BusinessException>(() => order.Confirm()); // Second confirm throws
    }
}
```

## Application Service Test

```csharp
public class OrderAppServiceTests : BookStoreApplicationTestBase
{
    private readonly IOrderAppService _orderAppService;

    public OrderAppServiceTests()
    {
        _orderAppService = GetRequiredService<IOrderAppService>();
    }

    [Fact]
    public async Task Should_Create_Order()
    {
        var dto = await _orderAppService.CreateAsync(new CreateOrderDto
        {
            CustomerName = "Test Customer",
            Amount = 100.00m
        });

        dto.Id.ShouldNotBe(Guid.Empty);
        dto.CustomerName.ShouldBe("Test Customer");
    }
}
```

## Coverage

```bash
# Run tests
dotnet test

# With coverage
dotnet test --collect:"XPlat Code Coverage"
```

## Agent Support

- Use **abp-reviewer** agent for test quality review
