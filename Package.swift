import PackageDescription

let package = Package(
    name: "ObjectMapper",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", majorVersion: 2, minor: 2),
        .Package(url: "https://github.com/ReSwift/ReSwift.git", majorVersion: 3),
//        .Package(url: "https://github.com/nakiostudio/EasyPeasy.git",majorVersion: 1),
//        .Package(url: "https://github.com/IBM-Swift/BlueSocket", Version(0,12,19)),
        .Package(url: "https://github.com/IBM-Swift/BlueSocket.git", majorVersion: 0, minor: 12),
        .Package(url: "https://github.com/apple/swift-protobuf.git", majorVersion: 0, minor: 9)
    ]
)
