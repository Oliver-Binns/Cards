import SwiftUI

public protocol CardStyle {
    var front: FrontStyle { get }
    var back: BackStyle { get }
}

public protocol FrontStyle {
    func imageName(forCard card: PlayingCard) -> String
}

public extension FrontStyle {
    func image(forCard card: PlayingCard) -> Image {
        Image(imageName(forCard: card), bundle: .module)
    }
}

public protocol BackStyle {
    var imageName: String { get }
}

public extension BackStyle {
    var image: Image {
        Image(imageName, bundle: .module)
    }
}
