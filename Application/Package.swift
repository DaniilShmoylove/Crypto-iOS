// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Application",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Application",
            targets: ["Application"]),
        .library(
            name: "Authentication",
            targets: ["Authentication"]),
        .library(
            name: "Resources",
            targets: ["Resources"]),
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]),
        .library(
            name: "Wallet",
            targets: ["Wallet"]),
        .library(
            name: "Services",
            targets: ["Services"]),
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "SharedModel",
            targets: ["SharedModel"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.6.1")
        ),
        .package(
            url: "https://github.com/dmytro-anokhin/url-image.git",
            from: "3.0.0"
        ),
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "9.1.0"
        ),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Application",
            dependencies: [
                "Authentication",
                "CoreUI",
                "Services",
                "Wallet",
            ]),
        .target(
            name: "Authentication",
            dependencies: [
                "Resources",
                "Services",
                "CoreUI",
                .product(name: "FirebaseAuth", package: "Firebase"),
            ]
        ),
        .target(
            name: "Resources"
        ),
        .target(
            name: "CoreUI",
            dependencies: [
                "Resources",
                "Services",
            ]),
        .target(
            name: "Services",
            dependencies: [
                "Core",
                "SharedModel",
                .product(name: "Alamofire", package: "Alamofire"),
            ]),
        .target(
            name: "Wallet",
            dependencies: [
                "Resources",
                "CoreUI",
                "Services",
                "SharedModel",
            ]),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ]),
        .target(name: "SharedModel"),
        .testTarget(
            name: "ApplicationTests",
            dependencies: ["Application"]),
    ]
)
