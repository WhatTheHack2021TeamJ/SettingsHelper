// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SettingsHelper",
    defaultLocalization: "en",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        .library(
            name: "SettingsHelper",
            targets: ["SettingsHelper"]),
        .executable(
            name: "SettingsHelperGenerator",
            targets: ["SettingsHelperGenerator"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SettingsHelper",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .target(
            name: "SettingsHelperGenerator",
            dependencies: [])
    ]
)
