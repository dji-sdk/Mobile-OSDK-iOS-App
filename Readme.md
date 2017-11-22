# DJI OnboardSDK App for iOS

## What Is This?

The purpose of this app is to help enable quick testing of the OnboardSDK through a mobile app built on the [DJI Mobile SDK](http://developer.dji.com/mobile-sdk/).

## Get Started Immediately

### UILibrary Installation with CocoaPods

Since this project has been integrated with [DJI iOS UILibrary CocoaPods](https://cocoapods.org/pods/DJI-UILibrary-iOS) now, please check the following steps to install **DJISDK.framework** using CocoaPods after you downloading this project:

**1.** Install CocoaPods

Open Terminal and change to the download project's directory, enter the following command to install it:

~~~
sudo gem install cocoapods
~~~

The process may take a long time, please wait. For further installation instructions, please check [this guide](https://guides.cocoapods.org/using/getting-started.html#getting-started).

**2.** Install UILibrary with CocoaPods in the Project

Run the following command in the **OnboardSDK-iOSApp** path:

~~~
pod install
~~~

If you install it successfully, you should get the messages similar to the following:

~~~
Analyzing dependencies
Downloading dependencies
Installing DJI-SDK-iOS (4.2.2)
Installing DJI-UILibrary-iOS (4.2)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `MOS.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod
installed.
~~~

> **Note**: If you saw "Unable to satisfy the following requirements" issue during pod install, please run the following commands to update your pod repo and install the pod again:
>
> ~~~
> pod repo update
> pod install
> ~~~

### Run Sample Code

Developers will need to setup the App Key by editing the sample code's info.plist, [after generating their unique App Key](https://developer.dji.com/mobile-sdk/documentation/quick-start/index.html#generate-an-app-key).

For the app, the key value **DJISDKAppKey** should to be added to "Info.plist" with your unique app key as a string.  
One of DJI's aircraft running the OnboardSDK will be required to use the OnboardSDK functionality this app provides.  

## Development Workflow

If you need to add any actions to the OnboardSDK Actions Menu this can be accomplished by editing the **config.json** file.  The outer dictionary's keys correspond to the sections in the menu.  The value associated with that is an array of dictionaries that represent the individual actions that will be shown in the app.  Each action is represented by 6 key/value pairs:
1.) key - Unique key for this action
2.) cmd_id - The hex code of the command being sent
3.) label - Displayed in the app describing what the action does
4.) info - Any other information about what platform the command is supported on
5.) ack - A boolean that indicated whether we expect to get an ack back
6.) ack_size - The size of the ack we expect to get back

## Feedback

We’d love to have your feedback as soon as possible:

- What improvements would you like to see?
- What is hard to use or inconsistent with your expectations?
- What is good?
- Any bugs you come across.

## Support

You can get support from DJI and the community with the following methods:

- Github Issues or [gitter.im](https://gitter.im/dji-sdk/Onboard-SDK)
- Send email to dev@dji.com describing your problem and a clear description of your setup
- Post questions on [**Stackoverflow**](http://stackoverflow.com) using [**dji-sdk**](http://stackoverflow.com/questions/tagged/dji-sdk) tag
- [**DJI Forum**](http://forum.dev.dji.com/en)
