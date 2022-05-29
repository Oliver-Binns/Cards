import Combine
import GroupActivities
import SwiftUI

struct PlayTogetherView: View {
    @StateObject private var groupStateObserver = GroupStateObserver()
    
    @State private var session: GroupSession<PlayTogether>?
    @State private var state: GroupSession<PlayTogether>.State?
    @State private var cancellables: Set<AnyCancellable> = []
    
    @available(iOS 15.4, *)
    @State private var startActivity: GroupActivityView<PlayTogether>?
    
    private var canStartSharePlay: Bool {
        guard #available(iOS 15.4, *) else {
            return groupStateObserver.isEligibleForGroupSession
        }
        return true
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Deal ♠️ is best enjoyed with friends.")
                .frame(maxWidth: .infinity)
            
            if groupStateObserver.isEligibleForGroupSession {
                if let session = session,
                   state == .joined {
                    NavigationLink("Play with Friends",
                                   isActive: .init(get: { state == .joined },
                                                   set: { _ in session.end() })) {
                        Lobby(session: session)
                    }
                }
            } else if #unavailable(iOS 15.4) {
                HStack {
                    Image(systemName: "video.fill")
                    Text("Join a FaceTime call to activate SharePlay!")
                }
            }
            
            Button(action: startSharePlay) {
                HStack {
                    Image(systemName: "shareplay")
                    Text("Start SharePlay")
                }
                .padding(8)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .disabled(!canStartSharePlay)
        }
        .padding()
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 4)
        .sheet(item: $startActivity, content: { $0 })
        .task {
            await checkForSession()
        }
    }
    
    private func startSharePlay() {
        if #available(iOS 15.4, *) {
            startActivity = GroupActivityView {  () -> PlayTogether in
                PlayTogether(title: "Lobby")
            }
        } else {
            Task {
                try await startSession()
            }
        }
    }
    
    private func checkForSession() async {
        for await session in PlayTogether.sessions() {
            configureSession(session)
        }
    }
    
    @MainActor
    private func configureSession(_ session: GroupSession<PlayTogether>) {
        self.session = session
        
        session.$state.sink { state in
            self.state = state
        }.store(in: &cancellables)
        
        session.join()
    }
    
    private func startSession() async throws {
        let groupActivity = PlayTogether(title: "Deal ♠️")
        _ = try await groupActivity.activate()
    }
    
    
}
