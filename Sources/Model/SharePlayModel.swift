import CardsModel
import Combine
import GroupActivities

protocol SharePlayModelDelegate: AnyObject {
    func resumeGame(moves: [PlayingCard?])
}

final class SharePlayModel: ObservableObject {
    private let groupStateObserver = GroupStateObserver()
    
    @Published private(set) var session: GroupSession<PlayTogether>? = nil {
        didSet {
            if let session {
                session.join()
                messenger = GroupSessionMessenger(session: session)
                catchUpUsers()
            } else {
                messenger = nil
            }
        }
    }
    
    private var messenger: GroupSessionMessenger? = nil {
        didSet {
            Task {
                await catchUp()
            }
        }
    }
    
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
    
    /// Keeps track of the moves played in this game, so that late joiners can be caught up
    private var moves: [PlayingCard?] = []
    private var cancellables: Set<AnyCancellable> = []
    
    var delegate: SharePlayModelDelegate?
    
    init() {
        Task {
            await findSessions()
        }
    }
    
    func findSessions() async {
        for await session in PlayTogether.sessions() {
            await MainActor.run { self.session = session }
        }
    }
    
    func didPlayMove(_ move: PlayingCard?, locally: Bool) async throws {
        if locally {
            try await sendMove(move)
        }
        moves.append(move)
    }
    
    func startGame() {
        moves = []
    }
    
    private func catchUp() async {
        guard let messenger else { return }
        for await (message, _) in messenger
            .messages(of: [PlayingCard?].self) {
            moves = message
            
            await MainActor.run {
                delegate?.resumeGame(moves: moves)
            }
        }
    }
    
    /// Send a new move to users
    private func sendMove(_ card: PlayingCard?) async throws {
        try await messenger?.send(card)
    }
    
    /// Catch up remote users who join late so they can watch or rejoin the game
    private func catchUpUsers() {
        guard let session else { return }
        
        session.$activeParticipants
            .sink { activeParticipants in
                let newParticipants = activeParticipants.subtracting(session.activeParticipants)
                Task {
                    try await self.messenger?.send(self.moves, to: .only(newParticipants))
                }
            }
            .store(in: &cancellables)
    }
}
