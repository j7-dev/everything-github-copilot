# ABP Angular Quick Start

> 來源：https://abp.io/docs/9.3/framework/ui/angular/quick-start

# ABP Angular Quick Start

In this version ABP uses Angular 20.0.x version. You don't have to install Angular CLI globally

## How to Prepare Development Environment

Please follow the steps below to prepare your development environment for Angular.

1. Install Node.js: Please visit Node.js downloads page and download proper Node.js v20.19+ installer for your OS. An alternative is to install NVM and use it to have multiple versions of Node.js in your operating system.
2. [Optional] Install Yarn: You may install Yarn v1.22+ (not v2) following the instructions on the installation page . Yarn v1 delivers an arguably better developer experience compared to npm v10 and below. You may skip this step and work with npm, which is built-in in Node.js, instead.
3. [Optional] Install VS Code: VS Code is a free, open-source IDE which works seamlessly with TypeScript. Although you can use any IDE including Visual Studio or Rider, VS Code will most likely deliver the best developer experience when it comes to Angular projects. ABP project templates even contain plugin recommendations for VS Code users, which VS Code will ask you to install when you open the Angular project folder. Here is a list of recommended extensions: Angular Language Service Prettier - Code formatter TSLint Visual Studio IntelliCode Path Intellisense npm Intellisense Angular 10 Snippets - TypeScript, Html, Angular Material, ngRx, RxJS & Flex Layout JavaScript (ES6) code snippets Debugger for Chrome Git History indent-rainbow

## How to Start a New Angular Project

You have multiple options to initiate a new Angular project that works with ABP:

### 1. Using ABP CLI

ABP CLI is probably the most convenient and flexible way to initiate an ABP solution with an Angular frontend. Simply install the ABP CLI and run the following command in your terminal:

```shell
abp new MyCompanyName.MyProjectName -csf -u angular

```

> 
To see further options in the CLI, please visit the CLI manual .

This command will prepare a solution with an Angular and a .NET Core project in it. Please visit Getting Started section for further instructions on how to set up the backend of your solution.

To continue reading without checking other methods, visit Angular project structure section .

### 2. Generating a CLI Command from Get Started Page

You can generate a CLI command on the get started page of the abp.io website . Then, use the command on your terminal to create a new Startup Template .

## Angular Project Structure

After creating a solution, open its "angular" directory in your IDE. This is how the contents of the root folder looks like:

Here is what these folders and files are for:

- .vscode has extension recommendations in it.
- e2e is a separate app for possible end-to-end tests.
- src is where the source files for your application are placed. We will have a closer look in a minute.
- .browserlistrc helps configuring browser compatibility of your Angular app .
- .editorconfig helps you have a shared coding style for separate editors and IDEs. Check EditorConfig.org for details.
- .gitignore defined which files and folders should not be tracked by git. Check git documentation for details.
- .prettierrc includes simple coding style choices for Prettier , an auto-formatter for TypeScript, HTML, CSS, and more. If you install recommended extensions to VS Code, you will never have to format your code anymore.
- angular.json is where Angular workspace is defined. It holds project configurations and workspace preferences. Please refer to Angular workspace configuration for details.
- karma.conf.js holds Karma test runner configurations.
- package.json is where your package dependencies are listed. It also includes some useful scripts for developing, testing, and building your application.
- README.md includes some of Angular CLI command examples. You either have to install Angular CLI globally or run these commands starting with yarn or npx to make them work.
- start.ps1 is a simple PowerShell script to install dependencies and start a development server via Angular CLI , but you probably will not need that after reading this document.
- tsconfig.json and all other tsconfig files in general, include some TypeScript and Angular compile options.
- yarn.lock enables installing consistent package versions across different devices so that working application build will not break because of a package update. Please read Yarn documentation if you are interested in more information on the topic. If you have decided to use npm, please remove this file and keep the package-lock.json instead.

Now let us take a look at the contents of the source folder.

- app is the main directory you put your application files in. Any component, directive, service, pipe, guard, interceptor, etc. should be placed here. You are free to choose any folder structure, but organizing Angular applications using configuration-based structure is generally a fine practice, especially when using standalone APIs. This replaces the older convention of organizing strictly by NgModules.
- home is a predefined component and acts as a welcome page. It also demonstrates how a feature-based folder structure may look like. More complex features will probably have sub-features, thus inner folders. You may change the home folder however you like.
- app.routes.ts is where your top-level routes are defined. Angular is capable of lazy loading routes now , so not all routes will be here. You may think of Angular routing as a tree and this file is the top of the tree.
- app.component.ts is essentially the top component that holds the dynamic application layout.
- app.config.ts is the root configuration that includes information about how parts of your application are related and what to run at the initiation of your application.
- route.provider.ts is used for modifying the menu .
- assets is for static files. A file (e.g. an image) placed in this folder will be available as is when the application is served.
- environments includes one file per environment configuration. There are two configurations by default, but you may always introduce another one. These files are directly referred to in angular.json and help you have different builds and application variables. Please refer to configuring Angular application environments for details.
- index.html is the HTML page served to visitors and will contain everything required to run your application. Servers should be configured to redirect every request to this page so that the Angular router can take over. Do not worry about how to add JavaScript and CSS files to it, because Angular CLI will do it automatically.
- main.ts bootstraps and configures Angular application to run in the browser. It is production-ready, so forget about it.
- polyfill.ts is where you can add polyfills if you want to support legacy browsers .
- style.scss is the default entry point for application styles. You can change this or add new entry points in angular.json .
- test.ts helps the unit test runner discover and bootstrap spec files.

Phew! So many files, right? Yet, most of them are typically not subject to change or, even when they are so, the CLI tooling will do the job for you. The main focus should be on the app folder and its content.

Next, we will take a look at the commands used to prepare, build, and serve our application.

## How to Run the Angular Application

Now that you know about the files and folders, we can get the application up and running.

1. Make sure the database migration is complete and the API is up and running .
2. Run yarn or npm install if you have not already.
3. Run yarn start or npm start . The first compilation may take a while. This will start a live development server and launch your default browser in the end.
4. Visit the browser page that opens after the compilation 1 .

You may modify the behavior of the start script (in the package.json file) by changing the parameters passed to the ng serve command. For instance, if you do not want a browser window to open next time you run the script, remove --open from the end of it. Please check ng serve documentation for all available options.

### Angular Live Development Server

The development server of Angular is based on Webpack DevServer . It tracks changes to source files and syncs the browser window after an incremental re-compilation every time 2 you make one. Your experience will be like this:

Please keep in mind that you should not use this server in production. To provide the fastest experience, the compiler skips some heavy optimizations and the development server is simply not built for multiple clients. The next section will describe what to do.

---
