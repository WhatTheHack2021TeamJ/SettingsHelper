![settingsHelperLogo](./logo.png)
    
# Settings Helper

WhatTheHack Hackathon was a 24 hacking-hour adventure crafted by Cyril Garcia and Ting Becker. All together teams paired up and crafted some beautiful and very useful ideas.

Our team came together and built a framework to help support future SwiftUI developers in simplifying the creation of their very own Settings views. The primary focus of the framework was to get a developer up and running with a settings panel with very little input.


## Installation

First you'll want to add the Swift Package Manager source to your project. You can do this with this link:

`https://github.com/WhatTheHack2021TeamJ/SettingsHelper.git`

Once you have added the package you can continue to the usage of the package.

## Usage

SettingsHelper uses a configuration file to set up the Settings View.

You'll want to include some individual details in this initializer.

To create your configuration you'll create something like this:

```swift
struct ContentView: View {

    var body: some View {
    
        ZStack {
        
            SettingsView(settings:
                SettingsConfiguration(
                    email: "test@test.com",
                    licenseUsage: .useGeneratedLicenses,
                    bundle: .main,
                    creditsUsage: .useCredits(StaticTextContent(content: "Thanks to everyone at WhatTheHack 2021 Hackathon 😊🎉")),
                    dataPrivacyUsage: .useDataPrivacy(StaticTextContent(content: "We sell all your data.")),
                    questionsAndAnswers:
                        [QuestionAndAnswer(title: "Who will win the prizes?", content: "Good question. That will be the settings framework.")]
                )
            )
        }
        
    }
}
```

Let's look at each parameter a littler closer.

##### `email`

This is a string value representing the email you would like to be reached at.

##### `licenseUsage`

The LicenseOptions will either be `.none` or `.useGeneratedLicenses()`. If you choose the latter the framework will not include this section in your settings.

> This project uses an auto generation of any Licenses inside of the Source Packages folder. Gone are the days of making individual views and copy pasting that MIT License over.

##### `bundle`

Your bundle that will be used. By default `.main` is recommended.

##### `creditsUsage`

The CreditsOptions will either be `.none` or `.useCredits()`. If you choose the latter the framework will not include this section in your settings.

##### `dataPrivacyUsage`

The DataPrivacyOptions will either be `.none` or `.useDataPrivacy()`. If you choose the latter the framework will not include this section in your settings.

##### `questionsAndAnswers`

The QuestionAndAnswers will contain `title` and `content` parameters. Excluding this will result in the framework not including an FAQ.

## Screenshots

<img src="https://user-images.githubusercontent.com/18172931/104855012-2a40c480-58d8-11eb-92b0-a5b706b8446e.png" width="200" height="400" />

## Automatic LICENSE file handling

This framework can automatically copy the LICENSE files to your app when building. It iterates over every SPM project that your projects uses and look for LICENSE fies. They are added to your *.app bundle resources.

To do this, add a *New Run Script Phase* in your *Build Phases* and use the following command: `${BUILD_DIR}/../../SourcePackages/checkouts/SettingsHelper/Sources/SettingsHelperGenerator/main.swift`

<img src="assets/SettingsHelper Copy Licenses Run Script.png" width="400">



## Support

If you have any questions about the framework contact [Yannick](https://github.com/yrave), [Joseph](https://github.com/javb99), or [Yon](https://github.com/Yonodactyl)
