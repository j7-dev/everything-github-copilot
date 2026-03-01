# BLOB Storing Aliyun Provider

> 來源：https://abp.io/docs/9.3/framework/infrastructure/blob-storing/aliyun

# BLOB Storing Aliyun Provider

BLOB Storing Aliyun Provider can store BLOBs in Aliyun Blob storage .

> 
Read the BLOB Storing document to understand how to use the BLOB storing system. This document only covers how to configure containers to use a Aliyun BLOB as the storage provider.

## Installation

Use the ABP CLI to add Volo.Abp.BlobStoring.Aliyun NuGet package to your project:

- Install the ABP CLI if you haven't installed before.
- Open a command line (terminal) in the directory of the .csproj file you want to add the Volo.Abp.BlobStoring.Aliyun package.
- Run abp add-package Volo.Abp.BlobStoring.Aliyun command.

If you want to do it manually, install the Volo.Abp.BlobStoring.Aliyun NuGet package to your project and add [DependsOn(typeof(AbpBlobStoringAliyunModule))] to the ABP module class inside your project.

## Configuration

Configuration is done in the ConfigureServices method of your module class, as explained in the BLOB Storing document .

Example: Configure to use the Aliyun storage provider by default

```csharp
Configure<AbpBlobStoringOptions>(options =>
{
    options.Containers.ConfigureDefault(container =>
    {
        container.UseAliyun(aliyun =>
        {
            aliyun.AccessKeyId = "your aliyun access key id";
            aliyun.AccessKeySecret = "your aliyun access key secret";
            aliyun.Endpoint = "your oss endpoint";
            aliyun.RegionId = "your sts region id";
            aliyun.RoleArn = "the arn of ram role";
            aliyun.RoleSessionName = "the name of the certificate";
            aliyun.Policy = "policy";
            aliyun.DurationSeconds = "expiration date";
            aliyun.ContainerName = "your aliyun container name";
            aliyun.CreateContainerIfNotExists = true;
        });
    });
});

```

> 
See the BLOB Storing document to learn how to configure this provider for a specific container.

### Options

- AccessKeyId ([NotNull]string): AccessKey is the key to access the Alibaba Cloud API. It has full permissions for the account. Please keep it safe! Recommend to follow Alibaba Cloud security best practicess ,Use RAM sub-user AccessKey to call API.
- AccessKeySecret ([NotNull]string): Same as above.
- Endpoint ([NotNull]string): Endpoint is the external domain name of OSS. See the document for details.
- UseSecurityTokenService (bool): Use STS temporary credentials to access OSS services,default: false .
- RegionId (string): Access address of STS service. See the document for details.
- RoleArn ([NotNull]string): STS required role ARN. See the document for details.
- RoleSessionName ([NotNull]string): Used to identify the temporary access credentials, it is recommended to use different application users to distinguish.
- Policy (string): Additional permission restrictions. See the document for details.
- DurationSeconds (int): Validity period(s) of a temporary access certificate,minimum is 900 and the maximum is 3600.
- ContainerName (string): You can specify the container name in Aliyun. If this is not specified, it uses the name of the BLOB container defined with the BlobContainerName attribute (see the BLOB storing document ). Please note that Aliyun has some rules for naming containers . A container name must be a valid DNS name, conforming to the following naming rules : Container names must start or end with a letter or number, and can contain only letters, numbers, and the dash (-) character. Container names Must start and end with lowercase letters and numbers. Container names must be from 3 through 63 characters long.
- CreateContainerIfNotExists (bool): Default value is false , If a container does not exist in Aliyun, AliyunBlobProvider will try to create it.
- TemporaryCredentialsCacheKey (bool): The cache key of STS credentials.

## Aliyun Blob Name Calculator

Aliyun Blob Provider organizes BLOB name and implements some conventions. The full name of a BLOB is determined by the following rules by default:

- Appends host string if current tenant is null (or multi-tenancy is disabled for the container - see the BLOB Storing document to learn how to disable multi-tenancy for a container).
- Appends tenants/<tenant-id> string if current tenant is not null .
- Appends the BLOB name.

## Other Services

- AliyunBlobProvider is the main service that implements the Aliyun BLOB storage provider, if you want to override/replace it via dependency injection (don't replace IBlobProvider interface, but replace AliyunBlobProvider class).
- IAliyunBlobNameCalculator is used to calculate the full BLOB name (that is explained above). It is implemented by the DefaultAliyunBlobNameCalculator by default.
- IOssClientFactory is used create OSS client. It is implemented by the DefaultOssClientFactory by default. You can override/replace it,if you want customize.

### Related Articles
