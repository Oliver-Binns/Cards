import Cards
import Combine
import GroupActivities
import SwiftUI

struct Lobby: View {
    @Binding var session: GroupSession<PlayTogether>?
    
    @State var activity: PlayTogether?
    
    var game: Game? {
        activity?.game
    }
    
    @State private var participants: Set<Participant>? = nil
    @State private var cancellables: Set<AnyCancellable> = []
    
    @FocusState private var nameIsFocussed: Bool

    @State var alertText: String?
    @State var winner: Int?
    
    let games = GameButtonViewModel.games
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lobby")
            .font(.largeTitle)
            .fontWeight(.semibold)
            
            if let playerCount = participants?.count {
                Text("\(playerCount) Players")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Name").font(.caption2)
                TextField("Holleigh", text: .init(get: {
                    guard let uuid = session?.localParticipant.id,
                        let name = session?.activity.names[uuid] else { return "" }
                    return name
                }, set: {
                    guard let uuid = session?.localParticipant.id,
                          !$0.isEmpty else { return }
                    session?.activity.names[uuid] = $0
                }))
                .textContentType(.givenName)
                .focused($nameIsFocussed)
            }
            .padding()
            .background(.background)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            Spacer()
            
            LazyVGrid(columns: [.init(), .init()]) {
                Section {
                    ForEach(0..<games.count) { index in
                        GameButton(imageName: games[index].imageName,
                                   name: games[index].name,
                                   players: games[index].playerCount) {
                            startGame(model: games[index])
                        }.disabled(!games[index].playerCount.contains(participants?.count ?? 0))
                    }
                }
            }
            

            if let game = game,
               let players = session?.activity.players,
               let playerID = session?.localParticipant.id,
               let playerIndex = players.firstIndex(of: playerID) {
                NavigationLink(isActive: .init(get: { activity?.game != nil },
                                               set: { _ in session?.activity.game = nil })) {
                    
                    GameView(game: .init(get: { game },
                                         set: { session?.activity.game = $0 }),
                             playerIndex: playerIndex) { winner in
                        session?.activity.game = nil
                        activity?.game = nil
                        if let winningPlayerID = session?.activity.players?[winner],
                           let winningPlayerName = session?.activity.names[winningPlayerID] {
                            alertText = "\(winningPlayerName) wins!"
                        }
                    }
                } label: { EmptyView() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.green)
        .onAppear {
            configureSession()
        }
        .alert("Oh no!",
               isPresented: .init { alertText != nil } set: { _ in alertText = nil }) {
            Text("Ok")
        } message: { Text(alertText ?? "") }
    }
    
    private func startGame(model: GameButtonViewModel) {
        guard let playerCount = participants?.count,
              let playerIDs = participants?.map({ $0.id }),
              let playerNames = session?.activity.names else {
            return
        }
        guard playerIDs.allSatisfy(playerNames.keys.contains) else {
            alertText = "All players must have entered a name to continue"
            return
        }
        session?.activity = .init(title: model.name, game: model.startGame(playerCount), players: playerIDs, names: playerNames)
        
    }
    
    private func configureSession() {
        session?.$activeParticipants.sink {
            self.participants = $0
        }.store(in: &cancellables)
        
        session?.$activity.sink {
            self.activity = $0
        }.store(in: &cancellables)
    }
}

