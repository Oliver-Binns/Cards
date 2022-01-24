import Cards
import Combine
import SwiftUI
import GroupActivities

struct ContentView: View {
    @State private var game: Sevens = .init(players: 1)
    @State private var subscriptions = Set<AnyCancellable>()
    
    @StateObject private var groupStateObserver = GroupStateObserver()
    @State private var session: GroupSession<PlayTogether>?
    
    @State private var sharePlayEnabled: Bool = false
    @State private var participants: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                SevensView(game: $game)
                if sharePlayEnabled {
                    Text("Players: \(participants)")
                }
            }
            
            if groupStateObserver.isEligibleForGroupSession {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            Task {
                                await sharePlayEnabled ?
                                    leaveSharePlay() :
                                    try attemptActivation()
                            }
                        } label: {
                            Image(systemName: sharePlayEnabled ? "shareplay.slash" : "shareplay")
                                .font(.title3)
                        }
                        .buttonStyle(.borderedProminent)
                        .accentColor(sharePlayEnabled ? Color.red : Color.green)
                        Spacer()
                    }.padding()
                }
            }
        }
        .background(Color.green)
        .task {
            await checkForSessions()
        }
    }
    
    private func attemptActivation() async throws {
        let game = Sevens(players: 2)
        let data = try JSONEncoder().encode(game)
        let groupActivity = PlayTogether(title: game.title, data: data)
        if let session = session {
            session.activity = groupActivity
        } else {
            _ = try await groupActivity.activate()
        }
    }
    
    private func checkForSessions() async {
        for await session in PlayTogether.sessions() {
            configureSession(session)
        }
        await checkForSessions()
    }
    
    private func leaveSharePlay() {
        session?.leave()
        session = nil
    }
    
    private func configureSession(_ session: GroupSession<PlayTogether>) {
        session.$state.sink {
            switch $0 {
            case .joined:
                sharePlayEnabled = true
            default:
                sharePlayEnabled = false
            }
        }.store(in: &subscriptions)
        
        session.$activity.sink {
            if let game = try? JSONDecoder().decode(Sevens.self, from: $0.data) {
                self.game = game
            }
        }.store(in: &subscriptions)
        
        session.$activeParticipants.sink {
            participants = $0.count
        }.store(in: &subscriptions)
        
        session.join()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
