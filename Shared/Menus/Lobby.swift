import Combine
import GroupActivities
import SwiftUI

struct Lobby: View {
    @ObservedObject var session: GroupSession<PlayTogether>
    @State var messenger: GroupSessionMessenger?
    
    @State private var cancellables: Set<AnyCancellable> = []

    @State var winner: Int? = nil
    @State var alertText: String?
    
    let games = GameButtonViewModel.games
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lobby")
            .font(.largeTitle)
            .fontWeight(.semibold)
            
            Text("\(session.activeParticipants.count) Players")
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Name").font(.caption2)
                TextField("Rosie 🌹", text: .init(get: {
                    let uuid = session.localParticipant.id
                    return session.activity.names[uuid, default: ""]
                }, set: {
                    guard !$0.isEmpty else { return }
                    let uuid = session.localParticipant.id
                    session.activity.names[uuid] = $0
                }))
                .textContentType(.givenName)
            }
            .padding()
            .background(.background)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            Spacer()
            
            LazyVGrid(columns: [.init(), .init()]) {
                Section {
                    ForEach(games) { game in
                        GameButton(imageName: game.imageName,
                                   name: game.name,
                                   players: game.playerCount) {
                            startGame(model: game)
                        }.disabled(!game.playerCount.contains(session.activeParticipants.count))
                    }
                }
            }
            

            if let players = session.activity.players,
               let playerIndex = players.firstIndex(of: session.localParticipant.id) {
                NavigationLink(isActive: .init(get: { session.activity.game != nil },
                                               set: { _ in session.activity.game = nil })) {
                    GameView(game: .init(get: {
                        session.activity.game
                    }, set: {
                        session.activity.game = $0
                    }), playerIndex: playerIndex) { winner in
                        announceWinner(winner)
                    }
                } label: { EmptyView() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.dynamicGreen)
        .overlay {
            VStack {
                if let winner = winner,
                   let players = session.activity.players,
                   let currentPlayer = players.firstIndex(of: session.localParticipant.id) {
                    
                    if currentPlayer == winner {
                        WinnerView()
                    } else if let winningPlayerID = session.activity.players?[winner],
                              let winningPlayerName = session.activity.names[winningPlayerID] {
                        LoserView(winnerName: winningPlayerName)
                    }
                } else {
                    EmptyView()
                }
            }.onTapGesture {
                withAnimation {
                    self.winner = nil
                }
            }
        }
        .onAppear { Task { await getMessages() } }
        .alert("Oh no!",
               isPresented: .init { alertText != nil } set: { _ in alertText = nil }) {
            Text("Ok")
        } message: { Text(alertText ?? "") }
    }
    
    private func startGame(model: GameButtonViewModel) {
        let playerCount = session.activeParticipants.count
        let playerIDs = session.activeParticipants.map(\.id)
        let playerNames = session.activity.names
        guard playerIDs.allSatisfy(playerNames.keys.contains) else {
            alertText = "All players must have entered a name to continue"
            return
        }
        session.activity = .init(title: model.name,
                                 game: model.startGame(playerCount),
                                 players: playerIDs,
                                 names: playerNames)
        
    }
    
    private func announceWinner(_ winner: Int) {
        self.winner = winner
        messenger?.send(winner) {
            if let error = $0 {
                print(error)
            }
        }
    }
    
    private func getMessages() async {
        messenger = GroupSessionMessenger(session: session)
        for await message in messenger!.messages(of: Int.self) {
            self.winner = message.0
        }
    }
}

