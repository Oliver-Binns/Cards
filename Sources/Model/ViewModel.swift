import CardsModel
import Combine
import Sevens
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var error: Error?
    @Published var game: (any Game)? {
        didSet {
            sharePlay.startGame()
        }
    }
    
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
        sharePlay.delegate = self
        
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
        Task {
            try await playMove(card, locally: true)
        }
    }
    
    func followPlayer(_ player: NonLocalPlayer) async {
        for await move in player.moves {
            try? await Task.sleep(for: .seconds(0.7))
            try? await playMove(move, locally: false)
        }
    }
    
    func playMove(_ move: PlayingCard?, locally: Bool) async throws {
        do {
            try await sharePlay.didPlayMove(move, locally: locally)
            await MainActor.run {
                withAnimation {
                    game?.play(card: move)
                }
            }
        } catch {
            self.error = error
        }
    }
}

extension ViewModel: SharePlayModelDelegate {
    func resumeGame(moves: [CardsModel.PlayingCard?]) {
        moves.forEach { game?.play(card: $0) }
    }
}
