# Switch to EF Core SQLite Provider

> 來源：https://abp.io/docs/9.3/framework/data/entity-framework-core/sqlite

# Switch to EF Core SQLite Provider

> 
ABP CLI and the Get Started page already provides an option to create a new solution with SQLite. See that document to learn how to use. This document provides guidance for who wants to manually switch to SQLite after creating the solution.

This document explains how to switch to the SQLite database provider for the application startup template which comes with SQL Server provider pre-configured.

## Replace the Volo.Abp.EntityFrameworkCore.SqlServer Package

.EntityFrameworkCore project in the solution depends on the Volo.Abp.EntityFrameworkCore.SqlServer NuGet package. Remove this package and add the same version of the Volo.Abp.EntityFrameworkCore.Sqlite package.

## Replace the Module Dependency

Find YourProjectName EntityFrameworkCoreModule class inside the .EntityFrameworkCore project, remove typeof(AbpEntityFrameworkCoreSqlServerModule) from the DependsOn attribute, add typeof(AbpEntityFrameworkCoreSqliteModule) (also replace using Volo.Abp.EntityFrameworkCore.SqlServer; with using Volo.Abp.EntityFrameworkCore.Sqlite; ).

## UseSqlite()

Find UseSqlServer() calls in your solution, replace with UseSqlite() . Check the following files:

- YourProjectName EntityFrameworkCoreModule.cs inside the .EntityFrameworkCore project.
- YourProjectName DbContextFactory.cs inside the .EntityFrameworkCore project.

> 
Depending on your solution structure, you may find more code files need to be changed.

## Change the Connection Strings

SQLite connection strings are different than SQL Server connection strings. So, check all appsettings.json files in your solution and replace the connection strings inside them. See the connectionstrings.com for details of SQLite connection string options.

An example connection string is

```
{
    "ConnectionStrings": {
        "Default": "Filename=./MySQLiteDBFile.sqlite"
    }
}

```

You typically will change the appsettings.json inside the .DbMigrator and .Web projects, but it depends on your solution structure.

## Re-Generate the Migrations

The startup template uses Entity Framework Core's Code First Migrations . EF Core Migrations depend on the selected DBMS provider. So, changing the DBMS provider will cause the migration fails.

- Delete the Migrations folder under the .EntityFrameworkCore project and re-build the solution.
- Run Add-Migration "Initial" on the Package Manager Console (select the .DbMigrator (or .Web ) project as the startup project in the Solution Explorer and select the .EntityFrameworkCore project as the default project in the Package Manager Console).

This will create a database migration with all database objects (tables) configured.

Run the .DbMigrator project to create the database and seed the initial data.

## Run the Application

It is ready. Just run the application and enjoy coding.

### Related Articles
