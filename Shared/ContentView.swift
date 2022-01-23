import Cards
import Combine
import SwiftUI
import GroupActivities

struct ContentView: View {
    @State private var deck = Deck.full.shuffled()
    @State private var subscriptions = Set<AnyCancellable>()
    
    @StateObject private var groupStateObserver = GroupStateObserver()
    @State private var session: GroupSession<PlayTogether>?
    
    @State private var sharePlayEnabled: Bool = false
    @State private var participants: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                DeckView(deck: $deck)
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
        .task {
            await checkForSessions()
        }
    }
    
    private func attemptActivation() async throws {
        let groupActivity = PlayTogether(title: "Hearts", cards: deck)
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
            self.deck = $0.cards
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
