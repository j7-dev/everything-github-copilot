---
paths:
  - "**/*.cs"
  - "**/*.axaml"
  - "**/xunit.runner*"
---
# Avalonia Testing

> This file extends [common/testing.md](../common/testing.md) with Avalonia/C# specific content.

## Framework

Use **xUnit** for unit tests and **Avalonia.Headless** for UI tests.

## ViewModel Testing (xUnit)

```csharp
public class MainViewModelTests
{
    [Fact]
    public async Task SaveCommand_ShouldUpdateStatus()
    {
        var mockService = Substitute.For<IDataService>();
        var vm = new MainViewModel(mockService);

        vm.UserName = "Test User";
        await vm.SaveCommand.ExecuteAsync(null);

        await mockService.Received(1).SaveAsync("Test User", Arg.Any<CancellationToken>());
    }
}
```

## Headless UI Testing (Avalonia.Headless)

```csharp
[AvaloniaFact]
public async Task Button_Click_ShouldInvokeCommand()
{
    var app = AvaloniaApp.GetApp();
    var window = new MainWindow();

    window.Show();
    var button = window.FindControl<Button>("SaveButton");
    button!.RaiseEvent(new RoutedEventArgs(Button.ClickEvent));

    Assert.True(/* assertion */);
}
```

## Coverage

```bash
# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Generate report
reportgenerator -reports:coverage.xml -targetdir:coverage-report
```

## Agent Support

- Use **avalonia-reviewer** agent for test quality review
