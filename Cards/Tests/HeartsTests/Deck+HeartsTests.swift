import CardsModel
@testable import Hearts
import XCTest

final class DeckHeartsTests: XCTestCase {
    func testCardsToRemove() {
        XCTAssertEqual(
            Deck.cardsToRemove(playerCount: 3),
            [.suited(.two, .clubs)]
        )
        
        XCTAssertEqual(
            Deck.cardsToRemove(playerCount: 4),
            []
        )
        
        XCTAssertEqual(
            Deck.cardsToRemove(playerCount: 5),
            [
                .suited(.two, .clubs),
                .suited(.two, .diamonds),
            ]
        )
        
        XCTAssertEqual(
            Deck.cardsToRemove(playerCount: 6),
            [
                .suited(.two, .clubs),
                .suited(.three, .clubs),
                .suited(.two, .diamonds),
                .suited(.two, .spades)
            ]
        )
    }
    
    func testDeck() {
        XCTAssertEqual(Deck.hearts(playerCount: 4), Deck.noJokers)
        XCTAssertEqual(Deck.hearts(playerCount: 6), [
            .suited(.king, .spades),
            .suited(.queen, .spades),
            .suited(.jack, .spades),
            .suited(.ten, .spades),
            .suited(.nine, .spades),
            .suited(.eight, .spades),
            .suited(.seven, .spades),
            .suited(.six, .spades),
            .suited(.five, .spades),
            .suited(.four, .spades),
            .suited(.three, .spades),
            .suited(.ace, .spades),
            
            .suited(.king, .clubs),
            .suited(.queen, .clubs),
            .suited(.jack, .clubs),
            .suited(.ten, .clubs),
            .suited(.nine, .clubs),
            .suited(.eight, .clubs),
            .suited(.seven, .clubs),
            .suited(.six, .clubs),
            .suited(.five, .clubs),
            .suited(.four, .clubs),
            .suited(.ace, .clubs),
        
            .suited(.king, .diamonds),
            .suited(.queen, .diamonds),
            .suited(.jack, .diamonds),
            .suited(.ten, .diamonds),
            .suited(.nine, .diamonds),
            .suited(.eight, .diamonds),
            .suited(.seven, .diamonds),
            .suited(.six, .diamonds),
            .suited(.five, .diamonds),
            .suited(.four, .diamonds),
            .suited(.three, .diamonds),
            .suited(.ace, .diamonds),
        
            .suited(.king, .hearts),
            .suited(.queen, .hearts),
            .suited(.jack, .hearts),
            .suited(.ten, .hearts),
            .suited(.nine, .hearts),
            .suited(.eight, .hearts),
            .suited(.seven, .hearts),
            .suited(.six, .hearts),
            .suited(.five, .hearts),
            .suited(.four, .hearts),
            .suited(.three, .hearts),
            .suited(.two, .hearts),
            .suited(.ace, .hearts),
        ])
    }
}
