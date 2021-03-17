// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "firebird-kit",
	platforms: [
		.macOS(.v10_15),
	],
	products: [
		.library(name: "FirebirdKit", targets: ["FirebirdKit"]),
	],
	dependencies: [
		.package(name: "firebird-nio", path: "../firebird-nio"),
		.package(url: "https://github.com/vapor/sql-kit.git", from: "3.1.0"),
	],
	targets: [
		.target(
			name: "FirebirdKit",
			dependencies: [
				.product(name: "FirebirdNIO", package: "firebird-nio"),
				.product(name: "SQLKit", package: "sql-kit"),
			]),
		.testTarget(name: "FirebirdKitTests", dependencies: ["FirebirdKit"]),
	]
)
