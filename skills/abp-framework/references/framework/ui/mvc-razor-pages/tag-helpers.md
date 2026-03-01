# ABP Tag Helpers

> 來源：https://abp.io/docs/9.3/framework/ui/mvc-razor-pages/tag-helpers

# ABP Tag Helpers

ABP defines a set of tag helper components to simply the user interface development for ASP.NET Core (MVC / Razor Pages) applications.

## Bootstrap Component Wrappers

Most of the tag helpers are Bootstrap (v5+) wrappers. Coding bootstrap is not so easy, not so type-safe and contains too much repetitive HTML tags. ABP Tag Helpers makes it easier and type safe .

We don't aim to wrap bootstrap components 100%. Writing native bootstrap style code is still possible (actually, tag helpers generates native bootstrap code in the end), but we suggest to use the tag helpers wherever possible.

ABP also adds some useful features to the standard bootstrap components.

Here, the list of components those are wrapped by the ABP:

- Alerts
- Badges
- Blockquote
- Borders
- Breadcrumb
- Buttons
- Cards
- Carousel
- Collapse
- Dropdowns
- Figures
- Grids
- List Groups
- Modals
- Navigation
- Paginator
- Popovers
- Progress Bars
- Tables
- Tabs
- Tooltips

> 
Until all the tag helpers are documented, you can visit https://bootstrap-taghelpers.abp.io/ to see them with live samples.

## Form Elements

Abp Tag Helpers add new features to standard Asp.Net Core MVC input & select Tag Helpers and wrap them with Bootstrap form controls. See Form Elements documentation .

## Dynamic Forms

Abp Tag helpers offer an easy way to build complete Bootstrap forms . See Dynamic Forms documentation .

### Related Articles
