# ASP.NET Core MVC / Razor Pages UI

> 來源：https://abp.io/docs/9.3/framework/ui/mvc-razor-pages/overall

# ASP.NET Core MVC / Razor Pages UI

## Introduction

ABP provides a convenient and comfortable way of creating web applications using the ASP.NET Core MVC / Razor Pages as the User Interface framework.

> 
ABP doesn't offer a new/custom way of UI development. You can continue to use your current skills to create the UI. However, it offers a lot of features to make your development easier and have a more maintainable code base.

### MVC vs Razor Pages

ASP.NET Core provides two models for UI development:

- MVC (Model-View-Controller) is the classic way that exists from the version 1.0. This model can be used to create UI pages/components and HTTP APIs.
- Razor Pages was introduced with the ASP.NET Core 2.0 as a new way to create web pages.

ABP supports both of the MVC and the Razor Pages models. However, it is suggested to create the UI pages with Razor Pages approach and use the MVC model to build HTTP APIs . So, all the pre-build modules, samples and the documentation is based on the Razor Pages for the UI development, while you can always apply the MVC pattern to create your own pages.

### Modularity

Modularity is one of the key goals of the ABP. It is not different for the UI; It is possible to develop modular applications and reusable application modules with isolated and reusable UI pages and components.

The application startup template comes with some application modules pre-installed. These modules have their own UI pages embedded into their own NuGet packages. You don't see their code in your solution, but they work as expected on runtime.

## Theme System

ABP provides a complete Theming system with the following goals:

- Reusable application modules are developed theme-independent , so they can work with any UI theme.
- UI theme is decided by the final application .
- The theme is distributed via NuGet/NPM packages, so it is easily upgradable .
- The final application can customize the selected theme.

### Current Themes

Currently, three themes are officially provided :

- The Basic Theme is the minimalist theme with the plain Bootstrap style. It is open source and free .
- The Lepton Theme is a commercial theme developed by the core ABP team and is a part of the ABP license.
- The LeptonX Theme is a theme that has both commercial and lite choices.

There are also some community-driven themes for the ABP (you can search on the web).

### Base Libraries

There are a set of standard JavaScript/CSS libraries that comes pre-installed and supported by all the themes:

- Twitter Bootstrap as the fundamental HTML/CSS framework.
- JQuery for DOM manipulation.
- DataTables.Net for data grids.
- JQuery Validation for client side & unobtrusive validation
- FontAwesome as the fundamental CSS font library.
- SweetAlert to show fancy alert message and confirmation dialogs.
- Toastr to show toast notifications.
- Lodash as a utility library.
- Luxon for date/time operations.
- JQuery Form for AJAX forms.
- bootstrap-datepicker to show date pickers.
- Select2 for better select/combo boxes.
- Timeago to show automatically updating fuzzy timestamps.
- malihu-custom-scrollbar-plugin for custom scrollbars.

You can use these libraries directly in your applications, without needing to manually import your page.

### Layouts

The themes provide the standard layouts. So, you have responsive layouts with the standard features already implemented. The screenshot below has taken from the Application Layout of the Basic Theme :

See the Theming document for more layout options and other details.

### Layout Parts

A typical layout consists of multiple parts. The Theming system provides menus , toolbars , layout hooks and more to dynamically control the layout by your application and the modules you are using.

## Features

This section highlights some of the features provided by the ABP for the ASP.NET Core MVC / Razor Pages UI.

### Dynamic JavaScript API Client Proxies

Dynamic JavaScript API Client Proxy system allows you to consume your server side HTTP APIs from your JavaScript client code, just like calling local functions.

Example: Get a list of authors from the server

```js
acme.bookStore.authors.author.getList({
  maxResultCount: 10
}).then(function(result){
  console.log(result.items);
});

```

acme.bookStore.authors.author.getList is an auto-generated function that internally makes an AJAX call to the server.

See the Dynamic JavaScript API Client Proxies document for more.

### Bootstrap Tag Helpers

ABP makes it easier & type safe to write Bootstrap HTML.

Example: Render a Bootstrap modal

```html
<abp-modal>
    <abp-modal-header title="Modal title" />
    <abp-modal-body>
        Woohoo, you're reading this text in a modal!
    </abp-modal-body>
    <abp-modal-footer buttons="@(AbpModalButtons.Save|AbpModalButtons.Close)"></abp-modal-footer>
</abp-modal>

```

See the Tag Helpers document for more.

### Forms & Validation

ABP provides abp-dynamic-form and abp-input tag helpers to dramatically simplify to create a fully functional form that automates localization, validation and AJAX submission.

Example: Use abp-dynamic-form to create a complete form based on a model

```html
<abp-dynamic-form abp-model="Movie" submit-button="true" />

```

See the Forms & Validation document for details.

### Bundling & Minification / Client Side Libraries

ABP provides a flexible and modular Bundling & Minification system to create bundles and minify style/script files on runtime.

```html
<abp-style-bundle>
    <abp-style src="/libs/bootstrap/css/bootstrap.css" />
    <abp-style src="/libs/font-awesome/css/font-awesome.css" />
    <abp-style src="/libs/toastr/toastr.css" />
    <abp-style src="/styles/my-global-style.css" />
</abp-style-bundle>

```

Also, Client Side Package Management system offers a modular and consistent way of managing 3rd-party library dependencies.

See the Bundling & Minification and Client Side Package Management documents.

### JavaScript APIs

JavaScript APIs provides a strong abstractions to the server side localization, settings, permissions, features... etc. They also provide a simple way to show messages and notifications to the user.

### Modals, Alerts, Widgets and More

ABP provides a lot of built-in solutions to common application requirements;

- Widget System can be used to create reusable widgets & create dashboards.
- Page Alerts makes it easy to show alerts to the user.
- Modal Manager provides a simple way to build and use modals.
- Data Tables integration makes straightforward to create data grids.

## Customization

There are a lot of ways to customize the theme and the UIs of the pre-built modules. You can override components, pages, static resources, bundles and more. See the User Interface Customization Guide .

### Related Articles
