---
paths:
  - "**/*.cs"
  - "**/*.axaml"
  - "**/*.xaml"
---
# Avalonia UI / C# Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Avalonia 11.x / C# specific content.

## Compilation Errors are Architecture Signals

Code-behind logic is a sign of MVVM breakdown. Strive for zero code-behind.

## XAML: Styles Collection (not Resources)

```xml
<!-- WRONG (WPF habit) -->
<UserControl.Resources>
    <Style TargetType="Button">...</Style>
</UserControl.Resources>

<!-- CORRECT (Avalonia) -->
<UserControl.Styles>
    <Style Selector="Button.primary">
        <Setter Property="Background" Value="Blue"/>
    </Style>
</UserControl.Styles>
```

## CompiledBinding (Mandatory)

Always use ``CompiledBinding`` for type safety:

```xml
<UserControl xmlns:vm="using:MyApp.ViewModels"
             x:DataType="vm:MainViewModel"
             x:CompileBindings="True">
    <TextBlock Text="{Binding UserName}" />
    <Button Command="{Binding SaveCommand}" Content="Save" />
</UserControl>
```

## StyledProperty (not DependencyProperty)

```csharp
// WRONG (WPF habit)
public static readonly DependencyProperty TitleProperty = ...

// CORRECT (Avalonia)
public static readonly StyledProperty<string> TitleProperty =
    AvaloniaProperty.Register<MyControl, string>(nameof(Title), defaultValue: "");

public string Title
{
    get => GetValue(TitleProperty);
    set => SetValue(TitleProperty, value);
}
```

## MVVM with CommunityToolkit.Mvvm

```csharp
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

public partial class MainViewModel : ObservableObject
{
    [ObservableProperty]
    private string _userName = string.Empty;

    [RelayCommand]
    private async Task SaveAsync(CancellationToken token)
    {
        await _service.SaveAsync(UserName, token);
    }
}
```

## TreeDataTemplate (not HierarchicalDataTemplate)

```xml
<!-- WRONG (WPF habit) -->
<HierarchicalDataTemplate DataType="viewmodels:FolderViewModel" ItemsSource="{Binding Children}">

<!-- CORRECT (Avalonia) -->
<TreeDataTemplate DataType="viewmodels:FolderViewModel" ItemsSource="{Binding Children}">
    <TextBlock Text="{Binding Name}" />
</TreeDataTemplate>
```

## Reference

See agent: `avalonia-reviewer` for comprehensive Avalonia code review.
See skill: `avalonia-ui` for detailed patterns and WPF migration guide.
