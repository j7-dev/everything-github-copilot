# FluentValidation Integration

> 來源：https://abp.io/docs/9.3/framework/fundamentals/fluent-validation

# FluentValidation Integration

ABP Validation infrastructure is extensible. Volo.Abp.FluentValidation NuGet package extends the validation system to work with the FluentValidation library.

## Installation

It is suggested to use the ABP CLI to install this package.

### Using the ABP CLI

Open a command line window in the folder of the project (.csproj file) and type the following command:

```bash
abp add-package Volo.Abp.FluentValidation

```

### Manual Installation

If you want to manually install;

1. Add the Volo.Abp.FluentValidation NuGet package to your project: dotnet add package Volo.Abp.FluentValidation
2. Add the AbpFluentValidationModule to the dependency list of your module:

```csharp
[DependsOn(
    //...other dependencies
    typeof(AbpFluentValidationModule) //Add the FluentValidation module
    )]
public class YourModule : AbpModule
{
}

```

## Using the FluentValidation

Follow the FluentValidation documentation to create validator classes.  Example:

```csharp
public class CreateUpdateBookDtoValidator : AbstractValidator<CreateUpdateBookDto>
{
    public CreateUpdateBookDtoValidator()
    {
        RuleFor(x => x.Name).Length(3, 10);
        RuleFor(x => x.Price).ExclusiveBetween(0.0f, 999.0f);
    }
}

```

ABP will automatically find this class and associate with the CreateUpdateBookDto on object validation.

## See Also

- Validation System

### Related Articles
