import CardsModel
import Combine
import SwiftUI

public final class RandomAutomatedPlayer: NonLocalPlayer {
    public let id = UUID()
    
    private let index: Int
    @ObservedObject private var game: Sevens
    private var cancellables: Set<AnyCancellable> = []
    
    public var moves: AsyncStream<PlayingCard?> {
        AsyncStream { stream in
            game
                .currentPlayerPublisher
                .filter {
                    $0 == self.index
                }.map {
                    self.game
                        .hand(forPlayer: $0)
                        .filter(\.isValid)
                        .map(\.card)
                }.map {
                    $0.randomElement()
                }.sink { card in
                    stream.yield(card)
                }.store(in: &cancellables)
        }
    }
    
    public init(index: Int,
                game: Sevens) {
        self.index = index
        self.game = game
        
    }
}
