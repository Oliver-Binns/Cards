struct TurnState {
    private let playerCount: Int
    private(set) var currentPlayer: Int = 0
    
    init(playerCount: Int) {
        guard playerCount > 0 else {
            preconditionFailure("Player count should be greater than zero")
        }
        self.playerCount = playerCount
    }
    
    mutating func next() {
        currentPlayer += 1
        if currentPlayer == playerCount {
            currentPlayer = 0
        }
    }
}
