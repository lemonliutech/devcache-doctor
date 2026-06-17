// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DevStorageDoctor",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "DevStorageCore", targets: ["DevStorageCore"]),
        .executable(name: "devstorage-scan", targets: ["DevStorageCLI"])
    ],
    targets: [
        .target(name: "DevStorageCore"),
        .executableTarget(
            name: "DevStorageCLI",
            dependencies: ["DevStorageCore"]
        ),
        .testTarget(
            name: "DevStorageCoreTests",
            dependencies: ["DevStorageCore"]
        )
    ]
)
