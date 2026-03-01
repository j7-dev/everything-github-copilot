# String Encryption

> 來源：https://abp.io/docs/9.3/framework/infrastructure/string-encryption

# String Encryption

ABP provides string encryption feature that allows to Encrypt and Decrypt strings.

## Installation

> 
This package is already installed by default with the startup template. So, most of the time, you don't need to install it manually.

If installation is needed, it is suggested to use the ABP CLI to install this package.

### Using the ABP CLI

Open a command line window in the folder of the project (.csproj file) and type the following command:

```bash
abp add-package Volo.Abp.Security

```

### Manual Installation

If you want to manually install;

1. Add the Volo.Abp.Security NuGet package to your project: dotnet add package Volo.Abp.Security
2. Add the AbpSecurityModule to the dependency list of your module: [DependsOn(
    //...other dependencies
    typeof(AbpSecurityModule) // <-- Add module dependency like that
    )]
public class YourModule : AbpModule
{
}

## Using String Encryption

All encryption operations are included in IStringEncryptionService . You can inject it and start to use.

```csharp
 public class MyService : DomainService
 {
     protected IStringEncryptionService StringEncryptionService { get; }

     public MyService(IStringEncryptionService stringEncryptionService)
     {
         StringEncryptionService = stringEncryptionService;
     }

     public string Encrypt(string value)
     {
         // To encrypt a value
         return StringEncryptionService.Encrypt(value);
     }

     public string Decrypt(string value)
     {
         // To decrypt a value
         return StringEncryptionService.Decrypt(value);
     }
 }

```

### Using Custom PassPhrase

IStringEncryptionService methods has passPharase parameter with default value and it uses default PassPhrase when you don't pass passPhrase parameter.

```csharp
// Default Pass Phrase
var encryptedValue = StringEncryptionService.Encrypt(value);

// Custom Pass Phrase
var encryptedValue = StringEncryptionService.Encrypt(value, "MyCustomPassPhrase");

// Encrypt & Decrypt have same parameters.
var decryptedValue = StringEncryptionService.Decrypt(value, "MyCustomPassPhrase");

```

### Using Custom Salt

IStringEncryptionService methods has salt parameter with default value and it uses default Salt when you don't pass the parameter.

```csharp
// Default Salt
var encryptedValue = StringEncryptionService.Encrypt(value);

// Custom Salt
var encryptedValue = StringEncryptionService.Encrypt(value, salt: Encoding.UTF8.GetBytes("MyCustomSalt")); 

// Encrypt & Decrypt have same parameters.
var decryptedValue = StringEncryptionService.Decrypt(value,  salt: Encoding.UTF8.GetBytes("MyCustomSalt"));

```

---
