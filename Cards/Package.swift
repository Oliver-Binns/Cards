// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Cards",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Cards", targets: ["CardsModel", "CardsScoring", "CardsStyle"]),
        .library(name: "GoFish", targets: ["GoFish"]),
        .library(name: "Hearts", targets: ["Hearts"]),
        .library(name: "Sevens", targets: ["Sevens"])
    ],
    targets: [
        // Core Components: Scoring, Modelling, Styling
        .target(name: "CardsModel"),
        .testTarget(name: "CardsModelTests",
                    dependencies: ["CardsModel"]),
        
        .target(name: "CardsScoring",
                dependencies: ["CardsModel"]),
        .testTarget(name: "CardsScoringTests",
                    dependencies: ["CardsModel", "CardsScoring"]),
        
        .target(name: "CardsStyle", dependencies: ["CardsModel"]),
        
        // Game Components: Each New Game should be a new target
        .target(name: "GoFish", dependencies: [
            "CardsModel", "CardsScoring"
        ]),
    
        .target(name: "Hearts", dependencies: [
            "CardsModel", "CardsScoring"
        ]),

        .target(name: "Sevens", dependencies: [
            "CardsModel", "CardsScoring"
        ]),
        .testTarget(name: "SevensTests", dependencies: [
            "CardsModel", "CardsScoring", "Sevens"
        ]),
    ]
)
