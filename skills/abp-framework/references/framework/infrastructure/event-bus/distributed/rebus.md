# Distributed Event Bus Rebus Integration

> 來源：https://abp.io/docs/9.3/framework/infrastructure/event-bus/distributed/rebus

# Distributed Event Bus Rebus Integration

> 
This document explains how to configure the Rebus as the distributed event bus provider. See the distributed event bus document to learn how to use the distributed event bus system

## Installation

Use the ABP CLI to add Volo.Abp.EventBus.Rebus NuGet package to your project:

- Install the ABP CLI if you haven't installed before.
- Open a command line (terminal) in the directory of the .csproj file you want to add the Volo.Abp.EventBus.Rebus package.
- Run abp add-package Volo.Abp.EventBus.Rebus command.

If you want to do it manually, install the Volo.Abp.EventBus.Rebus NuGet package to your project and add [DependsOn(typeof(AbpEventBusRebusModule))] to the ABP module class inside your project.

## Configuration

You can configure using the standard configuration system , like using the options classes.

### The Options Classes

AbpRebusEventBusOptions class can be used to configure the event bus options for the Rebus.

You can configure this options inside the PreConfigureServices of your module .

Example: Minimize configuration

```csharp
PreConfigure<AbpRebusEventBusOptions>(options =>
{
    options.InputQueueName = "eventbus";
});

```

Rebus has many options, you can use the Configurer property of AbpRebusEventBusOptions class to configure.

Default events are stored in memory . See the rebus document for more details.

Example: Configure the store

```csharp
PreConfigure<AbpRebusEventBusOptions>(options =>
{
    options.InputQueueName = "eventbus";
    options.Configurer = rebusConfigurer =>
    {
        rebusConfigurer.Transport(t => t.UseMsmq("eventbus"));
        rebusConfigurer.Subscriptions(s => s.UseJsonFile(@"subscriptions.json"));
    };
});

```

You can use the Publish properpty of AbpRebusEventBusOptions class to change the publishing method

Example: Configure the event publishing

```csharp
PreConfigure<AbpRebusEventBusOptions>(options =>
{
    options.InputQueueName = "eventbus";
    options.Publish = async (bus, type, data) =>
    {
        await bus.Publish(data);
    };
});

```

### Related Articles
