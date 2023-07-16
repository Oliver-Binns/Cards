import CardsModel
@testable import CardsScoring
import XCTest

final class AcesLowTrumpCheckerTests: XCTestCase {
    func testAce() {
        let checker = AcesLowTrumpChecker()
        XCTAssertEqual(checker.compare(.ace, .ace), .equal)
        XCTAssertEqual(checker.compare(.ace, .two), .lower(1))
        XCTAssertEqual(checker.compare(.ace, .three), .lower(2))
        XCTAssertEqual(checker.compare(.ace, .four), .lower(3))
        XCTAssertEqual(checker.compare(.ace, .five), .lower(4))
        XCTAssertEqual(checker.compare(.ace, .six), .lower(5))
        XCTAssertEqual(checker.compare(.ace, .seven), .lower(6))
        XCTAssertEqual(checker.compare(.ace, .eight), .lower(7))
        XCTAssertEqual(checker.compare(.ace, .nine), .lower(8))
        XCTAssertEqual(checker.compare(.ace, .ten), .lower(9))
        XCTAssertEqual(checker.compare(.ace, .jack), .lower(10))
        XCTAssertEqual(checker.compare(.ace, .queen), .lower(11))
        XCTAssertEqual(checker.compare(.ace, .king), .lower(12))
    }
    
    func testSeven() {
        let checker = AcesLowTrumpChecker()
        XCTAssertEqual(checker.compare(.seven, .ace), .higher(6))
        XCTAssertEqual(checker.compare(.seven, .two), .higher(5))
        XCTAssertEqual(checker.compare(.seven, .three), .higher(4))
        XCTAssertEqual(checker.compare(.seven, .four), .higher(3))
        XCTAssertEqual(checker.compare(.seven, .five), .higher(2))
        XCTAssertEqual(checker.compare(.seven, .six), .higher(1))
        XCTAssertEqual(checker.compare(.seven, .seven), .equal)
        XCTAssertEqual(checker.compare(.seven, .eight), .lower(1))
        XCTAssertEqual(checker.compare(.seven, .nine), .lower(2))
        XCTAssertEqual(checker.compare(.seven, .ten), .lower(3))
        XCTAssertEqual(checker.compare(.seven, .jack), .lower(4))
        XCTAssertEqual(checker.compare(.seven, .queen), .lower(5))
        XCTAssertEqual(checker.compare(.seven, .king), .lower(6))
    }
}
