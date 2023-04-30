# Advanced Flutter and Firebase Authentication

This repository contains code samples and explanations for advanced authentication techniques in Flutter using Firebase Authentication.

## Introduction

Please note that this is a ***WIP*** repo and has not been fully developed as of yet.

## Getting Started

To use the code samples provided in this repository, you will need to have Flutter and Firebase set up on your machine.

### Prerequisites

* Flutter 3.7.10 or higher
* A Firebase project
* Android Studio or Visual Studio Code (with Flutter and Dart plugins installed)

### Installing

1. Clone this repository to your local machine using the following command:
   ```
   git clone https://github.com/your-username/advanced-flutter-firebase-authentication.git
   ```
2. Proceed with **Firebase Setup** if you wish to use your own FIrebase Project, or else skip this step.
3. Once the Firebase setup has been completed. Start with **Firebase Authentication Setup**. (Not required if Step 2 Skipped)
4. Navigate to the project directory and run the following command to install the dependencies:
   ```
   flutter pub get
   ```
5. Run the project and try it out yourself.

#### Firebase Setup

* Create a new Firebase project from `https://firebase.google.com/`
* Select `Android App` to get started and Register the app for android using the following details:
  * Android package name: `com.somen.advanced_flutter_firebase_authentication`
  * Nickname (Optional): `Advanced Authentication`
* Download the `google-services.json` file and add/replace it in `android/app/` folder.
* Other Firebase setup steps has already been completed and need not be redone.

#### Firebase Authentication Setup

* In your firebase project click on **`Authentication`** and then on `Sign-in method`.
* Select the following providers and add/enable them one by one.
  * Email/Password
  * Google (More Setup required)
  * Facebook (Setup Below)
  * Phone
* **Google Provider Additional Steps**
  * We need to configure the firebase project **SHA-1** certificate using Gradle's Signing Report or follow one of the other steps mentioned [here](https://developers.google.com/android/guides/client-auth?authuser=0 "Authenticating Your Client") to get the SHA-1:
    * change directory to android folder
      ```
      > cd android
      ```
    * enter the following command to get the SHA1 and SHA-256 codes:
      ```
      ./gradlew signingReport
      ```
  * Go to your firebase project settings and find `Your apps` under the `General` Tab.
  * Under **`Android Apps`** select your app and then click on **`Add Fingerprint`**.
  * Once added, redownload the `google-services.json` file from your firebase project (It should be in the **`Your apps`**) and replace it in `android/app/` folder.
* **Facebook Provider Setup**
  * We need to create a facebook app in order to get the `App ID` and ` App secret` for our firebase.
    * Go to [developers.facebook.com](https://developers.facebook.com/ "https://developers.facebook.com/") and sign in with your facebook account
    * Click on `MyApps` and create a new app.
    * Select `Set up Facebook Login` and Add the details to create the app.
  * Once the Facebook App has been created, go to the dashboard of the app and select `Settings > Basic`
  * Copy Your `App ID` and `App secret` from here and paste it in your Firebase Project.
  * Congratz, your firebase project and facebook app are connected. But we are not yet done, now we need to setup our flutter project. Follow the steps on [meedu.app](https://facebook.meedu.app/ "https://facebook.meedu.app/") to finish off the setup.
  * 
*
