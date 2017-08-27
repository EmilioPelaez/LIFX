import PackageDescription

let package = Package(
	name: "LIFX",
	dependencies: [
		.Package(url: "https://github.com/EmilioPelaez/JSONClient.git", majorVersion: 2)
	],
	exclude: []
)
