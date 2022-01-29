import Cards
import SwiftUI

struct GameView: View {
    @Binding var game: Game
    let playerIndex: Int
    let didWin: ((Int) -> Void)
    
    var body: some View {
        VStack {
            switch game {
            case .sevens(var sevens):
                SevensView(game: sevens, playerIndex: playerIndex) { card in
                    sevens.play(card: card)
                    
                    if let winner = sevens.winner {
                        didWin(winner)
                    } else {
                        game = .sevens(sevens)
                    }
                    // todo send card between devices!
                    //sessionMessenger?.send(card) {
                    //    print("error?:", $0)
                    //}
                }
            }
            
        }
        .background(Color.green)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(.sevens(.init(players: 2))),
                 playerIndex: 0) { _ in }
    }
}
