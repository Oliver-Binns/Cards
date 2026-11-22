import Combine
import GroupActivities
import SwiftUI

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
            let canPlayTogether = canStartSharePlay || isOnFaceTimeCall

            Button(action: startSharePlay) {
                HStack {
                    Image(systemName: "shareplay")
                    Text("Start SharePlay")
                }
                .padding(8)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canPlayTogether)

            Text(
                canPlayTogether ?
                    "FaceCards is best enjoyed with friends":
                    "Join a FaceTime call to activate SharePlay"
            )
            .frame(maxWidth: .infinity)
            .font(.body.weight(.semibold))
            .italic()
            .foregroundStyle(Color(.accent))
            .padding(.horizontal)
        }
        .sheet(item: $startActivity, content: { $0 })
        .task {
            await checkForSession()
        }
        .navigationDestination(isPresented: isShowingSession) {
            if let session {
                switch session.state {
                case .joined, .waiting:
                    Lobby(session: session)
                case .invalidated:
                    GenericError()
                @unknown default:
                    GenericError()
                }
            }
        }
    }

    private var isShowingSession: Binding<Bool> {
        Binding(
            get: { session != nil },
            set: { isPresented in
                if !isPresented { session = nil }
            }
        )
    }
    
    private func startSharePlay() {
        guard isOnFaceTimeCall else {
            startActivity = GroupActivityView { PlayTogether(title: "FaceCards 🃏") }
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
        let groupActivity = PlayTogether(title: "FaceCards 🃏")
        _ = try await groupActivity.activate()
    }
}
