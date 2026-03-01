# MailKit Integration

> 來源：https://abp.io/docs/9.3/framework/infrastructure/mail-kit

# MailKit Integration

MailKit is a cross-platform, popular open source mail client library for .net. ABP provides an integration package to use the MailKit as the email sender .

## Installation

It is suggested to use the ABP CLI to install this package. Open a command line window in the folder of the project (.csproj file) and type the following command:

```bash
abp add-package Volo.Abp.MailKit

```

If you haven't done it yet, you first need to install the ABP CLI. For other installation options, see the package description page .

## Sending Emails

### IEmailSender

Inject the standard IEmailSender into any service and use the SendAsync method to send emails. See the email sending document for details.

> 
IEmailSender is the suggested way to send emails even if you use MailKit, since it makes your code provider independent.

### IMailKitSmtpEmailSender

MailKit package also exposes the IMailKitSmtpEmailSender service that extends the IEmailSender by adding the BuildClientAsync() method. This method can be used to obtain a MailKit.Net.Smtp.SmtpClient object that can be used to perform MailKit specific operations.

## Configuration

MailKit integration package uses the same settings defined by the email sending system. So, refer to the email sending document for the settings.

In addition to the standard settings, this package defines AbpMailKitOptions as a simple options class. This class defines only one options:

- SecureSocketOption : Used to set one of the SecureSocketOptions . Default: null (uses the defaults).

Example: Use SecureSocketOptions.SslOnConnect

```csharp
Configure<AbpMailKitOptions>(options =>
{
    options.SecureSocketOption = SecureSocketOptions.SslOnConnect;
});

```

Refer to the MailKit documentation to learn more about this option.

## See Also

- Email sending

### Related Articles
