// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Application",
    platforms: [.iOS(.v15)],
    products: [
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
        .library(
            name: "UserProfile",
            targets: ["UserProfile"]),
        .library(
            name: "ApiClient",
            targets: ["ApiClient"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.6.1"
        ),
        .package(
            url: "https://github.com/hmlongco/Resolver",
            from: "1.5.0"
        ),
        .package(
            name: "GoogleSignIn",
            url: "https://github.com/google/GoogleSignIn-iOS.git",
            from: "6.0.0"
        ),
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "9.1.0"
        ),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                "Authentication",
                "CoreUI",
                "Services",
                "Wallet",
                "UserProfile",
            ]),
        .target(
            name: "Authentication",
            dependencies: [
                "Resources",
                "Services",
                "CoreUI",
                "Core",
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn"),
                .product(name: "Resolver", package: "Resolver"),
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
                "ApiClient",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn"),
            ]),
        .target(
            name: "Wallet",
            dependencies: [
                "Resources",
                "CoreUI",
                "Services",
                "SharedModel",
                .product(name: "Resolver", package: "Resolver"),
            ]),
        .target(
            name: "UserProfile",
            dependencies: [
                "Authentication",
                .product(name: "Resolver", package: "Resolver"),
            ]),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ]),
        .target(name: "SharedModel"),
        .target(
            name: "ApiClient",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ]),
        .testTarget(
            name: "ApplicationTests",
            dependencies: ["Application"]),
    ]
)
