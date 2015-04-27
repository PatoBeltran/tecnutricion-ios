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
