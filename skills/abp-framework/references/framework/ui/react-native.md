# Getting Started with the React Native

> 來源：https://abp.io/docs/9.3/framework/ui/react-native

# Getting Started with the React Native

> 
React Native mobile option is available for Team or higher licenses

ABP platform provide basic React Native startup template to develop mobile applications integrated to your ABP based backends .

## How to Prepare Development Environment

Please follow the steps below to prepare your development environment for React Native.

1. Install Node.js: Please visit Node.js downloads page and download proper Node.js v20.11+ installer for your OS. An alternative is to install NVM and use it to have multiple versions of Node.js in your operating system.
2. [Optional] Install Yarn: You may install Yarn v1 (not v2) following the instructions on the installation page . Yarn v1 delivers an arguably better developer experience compared to npm v6 and below. You may skip this step and work with npm, which is built-in in Node.js, instead.
3. [Optional] Install VS Code: VS Code is a free, open-source IDE which works seamlessly with TypeScript. Although you can use any IDE including Visual Studio or Rider, VS Code will most likely deliver the best developer experience when it comes to React Native projects.
4. Install an Emulator: React Native applications need an Android emulator or an iOS simulator to run on your OS. See the Android Studio Emulator or iOS Simulator on expo.io documentation to learn how to set up an emulator.

## How to Start a New React Native Project

You have multiple options to initiate a new React Native project that works with ABP:

### 1. Using ABP CLI

ABP CLI is probably the most convenient and flexible way to initiate an ABP solution with a React Native application. Simply install the ABP CLI and run the following command in your terminal:

```shell
abp new MyCompanyName.MyProjectName -csf -u <angular or mvc> -m react-native

```

> 
To see further options in the CLI, please visit the CLI manual .

This command will prepare a solution with an Angular or an MVC (depends on your choice), a .NET Core , and a React Native project in it.

### 2. Generating a CLI Command from Get Started Page

You can generate a CLI command on the get started page of the abp.io website . Then, use the command on your terminal to create a new Startup Template .

## How to Configure & Run the Backend

> 
React Native application does not trust the auto-generated .NET HTTPS certificate. You should use HTTP during the development.

> 
When you are using OpenIddict, You should remove 'clientSecret' on Environment.js (if exists) and disable "HTTPS-only" settings. (Openiddict has default since Version 6.0)

A React Native application running on an Android emulator or a physical phone can not connect to the backend on localhost . To fix this problem, it is necessary to run the backend application on your local IP address .

- Open the appsettings.json file in the .HttpApi.Host folder. Replace the localhost address on the SelfUrl and Authority properties with your local IP address.
- Open the launchSettings.json file in the .HttpApi.Host/Properties folder. Replace the localhost address on the applicationUrl properties with your local IP address.

Run the backend application as described in the getting started document .

> 
You should turn off the "Https Restriction" if you're using OpenIddict as a central identity management solution. Because the IOS Simulator doesn't support self-signed certificates and OpenIddict is set to only work with HTTPS by default.

## How to disable the Https-only settings of OpenIddict

Open the MyProjectNameHttpApiHostModule project and copy-paste the below code-block to the PreConfigureServices method:

```csharp
#if DEBUG
    PreConfigure<OpenIddictServerBuilder>(options =>
    {
        options.UseAspNetCore()
            .DisableTransportSecurityRequirement();
    });
#endif

```

## How to Configure & Run the React Native Application

1. Make sure the database migration is complete and the API is up and running .
2. Open react-native folder and run yarn or npm install if you have not already.
3. Open the Environment.js in the react-native folder and replace the localhost address on the apiUrl and issuer properties with your local IP address as shown below:

> 
Make sure that issuer and apiUrl matches the running address of the .HttpApi.Host or .Web project.

1. Run yarn start or npm start . Wait for the Expo CLI to print the opitons.

> 
The React Native application was generated with Expo . Expo is a set of tools built around React Native to help you quickly start an app and, while it has many features.

In the above image, you can start the application with an Android emulator, an iOS simulator or a physical phone by scanning the QR code with the Expo Client or choosing the option.

### Expo

### Android Studio

1. Start the emulator in Android Studio before running the yarn start or npm start command.
2. Press a to open in Android Studio.

Enter admin as the username and 1q2w3E* as the password to login to the application.

The application is up and running. You can continue to develop your application based on this startup template.

## See Also

- React Native project structure

### Related Articles
