# AwsSns - Swift

AwsSns is a Swift library that enables you to use Amazon Web Service Simple Notification Service (AWS SNS) with Swift. More details on this are available from the [AWS SNS documentation](https://aws.amazon.com/documentation/sns/).

<p>
<a href="https://travis-ci.org/nikola-mladenovic/AwsSwiftSNSsdk" target="_blank">
<img src="https://travis-ci.org/nikola-mladenovic/AwsSwiftSNSsdk.svg?branch=master">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" alt="Swift 4.1">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-4E4E4E.svg?colorA=EF5138" alt="Platforms iOS | macOS | watchOS | tvOS | Linux">
</a>
<a href="https://github.com/apple/swift-package-manager" target="_blank">
<img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorB=64A5DE" alt="SPM compatible">
</a>
</p>

This package builds with Swift Package Manager. Ensure you have installed and activated the latest Swift 4.1 tool chain.

## Quick Start

To use AwsSns, modify the Package.swift file and add following dependency:

``` swift
.package(url: "https://github.com/nikola-mladenovic/AwsSwiftSNSsdk", .branch("master"))
```

Then import the `AwsSns` library into the swift source code:

``` swift
import AwsSns
```

## Usage

The current release provides `Publish` functionality.
First initialize the `AwsSns` instance with your credentials and the SNS host:
``` swift
let snsClient = AwsSns(host: "https://sns.us-west-2.amazonaws.com/", accessKeyId: "593ca2ad2782e4000a586d28", secretAccessKey: "ASDI/YZZfLXLna3xEn7JTIJhyH/YZZfLXLna3xEn7JTIJhyH")
```
Then use the `publish` method of the `AwsSns` instance to send messages to the SNS topic or the SNS target. Message can be represented either as `String` or as JSON (dictionary).
Example with `String`:
``` swift
snsClient.publish(message: "Your message", topicArn: "arn:aws:sns:us-west-2:487164526243:test", completion: { success, error in
    // Do some work
    ...
})
```
To create an endpoint for a device and mobile app on one of the supported push notification services, such as GCM and APNS, use `createPlatformEndpoint` method of the `AwsSns` instance. The `endpointArn` that is returned by completion closure when using `createPlatformEndpoint` can then be used by the `publish` method to send a message to a mobile app.
Example:
``` swift
let token = "93SDOIFUHWIUEHF839UR0Q93JRF0W93FJ04W385U2Q0"
let platformApplicationArn = "arn:aws:sns:us-west-2:3904190132:app/test"

snsClient.createPlatformEndpoint(token: token, platformApplicationArn: platformApplicationArn) { success, endpointArn, error in
    // Do some work
    ...
}
```
To list the platform application objects for the supported push notification services, such as APNS and GCM, use `listPlatformApplications` method of the `AwsSns` instance. Method can return up to 100 platform application objects per call in it's completion closure. If additional objects are available after the first page results, then a `nextToken` string will not be `nil` in response object.
Example:
``` swift
snsClient.listPlatformApplications { (success, response, error) in
    // Do some work
    ...
}
```
To list the endpoint application arns for devices in a supported push notification service, such as GCM and APNS, use `listEndpointsBy` method of the `AwsSns` instance. Method can return up to 100 platform application objects per call in it's completion closure. If additional objects are available after the first page results, then a `nextToken` string will not be `nil` in response object.
Example:
``` swift
let platformApplicationArn = "arn:aws:sns:us-west-2:3904190132:app/test"

snsClient.listEndpointsBy(platformApplicationArn: platformApplicationArn) { (success, response, error) in
    // Do some work
    ...
}
```
To delete the endpoint for a device and mobile app from Amazon SNS, use `deleteEndpoint` method of the `AwsSns` instance. When you delete an endpoint that is also subscribed to a topic, then you must also unsubscribe the endpoint from the topic.
Example:
``` swift
let endpointArn = "arn:aws:sns:us-west-2:4834231343:endpoint/Example/a34939514-6d01-4444-3333-ffba93942"

snsClient.deleteEndpoint(endpointArn: endpointArn) { success, error in
    // Endpoint deleted
    ...
}
```
To retrive the endpoint attributes for a device on one of the supported push notification services, such as GCM and APNS, use `getEndpointAttributes` method of the `AwsSns` instance.
Example:
``` swift
let endpointArn = "arn:aws:sns:us-west-2:4834231343:endpoint/Example/a34939514-6d01-4444-3333-ffba93942"

snsClient.getEndpointAttributes(endpointArn: endpointArn) { (success, attributes, error) in
    // Do some work
    ...
}
```
To set the attributes for an endpoint for a device on one of the supported push notification services, such as GCM and APNS, use `setEndpointAttributes` method of the `AwsSns` instance.
Example:
``` swift
let endpointArn = "arn:aws:sns:us-west-2:4834231343:endpoint/Example/a34939514-6d01-4444-3333-ffba93942"
let attributes = [ "Enabled" : "false",
                   "Token" : "93SDOIFUHWIUEHF839UR0Q93JRF0W93FJ04W385U2Q0" ]

snsClient.setEndpointAttributes(endpointArn: endpointArn, attributes: attributes) { (success, error) in
    // Do some work
    ...
}
```
