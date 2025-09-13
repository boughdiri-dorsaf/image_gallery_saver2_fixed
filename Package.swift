// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "image_gallery_saver",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "image_gallery_saver",
            targets: ["image_gallery_saver"]
        ),
    ],
    dependencies: [
        // Add any dependencies here if needed
    ],
    targets: [
        .target(
            name: "image_gallery_saver",
            dependencies: [],
            path: "ios/Classes",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
    ]
)
