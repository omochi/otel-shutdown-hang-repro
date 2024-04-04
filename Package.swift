// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "otel-shutdown-hang-repro",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "App", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.92.5"),
        .package(url: "https://github.com/apple/swift-distributed-tracing", exact: "1.0.1"),
        .package(url: "https://github.com/slashmo/swift-otel", branch: "main"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
                .product(name: "OTel", package: "swift-otel"),
                .product(name: "OTLPGRPC", package: "swift-otel"),
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
