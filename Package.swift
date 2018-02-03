// swift-tools-version:4.0
import PackageDescription

let name = "LIFX"
let package = Package(name: name,
                      products: [.library(name: name, targets: [name])],
                      dependencies: [.package(url: "https://github.com/EmilioPelaez/JSONClient.git", .upToNextMajor(from: "3.0.2"))],
                      targets: [.target(name: name, dependencies: ["JSONClient"], path: "Sources")]
)
