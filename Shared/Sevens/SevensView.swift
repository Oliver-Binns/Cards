import Cards
import Combine
import SwiftUI

struct SevensView: View {
    @ObservedObject var game: Sevens
    
    let playerIndex: Int
    let didPlay: (PlayingCard?) -> Void
    
    @Namespace private var namespace
    
    var body: some View {
        Self._printChanges()
        return ZStack {
            GeometryReader { geo in
                SevensTableView(table: game.table, namespace: namespace)
                    .layoutPriority(0.1)
                
                VStack {
                    Spacer()
                    ZStack(alignment: .bottom) {
                        HandView(hand: game.hand(forPlayer: playerIndex),
                                 isDisabled: game.currentPlayer != playerIndex,
                                 namespace: namespace) { card in
                            didPlay(card)
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
                    }.frame(maxHeight: geo.size.height * 0.7)
                }
            }
        }
        .navigationTitle("Sevens")
        .navigationBarTitleDisplayMode(.inline)
    }
}
