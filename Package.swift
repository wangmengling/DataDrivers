import PackageDescription

let package = Package(
    name: "ObjectMapper",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", majorVersion: 2, minor: 2),
<<<<<<< HEAD
        .Package(url: "https://github.com/ReSwift/ReSwift.git", majorVersion: 3)
=======
        .Package(url: "https://github.com/nakiostudio/EasyPeasy.git",
                 majorVersion: 1),
        
>>>>>>> origin/master
    ]
)
