// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "google-mlkit-commons",
    platforms: [
        .iOS("15.5")
    ],
    products: [
        .library(
            name: "google-mlkit-commons",
            targets: ["google_mlkit_commons"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/OWNER_PLACEHOLDER/hoopooh-mlkit-swiftpm",
            exact: "9.0.0-hoopooh.1"
        )
    ],
    targets: [
        .target(
            name: "google_mlkit_commons",
            dependencies: [
                // hoopooh: MLKitVision is the product this plugin actually
                // imports (MLKitCommon + MLKitVision). Upstream PR #890 used
                // MLKitBarcodeScanning only because its wrapper had no such product.
                .product(name: "MLKitVision", package: "hoopooh-mlkit-swiftpm")
            ],
            path: "Sources/google_mlkit_commons"
        )
    ]
)
