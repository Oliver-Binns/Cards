import CardsModel
import Combine
import Sevens
import SwiftUI

struct SevensView: View {
    @EnvironmentObject var model: ViewModel
    @ObservedObject var game: Sevens
    
    let playerIndex: Int?
    let didPlay: (PlayingCard?) -> Void
    
    @Namespace private var namespace
    
    @State private var displayHelp: Bool = false
    @Environment(\.openImmersiveSpace) private var openSpace
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                SevensTableView(table: game.table, namespace: namespace)
                    .layoutPriority(0.1)
                    .readableGuidePadding()
                
                #if !os(visionOS)
                if let playerIndex {
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
                #endif
            }
            
            if let winner = game.winner {
                if winner == model.playerIndex {
                    WinnerView()
                } else {
                    LoserView()
                }
            }
        }
        .navigationTitle("Sevens")
        .inlineNavigationTitle()
        .toolbar {
            Button {
                displayHelp = true
            } label: {
                Image(systemName: "questionmark.circle.fill")
            }
        }
        .sheet(isPresented: $displayHelp) {
            SevensGuide()
        }
        #if os(visionOS)
        .onAppear {
            guard playerIndex != nil else { return }
            openWindow(id: "hand-view")
            
            Task {
                await openSpace(id: "immersive-space")
            }
        }
        #endif
    }
}
