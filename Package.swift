// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GDGauge",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GDGauge",
            targets: ["GDGauge"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GDGauge",
            dependencies: []),
        .testTarget(
            name: "GDGaugeTests",
            dependencies: ["GDGauge"]),
    ]
)
