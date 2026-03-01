# ASP.NET Core MVC / Razor Pages UI: JavaScript Global Features API

> 來源：https://abp.io/docs/9.3/framework/ui/mvc-razor-pages/javascript-api/global-features

# ASP.NET Core MVC / Razor Pages UI: JavaScript Global Features API

abp.globalFeatures API allows you to get the enabled features of the Global Features in the client side.

> 
This document only explains the JavaScript API. See the Global Features document to understand the ABP Global Features system.

## Usage

```js
//Gets all enabled global features.
> abp.globalFeatures.enabledFeatures

[ 'Shopping.Payment', 'Ecommerce.Subscription' ]

//Check the global feature is enabled
> abp.globalFeatures.isEnabled('Ecommerce.Subscription')

true

> abp.globalFeatures.isEnabled('My.Subscription')

false

```

### Related Articles
