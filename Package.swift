// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Ease2",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "Ease2", targets: ["Ease2"])
    ],
    targets: [
        .target(name: "Ease2", path: "Ease2/Classes")
    ]
)
