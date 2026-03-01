# Background Jobs Module

> 來源：https://abp.io/docs/9.3/modules/background-jobs

# Background Jobs Module

The Background Jobs module implements the IBackgroundJobStore interface and makes possible to use the default background job manager of the ABP. If you don't want to use this module, then you should implement the IBackgroundJobStore interface yourself.

> 
This document covers only the background jobs module which persists background jobs to a database. See the background jobs document for more about the background jobs system.

## How to Install

This module comes as pre-installed (as NuGet/NPM packages). You can continue to use it as package and get updates easily, or you can include its source code into your solution (see get-source CLI command) to develop your custom module.

### The Source Code

The source code of this module can be accessed here . The source code is licensed with MIT , so you can freely use and customize it.

## Internals

### Domain Layer

#### Aggregates

- BackgroundJobRecord (aggregate root): Represents a background job record.

#### Repositories

Following custom repositories are defined for this module:

- IBackgroundJobRepository

### Database providers

#### Common

##### Table / collection prefix & schema

All tables/collections use the Abp prefix by default. Set static properties on the BackgroundJobsDbProperties class if you need to change the table prefix or set a schema name (if supported by your database provider).

##### Connection string

This module uses AbpBackgroundJobs for the connection string name. If you don't define a connection string with this name, it fallbacks to the Default connection string. See the connection strings documentation for details.

#### Entity Framework Core

##### Tables

- AbpBackgroundJobs

#### MongoDB

##### Collections

- AbpBackgroundJobs

## See Also

- Background job system

### Related Articles
