# LightOperations
Super light framework based on Operations, it eases the creation of inter-dependent operations in OperationQueues.

Eliminates the need of boiler plate code when creating asynchronous operations (Operation), by providing a ready-to-sublcass LightOperation. 

A Coupler class can make your life easy when using OperationQueues. The Coupler class allows to pass the result of the first operation, transform it (optionally) and pass it as input data of the next operation.
It will also set the correct dependencies between the operations.

You can see this framework in action in my project GeoApp.

Notes and tests coming soon. 

# Installation
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

$ gem install cocoapods
CocoaPods 1.1.0+ is required to build Alamofire 4.0.0+.
To integrate Alamofire into your Xcode project using CocoaPods, specify it in your Podfile:

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'LightOperations', :git => 'https://github.com/AleManni/LightOperations'
end
Then, run the following command:

$ pod install
