// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "AwsSns",
    products: [.library(name: "AwsSns", targets: ["AwsSns"])],
    dependencies: [.package(url: "https://github.com/nikola-mladenovic/AwsSwiftSign.git", from: "0.1.0"),
                   .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.1.1")],
    targets: [.target(name: "AwsSns", dependencies: ["AwsSign", "SWXMLHash"]),
              .testTarget(name: "AwsSnsTests", dependencies: ["AwsSns"])]
)
