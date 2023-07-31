import Combine
import GroupActivities
import SwiftUI
import SwiftUINavigation

struct PlayTogetherView: View {
    @StateObject private var groupStateObserver = GroupStateObserver()
    
    @State private var session: GroupSession<PlayTogether>?
    @State private var cancellables: Set<AnyCancellable> = []

    @State private var startActivity: GroupActivityView<PlayTogether>?
    
    private var canStartSharePlay: Bool {
        guard #available(iOS 15.4, macOS 13, *) else {
            return false
        }
        #if os(macOS) && swift(<5.9)
        return false
        #else
        return true
        #endif
        
    }
    
    private var isOnFaceTimeCall: Bool {
        groupStateObserver.isEligibleForGroupSession
    }
    
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Face Cards 🃏 is best enjoyed with friends.")
                .frame(maxWidth: .infinity)
            
            if canStartSharePlay || isOnFaceTimeCall {
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
            } else {
                HStack {
                    Image(systemName: "video.fill")
                    Text("Join a FaceTime call to activate SharePlay!")
                }
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 4)
        .sheet(item: $startActivity, content: { $0 })
        .task {
            await checkForSession()
        }
        .navigationDestination(unwrapping: $session) { session in
            switch session.wrappedValue.state {
            case .joined, .waiting:
                Lobby(session: session.wrappedValue)
            case .invalidated:
                GenericError()
            @unknown default:
                GenericError()
            }
        }
    }
    
    private func startSharePlay() {
        guard isOnFaceTimeCall else {
            startActivity = GroupActivityView { PlayTogether(title: "Face Cards 🃏") }
            return
        }
        Task {
            try await startSession()
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
        session.join()
    }
    
    private func startSession() async throws {
        let groupActivity = PlayTogether(title: "Face Cards 🃏")
        _ = try await groupActivity.activate()
    }
}
