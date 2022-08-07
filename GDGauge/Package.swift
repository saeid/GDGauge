// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GDGauge",
    platforms: [
        .iOS(.v13),
        .watchOS(.v5),
    ],
    products: [
        .library(name: "GDGauge", targets: ["GDGauge"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "GDGauge", dependencies: []),
        .testTarget(name: "GDGaugeTests", dependencies: ["GDGauge"]),
    ]
)
