import CardsModel
import Combine
import Sevens
import SwiftUI

struct GameView: View {
    @Binding var game: Game?
    
    let playerIndex: Int
    private(set) var computerPlayer: ((Hand) -> PlayingCard?)? = nil
    let didWin: ((Int) -> Void)
    
    @State private(set) var timer: Timer?
    @State private var sevens: Sevens?
    
    var body: some View {
        VStack {
            switch game {
            case .sevens(let sevens):
                SevensView(game: sevens, playerIndex: playerIndex) { card in
                    sevens.play(card: card)
                    sevens.objectWillChange.send()
                    
                    if let winner = sevens.winner {
                        didWin(winner)
                    } else {
                        game = .sevens(sevens)
                    }
                }
            default:
                VStack { }
            }
        }
        .background(Color.dynamicGreen)
        .onAppear {
            setupTimer()
        }
    }
    
    func setupTimer() {
        guard let computerPlayer = computerPlayer else { return }
        
        timer?.invalidate()
        timer = .scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
            switch game {
            case .sevens(let sevens):
                makeMove(sevens: sevens, asPlayer: computerPlayer)
            default:
                break
            }
            
        }
    }
    
    func makeMove(sevens: Sevens, asPlayer computerPlayer: (Hand) -> PlayingCard?) {
        if sevens.currentPlayer != playerIndex {
            let hand = sevens.hand(forPlayer: sevens.currentPlayer)
            withAnimation {
                sevens.play(card: computerPlayer(hand))
                
                if let winner = sevens.winner {
                    didWin(winner)
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(.sevens(.init(players: 2))),
                 playerIndex: 0) { _ in }
    }
}
