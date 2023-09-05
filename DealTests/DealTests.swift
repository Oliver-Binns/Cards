@testable import Deal
import Sevens
import XCTest

final class PlayTogetherTests: XCTestCase {
    var sut: PlayTogether!
    
    override func setUp() {
        super.setUp()
        
        let game = Sevens(players: 1)
        sut = PlayTogether(game: game)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension PlayTogetherTests {
    func testMetadata() {
        XCTAssertEqual(sut.metadata.title, "Sevens")
        XCTAssertEqual(sut.metadata.type, .generic)
        XCTAssertEqual(sut.metadata.subtitle, "Let’s Play! 🃏")
        XCTAssertNil(sut.metadata.previewImage)
        XCTAssertNil(sut.metadata.fallbackURL)
    }
}
