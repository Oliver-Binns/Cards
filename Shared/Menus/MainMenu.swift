import Combine
import SwiftUI
import GroupActivities

struct MainMenu: View {
    @StateObject private var groupStateObserver = GroupStateObserver()
    @State private var session: GroupSession<PlayTogether>?
    
    @State private var state: GroupSession<PlayTogether>.State?
    
    @State private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Card Play")
                .font(.largeTitle)
                .fontWeight(.semibold)
                
                Spacer()
                
                
                NavigationLink("Play Solo") {
                    SoloGame()
                }
                .buttonStyle(.borderedProminent)
                .accentColor(.blue)
                .padding(.bottom)
                
                Text("joined: \((state == .joined).description)")
                Text("waiting: \((state == .waiting).description)")
                
                if groupStateObserver.isEligibleForGroupSession {
                    if state == .joined {
                        NavigationLink("Play with Friends",
                                       isActive: .constant(true)) {
                            Lobby(session: $session)
                        }
                    } else {
                        Button("Play with Friends") {
                            Task {
                                try await startSession()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .accentColor(.blue)
                    }
                } else {
                    Text("Join a FaceTime call to play with friends")
                    .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.green)
        }
        .accentColor(.primary)
        .task {
            await checkForSession()
        }
    }
    
    private func checkForSession() async {
        for await session in PlayTogether.sessions() {
            self.session = session
            configureSession(session)
        }
    }
    
    private func configureSession(_ session: GroupSession<PlayTogether>) {
        session.$state.sink { state in
            self.state = state
        }.store(in: &cancellables)
        
        session.join()
    }
    
    private func startSession() async throws {
        let groupActivity = PlayTogether(title: "Card Play")
        _ = try await groupActivity.activate()
    }
}
