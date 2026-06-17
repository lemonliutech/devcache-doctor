// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DevStorageDoctor",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "DevStorageCore", targets: ["DevStorageCore"]),
        .executable(name: "devstorage-scan", targets: ["DevStorageCLI"]),
        .executable(name: "DevStorageDoctor", targets: ["DevStorageDoctorApp"])
    ],
    targets: [
        .target(name: "DevStorageCore"),
        .executableTarget(
            name: "DevStorageCLI",
            dependencies: ["DevStorageCore"]
        ),
        .executableTarget(
            name: "DevStorageDoctorApp",
            dependencies: ["DevStorageCore"]
        ),
        .testTarget(
            name: "DevStorageCoreTests",
            dependencies: ["DevStorageCore"]
        )
    ]
)
