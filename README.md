# LightOperations
## Description
Super light framework based on Operation, it eases the creation of operations and their data binding in OperationQueues.

* A ready-to-sublcass LightOperation eliminates the need of boiler plate code when creating asynchronous operations and provides the relevant KVO state notifications off the shelf. 

* A Coupler class can make your life easy when using OperationQueues. The Coupler class allows to pass the result of the first operation, transform it (optionally) and pass it as input data of the next operation.
It will also set the correct dependencies between the two operations.

You can see this framework in action in my project GeoApp.

Tests coming soon. 

## Installation
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate LightOperations into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'LightOperations', :git => 'https://github.com/AleManni/LightOperations'
end
```
Then, run the following command:
```
$ pod install
```
