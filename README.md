# Tec Nutrición

## Overview

**TecNutricion** is an app made for the nutrition department of `Tec de Monterrey`. It is made for `iOS 8` in `Objective-C`. It uses propietary code from developers and various open source libraries provided from *cocoapods* and other providers.

## Installation and Testing

**TecNutricion** is optimized for every iphone with iOS 8 support. Works well from iphone 4s to iphone 6 plus. The best experience will be felt while using it on an iphone 6.

Because we are using CocoaPods is essential to install this package manager and install the dependencies in order to compile the code.

### Steps

- Download the source code
- Install ruby

if you are using homebrew is pretty simple, you just go to your terminal and run:

```$ brew install ruby```

psst... if you don't have homebrew installed just run this command to install it:

```$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```

- Go ahead and install `CocoaPods`. Easy as this:

```$ gem install cocoapods```

(Depending on your ruby installation you might need to run it on `sudo`)

- Navigate to the project's directory (just *cd* to it!)
- Install cocoapod's dependencies of the project. Just:

``` $ pod install ```

- Open `.xcworkspace` file (Don't open the .xcodeproj!!)
- Compile and run it! It should be ready!

### Testing

If you want to test we included some methods that might be usefull. Please remember for any reason **NOT TO CALL THIS METHODS ON PRODUCTION CODE**. This are only meant for testing the app without waiting various days to view all features. You can always test it this way, after all, that's how users are going to use it.

On the `TECHomeViewController.m` uncomment lines `71` and `75`. This should generate a diet with all the portions set to the same number (we are using 4, you can change it if you like), and create usage for the past n days (we're using 10 days).

This is made by using the methods `generateTestDiet:` and `generateEntriesForThePastDays:`.

####generateTestDiet:

This method creates a diet given an `NSInteger`. It will set all the portions needed to the given number. This can be made manually in the app in the `Dieta` section.

####generateEntriesForThePastDays:

This method simulates app usage for any given number of days. By giving an `NSInteger` as a parameter, the method will create random portion consumptions (between 0 and 6) for all portions for the past given number of days. This can be made manually in the app by using the `TECHomeViewController` features for any number of days. This method is usefull if you want to test the functionality the `TECHistoryViewController` (¿Cómo voy? view).
