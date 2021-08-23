// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleNetworkLayer",
    platforms: [.iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macOS(.v10_15)],
    products: [
        .library(name: "SimpleNetworkLayer", targets: ["SimpleNetworkLayer"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SimpleNetworkLayer", dependencies: []),
        .testTarget(name: "SimpleNetworkLayerTests", dependencies: ["SimpleNetworkLayer"]),
    ]
)
