// swift-tools-version:5.7.0

import PackageDescription

let package = Package(
    name: "firebird-kit",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "FirebirdNIO",
                 targets: ["FirebirdNIO"]),
        .library(name: "FirebirdSQL",
                 targets: ["FirebirdSQL"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ugocottin/firebird-lib.git",
                 from: "2.0.0"),
        .package(url: "https://github.com/vapor/sql-kit.git",
                 from: "3.18.0"),
        .package(url: "https://github.com/apple/swift-nio.git",
                 from: "2.10.0"),
        .package(url: "https://github.com/apple/swift-log.git",
                 from: "1.0.0"),
    ],
    targets: [
        .target(name: "FirebirdNIO",
                dependencies: [
                    .product(name: "Firebird",
                             package: "firebird-lib"),
                    .product(name: "Logging",
                             package: "swift-log"),
                    .product(name: "NIOCore",
                             package: "swift-nio"),
                ]),
        .target(name: "FirebirdSQL",
                dependencies: [
                    .target(name: "FirebirdNIO"),
                    .product(name: "SQLKit",
                             package: "sql-kit"),
                ]),
    ]
)
