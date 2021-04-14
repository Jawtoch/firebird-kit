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
		.package(url: "https://github.com/Jawtoch/firebird-nio.git", from: "0.1.0"),
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
