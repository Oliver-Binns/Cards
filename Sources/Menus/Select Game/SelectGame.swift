import CardsModel
import Sevens
import SwiftUI
import GroupActivities

struct SelectGame: View {
    @EnvironmentObject var model: ViewModel
    
    @State private var gameType: (any Game.Type) = Sevens.self
    @State private var startNoActiveSession: Bool = false
    @State private var presentSharePlayDialog: Bool = false
    
    @State private var playerCount: Int = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Setup a Game")
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Section {
                Text("Select game:")
                
                Picker(selection: $playerCount) {
                    Label("Sevens", systemImage: "7.circle.fill")
                    // Extra games coming soon:
                    // Label("Hearts", systemImage: "heart.circle.fill")
                    // Label("Go Fish", systemImage: "fish.circle.fill")
                } label: {
                    Text("Game type")
                }.pickerStyle(.segmented)
            }
            
            Section {
                Text("Number of players:")
                
                Picker(selection: $playerCount) {
                    // player range:
                    // sevens:  2...7
                    // hearts:  3...6
                    // go fish: 2...5
                    ForEach(2..<8) {
                        Text($0.description).tag($0)
                    }
                } label: {
                    Text("Number of players")
                }.pickerStyle(.segmented)
            }

            Button {
                Task {
                    await startGame()
                }
            } label: {
                Label("Deal", systemImage: "suit.club.fill")
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accentColor(.blue)
            
        }
        .padding()
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 4)
        .confirmationDialog("Play Sevens", isPresented: $startNoActiveSession) {
            Button("Play Locally") {
                startLocalGame()
            }
            
            Button("Start SharePlay") {
                presentSharePlayDialog = true
            }
        }
        .sheet(isPresented: $presentSharePlayDialog) {
            GroupActivityView {
                activity()
            }
        }
    }
    
    func startGame() async {
        if model.sharePlay.activeConnectionExists {
            // An active connection exists, we can request activation of a shared activity
            
            let activity = activity()
            let result = await activity.prepareForActivation()
            
            switch result {
            case .activationPreferred:
                do {
                    _ = try await activity.activate()
                } catch {
                    model.error = error
                }
            case .activationDisabled:
                startLocalGame()
            default: break
            }
        } else if model.sharePlay.canOpenConnection {
            // no active connection, we can create one
            startNoActiveSession = true
        } else {
            // cannot create a connection as `GroupActivitySharingController`
            // is not available on this platform
            startLocalGame()
        }
    }
    
    private func startLocalGame() {
        let game = gameType.init(players: playerCount)
        model.game = game
        model.setPlayers((1..<playerCount).map(game.autoPlayer(index:)),
                         of: game)
    }
    
    private func activity() -> PlayTogether {
        let game = gameType.init(players: playerCount)
        return PlayTogether(game: game)
    }
}
