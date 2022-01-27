struct TurnState: Codable, Equatable {
    private let playerCount: Int
    private(set) var currentPlayer: Int
    
    init(playerCount: Int, startPlayer: Int = 0) {
        guard playerCount > 0 else {
            preconditionFailure("Player count should be greater than zero")
        }
        self.playerCount = playerCount
        self.currentPlayer = startPlayer
    }
    
    mutating func next() {
        currentPlayer += 1
        if currentPlayer == playerCount {
            currentPlayer = 0
        }
    }
}
