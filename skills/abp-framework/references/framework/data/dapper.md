# Dapper Integration

> 來源：https://abp.io/docs/9.3/framework/data/dapper

# Dapper Integration

Dapper is a simple and lightweight object mapper for .NET. A key feature of Dapper is its high performance compared to other ORMs.

While you can use Dapper as is in your ABP applications, there is also an integration package that simplifies creating repository classes using Dapper.

> 
ABP's Dapper integration package is based on Entity Framework Core (EF Core). That means it assumes you will use Dapper mixed with EF Core where EF Core is the primary database provider and you use Dapper when you need to fine-tune your quires and get the maximum performance. See this article if you want to know why it is like that.

## Installation

You can use the ABP CLI to install the Volo.Abp.Dapper package to your project. Execute the following command in the folder of the .csproj file that you want to install the package on:

```bash
abp add-package Volo.Abp.Dapper

```

> 
If you haven't done it yet, you first need to install the ABP CLI. For other installation options, see the package description page .

> 
If you have a layered solution, it is suggested to install that package to your database layer of the solution.

## Implement a Dapper Repository

The best way to interact with Dapper is to create a repository class that abstracts your Dapper database operations. The following example creates a new repository class that works with the People table:

```csharp
public class PersonDapperRepository :
    DapperRepository<MyAppDbContext>, ITransientDependency
{
    public PersonDapperRepository(IDbContextProvider<MyAppDbContext> dbContextProvider)
        : base(dbContextProvider)
    {
    }

    public virtual async Task<List<string>> GetAllPersonNamesAsync()
    {
        var dbConnection = await GetDbConnectionAsync();
        return (await dbConnection.QueryAsync<string>(
            "select Name from People",
            transaction:  await GetDbTransactionAsync())
        ).ToList();
    }

    public virtual async Task<int> UpdatePersonNamesAsync(string name)
    {
        var dbConnection = await GetDbConnectionAsync();
        return await dbConnection.ExecuteAsync(
            "update People set Name = @NewName",
            new { NewName = name },
            await GetDbTransactionAsync()
        );
    }
}

```

Let's examine this class:

- It inherits from the DapperRepository class, which provides useful methods and properties for database operations. It also implements the IUnitOfWorkEnabled interface, so ABP makes the database connection (and transaction if requested) available in the method body by implementing dynamic proxies (a.k.a. interception).
- It gets an IDbContextProvider<MyAppDbContext> object where MyAppDbContext is type of your Entity Framework Core DbContext class. It should be configured as explained in the EF Core document . If you've created by ABP's startup template, then it should already be configured.
- The GetAllPersonNamesAsync and UpdatePersonNamesAsync method's been made virtual . That's needed to make the interception process working.
- We've used the GetDbConnectionAsync and GetDbTransactionAsync methods to obtain the current database connection and transaction (that is managed by ABP's Unit of Work system).

Then you can inject PersonDapperRepository to any service to perform these database operations. If you want to implement a layered solution, we suggest to introduce an IPersonDapperRepository interface in your domain layer, implement it in your database later, then inject the interface to use the repository service.

> 
If you want to learn more details and examples of using Dapper with the ABP, check this community article .

## See Also

- Community Article: Using Dapper with the ABP
- Entity Framework Core integration document

### Related Articles
