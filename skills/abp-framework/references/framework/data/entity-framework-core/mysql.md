# Switch to EF Core MySQL Provider

> 來源：https://abp.io/docs/9.3/framework/data/entity-framework-core/mysql

# Switch to EF Core MySQL Provider

> 
ABP CLI and the Get Started page already provides an option to create a new solution with MySQL. See that document to learn how to use. This document provides guidance for who wants to manually switch to MySQL after creating the solution.

This document explains how to switch to the MySQL database provider for the application startup template which comes with SQL Server provider pre-configured.

## Replace the Volo.Abp.EntityFrameworkCore.SqlServer Package

.EntityFrameworkCore project in the solution depends on the Volo.Abp.EntityFrameworkCore.SqlServer NuGet package. Remove this package and add the same version of the Volo.Abp.EntityFrameworkCore.MySQL package.

## Replace the Module Dependency

Find YourProjectName EntityFrameworkCoreModule class inside the .EntityFrameworkCore project, remove typeof(AbpEntityFrameworkCoreSqlServerModule) from the DependsOn attribute, add typeof(AbpEntityFrameworkCoreMySQLModule) (also replace using Volo.Abp.EntityFrameworkCore.SqlServer; with using Volo.Abp.EntityFrameworkCore.MySQL; ).

## UseMySQL()

Find UseSqlServer() calls in your solution. Check the following files:

- YourProjectName EntityFrameworkCoreModule.cs inside the .EntityFrameworkCore project. Replace UseSqlServer() with UseMySQL() .
- YourProjectName DbContextFactory.cs inside the .EntityFrameworkCore project. Replace UseSqlServer() with UseMySQL() .

> 
Depending on your solution structure, you may find more code files need to be changed.

## Use Pomelo Provider

Alternatively, you can use the Pomelo.EntityFrameworkCore.MySql provider. Replace the Volo.Abp.EntityFrameworkCore.MySQL package with the Volo.Abp.EntityFrameworkCore.MySQL.Pomelo package in your .EntityFrameworkCore project.

To complete the switch to the Pomelo Provider, you'll need to update your module dependencies. To do that, find YourProjectName EntityFrameworkCoreModule class inside the .EntityFrameworkCore project, replace typeof(AbpEntityFrameworkCoreMySQLModule) with typeof(AbpEntityFrameworkCoreMySQLPomeloModule) in the DependsOn attribute.

Also, if you are switching from a provider other than ABP's MySQL provider, you need to call the UseMySQL method in the relevant places, as described in the next section.

### UseMySQL()

Find UseSqlServer() calls in your solution. Check the following files:

- YourProjectName EntityFrameworkCoreModule.cs inside the .EntityFrameworkCore project. Replace UseSqlServer() with UseMySql() .
- YourProjectName DbContextFactory.cs inside the .EntityFrameworkCore project. Replace UseSqlServer() with UseMySql() .

You also need to specify the ServerVersion . See https://github.com/PomeloFoundation/Pomelo.EntityFrameworkCore.MySql/wiki/Configuration-Options#server-version for more details.

UseMySql(configuration.GetConnectionString("Default"), ServerVersion.AutoDetect(configuration.GetConnectionString("Default"))); or UseMySql(configuration.GetConnectionString("Default"), new MySqlServerVersion(new Version(8, 4, 6)));

> 
Depending on your solution structure, you may find more code files need to be changed.

## Change the Connection Strings

MySQL connection strings are different than SQL Server connection strings. So, check all appsettings.json files in your solution and replace the connection strings inside them. See the connectionstrings.com for details of MySQL connection string options.

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
