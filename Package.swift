// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BandikaSwiftBase",
	platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BandikaSwiftBase",
            targets: ["BandikaSwiftBase"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mr-elbe5/SwiftyHttpServer", from: "1.1.13"),
        .package(url: "https://github.com/apple/swift-crypto", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BandikaSwiftBase",
            dependencies: [
                "SwiftyHttpServer",
                .product(name: "Crypto", package: "swift-crypto")
			],
            resources: [
                .copy("Resources")
            ]),
        .testTarget(
            name: "BandikaSwiftBaseTests",
            dependencies: ["BandikaSwiftBase"]),
    ]
)
