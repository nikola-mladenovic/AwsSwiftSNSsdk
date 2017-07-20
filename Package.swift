// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "AwsSns",
    products: [.library(name: "AwsSns", targets: ["AwsSns"])],
    dependencies: [.package(url: "https://github.com/nikola-mladenovic/AwsSwiftSign.git", .branch("master"))],
    targets: [.target(name: "AwsSns", dependencies: ["AwsSign"]),
              .testTarget(name: "AwsSnsTests", dependencies: ["AwsSns"])]
)