import CardsModel
import Combine
import Sevens
import SwiftUI

struct InputMenu: View {
    @EnvironmentObject private var model: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let game = model.game as? Sevens,
           let playerIndex = model.playerIndex {
            InputView(game: game, playerIndex: playerIndex)
                .onReceive(model.$game) { game in
                    if game?.winner != nil {
                        dismiss()
                    }
                }
        }
    }
}

struct InputView: View {
    @Namespace private var namespace
    @ObservedObject var game: Sevens
    
    let playerIndex: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HandView(hand: game.hand(forPlayer: playerIndex),
                     isDisabled: game.currentPlayer != playerIndex,
                     namespace: namespace) { card in
                game.play(card: card)
            }
            
            if game.currentPlayer != playerIndex {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Waiting for your turn")
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.background)
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding()
                .transition(.move(edge: .bottom))
            }
        }
    }
}
