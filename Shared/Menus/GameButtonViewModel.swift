import Cards

struct GameButtonViewModel {
    let imageName: String
    let name: String
    let playerCount: ClosedRange<Int>
    let startGame: (Int) -> Game
}
extension GameButtonViewModel {
    static var games: [GameButtonViewModel] {
        [
            .init(imageName: "7.square.fill", name: "Sevens", playerCount: 2...7) {
                .sevens(.init(players: $0))
            },
            /*.init(imageName: "heart.square.fill", name: "Hearts", playerCount: 4...4) {
                .sevens(.init(players: $0))
            },
            .init(imageName: "heart.square.fill", name: "Go Fish", playerCount: 2...5) {
                .goFish(.init(players: $0))
            }*/
        ]
    }
}
