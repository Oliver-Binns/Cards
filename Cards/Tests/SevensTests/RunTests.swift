import CardsModel
@testable import Sevens
import XCTest

final class RunTests: XCTestCase {
    func testCanInitiallyAddSeven() {
        XCTAssertTrue(Sevens.Run().canAddCard(card: .seven))
    }
    
    func testCannotAddOtherCardsInitially() {
        SuitedCard.allCases.filter { $0 != .seven }.forEach {
            XCTAssertFalse(Sevens.Run().canAddCard(card: $0))
        }
    }
    
    func testCanAddCardsInOrder() {
        var run = Sevens.Run()
        run.add(card: .seven)
        
        XCTAssertTrue(run.canAddCard(card: .eight))
        XCTAssertTrue(run.canAddCard(card: .six))
        
        SuitedCard.allCases
            .filter { $0 != .six }
            .filter { $0 != .seven }
            .filter { $0 != .eight }
            .forEach {
                XCTAssertFalse(run.canAddCard(card: $0))
            }
    }
}

