// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "otel-shutdown-hang-repro",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "App", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.92.5")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        .executableTarget(
            name: "run",
            dependencies: [
                .target(name: "App")
            ]
        )
    ]
)
