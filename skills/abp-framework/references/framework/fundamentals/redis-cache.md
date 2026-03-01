# Redis Cache

> 來源：https://abp.io/docs/9.3/framework/fundamentals/redis-cache

# Redis Cache

ABP Caching System extends the ASP.NET Core distributed cache . So, any provider supported by the standard ASP.NET Core distributed cache can be usable in your application and can be configured just like documented by Microsoft .

However, ABP provides an integration package for Redis Cache: Volo.Abp.Caching.StackExchangeRedis . There are two reasons for using this package, instead of the standard Microsoft.Extensions.Caching.StackExchangeRedis package.

1. It implements SetManyAsync and GetManyAsync methods. These are not standard methods of the Microsoft Caching library, but added by the ABP Caching system. They significantly increases the performance when you need to set/get multiple cache items with a single method call.
2. It simplifies the Redis cache configuration (will be explained below).

> 
Volo.Abp.Caching.StackExchangeRedis is already uses the Microsoft.Extensions.Caching.StackExchangeRedis package, but extends and improves it.

## Installation

> 
This package is already installed in the application startup template if it is using Redis.

Open a command line in the folder of your .csproj file and type the following ABP CLI command:

```bash
abp add-package Volo.Abp.Caching.StackExchangeRedis

```

## Configuration

Volo.Abp.Caching.StackExchangeRedis package automatically gets the Redis configuration from the IConfiguration . So, for example, you can set your configuration inside the appsettings.json :

```js
"Redis": { 
 "IsEnabled": "true",
 "Configuration": "127.0.0.1"
}

```

The setting IsEnabled is optional and will be considered true if it is not set.

Alternatively you can configure the standard RedisCacheOptions options class in the ConfigureServices method of your module :

```csharp
Configure<RedisCacheOptions>(options =>
{
    //...
});

```

## See Also

- Caching

### Related Articles
