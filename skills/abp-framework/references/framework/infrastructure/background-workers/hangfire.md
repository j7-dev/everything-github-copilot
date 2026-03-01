# Hangfire Background Worker Manager

> 來源：https://abp.io/docs/9.3/framework/infrastructure/background-workers/hangfire

# Hangfire Background Worker Manager

Hangfire is an advanced background jobs and worker manager. You can integrate Hangfire with the ABP to use it instead of the default background worker manager .

The major advantage is that you can use the same server farm to manage your Background Jobs and Workers, as well as leverage the advanced scheduling that is available from Hangfire for Recurring Jobs , aka Background Workers.

## Installation

It is suggested to use the ABP CLI to install this package.

### Using the ABP CLI

Open a command line window in the folder of the project (.csproj file) and type the following command:

```bash
abp add-package Volo.Abp.BackgroundWorkers.Hangfire

```

### Manual Installation

If you want to manually install;

1. Add the Volo.Abp.BackgroundWorkers.Hangfire NuGet package to your project: dotnet add package Volo.Abp.BackgroundWorkers.Hangfire
2. Add the AbpBackgroundWorkersHangfireModule to the dependency list of your module:

```csharp
[DependsOn(
    //...other dependencies
    typeof(AbpBackgroundWorkersHangfireModule) //Add the new module dependency
    )]
public class YourModule : AbpModule
{
}

```

> 
Hangfire background worker integration provides an adapter HangfirePeriodicBackgroundWorkerAdapter to automatically load any PeriodicBackgroundWorkerBase and AsyncPeriodicBackgroundWorkerBase derived classes as IHangfireBackgroundWorker instances. This allows you to still to easily switch over to use Hangfire as the background manager even you have existing background workers that are based on the default background workers implementation .

## Configuration

You can install any storage for Hangfire. The most common one is SQL Server (see the Hangfire.SqlServer NuGet package).

After you have installed these NuGet packages, you need to configure your project to use Hangfire.

1.First, we change the Module class (example: <YourProjectName>HttpApiHostModule ) to add Hangfire configuration of the storage and connection string in the ConfigureServices method:

```csharp
  public override void ConfigureServices(ServiceConfigurationContext context)
  {
      var configuration = context.Services.GetConfiguration();
      var hostingEnvironment = context.Services.GetHostingEnvironment();

      //... other configarations.

      ConfigureHangfire(context, configuration);
  }

  private void ConfigureHangfire(ServiceConfigurationContext context, IConfiguration configuration)
  {
      context.Services.AddHangfire(config =>
      {
          config.UseSqlServerStorage(configuration.GetConnectionString("Default"));
      });
  }

```

> 
You have to configure a storage for Hangfire.

1. If you want to use hangfire's dashboard, you can add UseAbpHangfireDashboard call in the OnApplicationInitialization method in Module class

```csharp
 public override void OnApplicationInitialization(ApplicationInitializationContext context)
 {
    var app = context.GetApplicationBuilder();
            
    // ... others
    
    app.UseAbpHangfireDashboard(); //should add to the request pipeline before the app.UseConfiguredEndpoints()
    app.UseConfiguredEndpoints();
 }

```

### AbpHangfireOptions

You can configure the BackgroundJobServerOptions of AbpHangfireOptions to customize the server.

```csharp
Configure<AbpHangfireOptions>(options =>
{
    // If no ServerOptions is set, ABP will use the default BackgroundJobServerOptions instance.
    options.ServerOptions = new BackgroundJobServerOptions
    {
        Queues = ["default", "alpha"],
        //... other properties
    };
});

```

> 
You don't need to call AddHangfireServer method, ABP will use AbpHangfireOptions's ServerOptions to create a server.

## Create a Background Worker

HangfireBackgroundWorkerBase is an easy way to create a background worker.

```csharp
public class MyLogWorker : HangfireBackgroundWorkerBase
{
    public MyLogWorker()
    {
        RecurringJobId = nameof(MyLogWorker);
        CronExpression = Cron.Daily();
    }

    public override Task DoWorkAsync(CancellationToken cancellationToken = default)
    {
        Logger.LogInformation("Executed MyLogWorker..!");
        return Task.CompletedTask;
    }
}

```

- RecurringJobId Is an optional parameter, see Hangfire document
- CronExpression Is a CRON expression, see CRON expression

> 
You can directly implement the IHangfireBackgroundWorker , but HangfireBackgroundWorkerBase provides some useful properties like Logger.

### UnitOfWork

```csharp
public class MyLogWorker : HangfireBackgroundWorkerBase, IMyLogWorker
{
    public MyLogWorker()
    {
        RecurringJobId = nameof(MyLogWorker);
        CronExpression = Cron.Daily();
    }

    public override Task DoWorkAsync(CancellationToken cancellationToken = default)
    {
        using (var uow = LazyServiceProvider.LazyGetRequiredService<IUnitOfWorkManager>().Begin())
        {
            Logger.LogInformation("Executed MyLogWorker..!");
            return Task.CompletedTask;
        }
    }
}

```

## Register BackgroundWorkerManager

After creating a background worker class, you should add it to the IBackgroundWorkerManager . The most common place is the OnApplicationInitializationAsync method of your module class:

```csharp
[DependsOn(typeof(AbpBackgroundWorkersModule))]
public class MyModule : AbpModule
{
    public override async Task OnApplicationInitializationAsync(
        ApplicationInitializationContext context)
    {
        await context.AddBackgroundWorkerAsync<MyLogWorker>();
    }
}

```

context.AddBackgroundWorkerAsync(...) is a shortcut extension method for the expression below:

```csharp
context.ServiceProvider
    .GetRequiredService<IBackgroundWorkerManager>()
    .AddAsync(
        context
            .ServiceProvider
            .GetRequiredService<MyLogWorker>()
    );

```

So, it resolves the given background worker and adds to the IBackgroundWorkerManager .

While we generally add workers in OnApplicationInitializationAsync , there are no restrictions on that. You can inject IBackgroundWorkerManager anywhere and add workers at runtime. Background worker manager will stop and release all the registered workers when your application is being shut down.

### Related Articles
