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
            VStack(spacing: 16) {
                Text("Card Play")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    NavigationLink {
                        SoloGame()
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text("Play Solo")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(.blue)
                }
                .padding()
                .background(.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                
                
                VStack(spacing: 8) {
                    Text("Card Play is best enjoyed with friends.")
                        .frame(maxWidth: .infinity)
                    
                    if groupStateObserver.isEligibleForGroupSession {
                        if state == .joined {
                            NavigationLink("Play with Friends",
                                           isActive: .init(get: { state == .joined },
                                                           set: { _ in session?.end() })) {
                                Lobby(session: $session)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "video.fill")
                            Text("Join a FaceTime call to activate SharePlay!")
                        }
                    }
                    
                    Button {
                        Task {
                            try await startSession()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "shareplay")
                            Text("Start SharePlay")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(!groupStateObserver.isEligibleForGroupSession)
                }
                .padding()
                .background(.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                
                Spacer()
            }
            .padding()
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
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
