import CardsModel

public struct SevensPlayer {
    public static func chooseCard(_ cards: Hand) -> PlayingCard? {
        cards.filter { $0.isValid }.randomElement()?.card
    }
}
