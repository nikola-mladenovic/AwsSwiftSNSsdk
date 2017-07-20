# AwsSns - Swift

AwsSns is a Swift library that enables you to use Amazon Web Service Simple Notification Service (AWS SNS) with Swift. More details on this are available from the [AWS SNS documentation](https://aws.amazon.com/documentation/sns/).

<p>
<a href="https://travis-ci.org/nikola-mladenovic/AwsSwiftSNSsdk" target="_blank">
<img src="https://travis-ci.org/nikola-mladenovic/AwsSwiftSNSsdk.svg?branch=master">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat" alt="Swift 4.0">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-4E4E4E.svg?colorA=EF5138" alt="Platforms iOS | macOS | watchOS | tvOS | Linux">
</a>
<a href="https://github.com/apple/swift-package-manager" target="_blank">
<img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorB=64A5DE" alt="SPM compatible">
</a>
</p>

This package builds with Swift Package Manager. Ensure you have installed and activated the latest Swift 4.0 tool chain.

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