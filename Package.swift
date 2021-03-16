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
	],
	targets: [
		.target(
			name: "FirebirdKit",
			dependencies: [
				.product(name: "FirebirdNIO", package: "firebird-nio"),
			]),
		.testTarget(name: "FirebirdKitTests", dependencies: ["FirebirdKit"]),
	]
)
