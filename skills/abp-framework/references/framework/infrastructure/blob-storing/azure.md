# BLOB Storing Azure Provider

> 來源：https://abp.io/docs/9.3/framework/infrastructure/blob-storing/azure

# BLOB Storing Azure Provider

BLOB Storing Azure Provider can store BLOBs in Azure Blob storage .

> 
Read the BLOB Storing document to understand how to use the BLOB storing system. This document only covers how to configure containers to use a Azure BLOB as the storage provider.

## Installation

Use the ABP CLI to add Volo.Abp.BlobStoring.Azure NuGet package to your project:

- Install the ABP CLI if you haven't installed before.
- Open a command line (terminal) in the directory of the .csproj file you want to add the Volo.Abp.BlobStoring.Azure package.
- Run abp add-package Volo.Abp.BlobStoring.Azure command.

If you want to do it manually, install the Volo.Abp.BlobStoring.Azure NuGet package to your project and add [DependsOn(typeof(AbpBlobStoringAzureModule))] to the ABP module class inside your project.

## Configuration

Configuration is done in the ConfigureServices method of your module class, as explained in the BLOB Storing document .

Example: Configure to use the azure storage provider by default

```csharp
Configure<AbpBlobStoringOptions>(options =>
{
    options.Containers.ConfigureDefault(container =>
    {
        container.UseAzure(azure =>
        {
            azure.ConnectionString = "your azure connection string";
            azure.ContainerName = "your azure container name";
            azure.CreateContainerIfNotExists = true;
        });
    });
});

```

> 
See the BLOB Storing document to learn how to configure this provider for a specific container.

### Options

- ConnectionString (string): A connection string includes the authorization information required for your application to access data in an Azure Storage account at runtime using Shared Key authorization. Please refer to Azure documentation: https://docs.microsoft.com/en-us/azure/storage/common/storage-configure-connection-string
- ContainerName (string): You can specify the container name in azure. If this is not specified, it uses the name of the BLOB container defined with the BlobContainerName attribute (see the BLOB storing document ). Please note that Azure has some rules for naming containers . A container name must be a valid DNS name, conforming to the following naming rules : Container names must start or end with a letter or number, and can contain only letters, numbers, and the dash (-) character. Every dash (-) character must be immediately preceded and followed by a letter or number; consecutive dashes are not permitted in container names. All letters in a container name must be lowercase . Container names must be from 3 through 63 characters long.
- CreateContainerIfNotExists (bool): Default value is false , If a container does not exist in azure, AzureBlobProvider will try to create it.

## Azure Blob Name Calculator

Azure Blob Provider organizes BLOB name and implements some conventions. The full name of a BLOB is determined by the following rules by default:

- Appends host string if current tenant is null (or multi-tenancy is disabled for the container - see the BLOB Storing document to learn how to disable multi-tenancy for a container).
- Appends tenants/<tenant-id> string if current tenant is not null .
- Appends the BLOB name.

## Other Services

- AzureBlobProvider is the main service that implements the Azure BLOB storage provider, if you want to override/replace it via dependency injection (don't replace IBlobProvider interface, but replace AzureBlobProvider class).
- IAzureBlobNameCalculator is used to calculate the full BLOB name (that is explained above). It is implemented by the DefaultAzureBlobNameCalculator by default.

### Related Articles
