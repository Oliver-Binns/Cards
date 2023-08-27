import CardsModel
import Combine
import GroupActivities
import Sevens
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var error: Error?
    @Published var game: (any Game)?
    
    private var tasks: [Task<(), Never>] = []
    @Published private(set) var players: [NonLocalPlayer] = [] {
        didSet {
            tasks.forEach { $0.cancel() }
            tasks = players.map { player in
                Task {
                    await followPlayer(player)
                }
            }
        }
    }
    
    var playerIndex: Int? {
        guard let session = sharePlay.session else {
            return 0
        }
        let localID = session.localParticipant.id
        return session.activity.participantOrder.firstIndex(of: localID)
    }
    
    @ObservedObject
    var sharePlay = SharePlayModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        sharePlay.$session
            .receive(on: RunLoop.main)
            .map(\.?.activity.game)
            .assign(to: \.game, on: self)
            .store(in: &cancellables)

        sharePlay.$session
            .sink { session in
                guard let session else { return }
                session.$activity.sink(receiveValue: { activity in
                    self.players = activity.participantOrder.map {
                        RemotePlayer(id: $0, session: session)
                    }
                })
                .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func setPlayers(_ players: [NonLocalPlayer], of game: any Game) {
        self.players = players
        self.game = game
    }
    
    func playCard(_ card: PlayingCard?) {
        game?.play(card: card)
        
        Task {
            do {
                try await sharePlay.sendMove(card)
            } catch {
                self.error = error
            }
        }
    }
    
    func followPlayer(_ player: NonLocalPlayer) async {
        for await move in player.moves {
            try? await Task.sleep(for: .seconds(0.7))
            await MainActor.run {
                withAnimation {
                    self.game?.play(card: move)
                }
            }
        }
    }
}

final class SharePlayModel: ObservableObject {
    private let groupStateObserver = GroupStateObserver()
    
    @Published private(set) var session: GroupSession<PlayTogether>? = nil
    private var messenger: GroupSessionMessenger? = nil
    
    /// A SharePlay connection exists:
    /// this is either an active FaceTime call or iMessage SharePlay session
    ///
    /// if true, we can directly activate a shared activity
    /// if false, we must state a connection using `GroupActivitySharingController`
    var activeConnectionExists: Bool {
        groupStateObserver.isEligibleForGroupSession
    }
    
    /// Whether `GroupActivitySharingController` is available on the current platform
    ///
    /// If this API is available, then we can allow the user to open a new SharePlay session within the app
    var canOpenConnection: Bool {
        guard #available(iOS 15.4, macOS 13, *) else {
            return false
        }
        #if os(macOS) && swift(<5.9)
        return false
        #else
        return true
        #endif
    }
    
    init() {
        Task {
            await findSessions()
        }
    }
    
    func findSessions() async {
        for await session in PlayTogether.sessions() {
            await MainActor.run {
                // todo: when should activity be joined?
                session.join()
                
                self.session = session
                self.messenger = GroupSessionMessenger(session: session)
            }
        }
    }
    
    func sendMove(_ card: PlayingCard?) async throws {
        try await messenger?.send(card)
    }
}
