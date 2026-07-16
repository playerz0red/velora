// swift-tools-version: 6.0
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
    name: "velora",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "VeloraApp", type: .dynamic, targets: ["VeloraApp"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.9.4"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-firebase.git", "0.0.0"..<"2.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.1.0"),
        .package(url: "https://source.skip.dev/skip-device.git", branch: "main"),
        .package(url: "https://source.skip.dev/skip-kit.git", "0.0.0"..<"2.0.0")
    ],
    targets: [
        .target(name: "VeloraApp", dependencies: [
            .product(name: "SkipFirebaseAuth", package: "skip-firebase"),
            .product(name: "SkipFirebaseFirestore", package: "skip-firebase"),
            .product(name: "SkipUI", package: "skip-ui"),
            .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS", condition: .when(platforms: [.iOS])),
            .product(name: "SkipDevice", package: "skip-device"),
            .product(name: "SkipKit", package: "skip-kit")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "VeloraAppTests", dependencies: [
            "VeloraApp",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
