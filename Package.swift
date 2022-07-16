// swift-tools-version:5.2.0

import PackageDescription

let package = Package(
    name: "firebird-kit",
	platforms: [
		.macOS(.v10_15),
	],
    products: [
        .library(
            name: "FirebirdSQL",
            targets: ["FirebirdSQL"]),
    ],
    dependencies: [
		.package(
			url: "https://github.com/vapor/async-kit.git",
			from: "1.4.0"),
		.package(
			url: "https://github.com/ugocottin/firebird-lib.git",
			from: "1.0.0"),
		.package(
			url: "https://github.com/vapor/sql-kit.git",
			from: "3.18.0"),
    ],
    targets: [
        .target(
            name: "FirebirdSQL",
            dependencies: [
				.product(
					name: "AsyncKit",
					package: "async-kit"),
				.product(
					name: "Firebird",
					package: "firebird-lib"),
				.product(
					name: "SQLKit",
					package: "sql-kit"),
			]),
        .testTarget(
            name: "FirebirdSQLTests",
            dependencies: [
				.target(name: "FirebirdSQL"),
			]),
    ]
)
