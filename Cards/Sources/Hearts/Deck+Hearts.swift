import CardsModel

extension Deck {
    static func hearts(playerCount: Int) -> [PlayingCard] {
        Deck.noJokers.filter {
            !cardsToRemove(playerCount: playerCount).contains($0)
        }
    }
    
    static func cardsToRemove(playerCount: Int) -> [PlayingCard] {
        switch playerCount {
        case 3:
            return [.suited(.two, .clubs)]
        case 5:
            return [
                .suited(.two, .clubs),
                .suited(.two, .diamonds)
            ]
        case 6:
            return [
                .suited(.two, .clubs),
                .suited(.three, .clubs),
                .suited(.two, .diamonds),
                .suited(.two, .spades)
            ]
        default:
            return []
        }
    }
}
