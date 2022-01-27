import Cards
import Combine
import GroupActivities
import SwiftUI

struct Lobby: View {
    @Binding var session: GroupSession<PlayTogether>?
    
    @State var game: Game?
    @State private var participants: Set<Participant>? = nil
    @State private var cancellables: Set<AnyCancellable> = []
    
    @State var name: String = ""
    
    var body: some View {
        VStack {
            Text("Lobby")
            .font(.largeTitle)
            .fontWeight(.semibold)
            
            if let playerCount = session?.activeParticipants.count {
                Text("\(playerCount) Players")
            }
            
            TextField("Your Name", text: $name)
                .padding()
            
            Spacer()
            
            Button("Play Sevens") {
                guard let playerCount = session?.activeParticipants.count,
                      let players = session?.activeParticipants.map({ $0.id }) else { return }
                session?.activity = .init(title: "Sevens",
                                         game: .sevens(.init(players: playerCount)),
                                         players: players)
                print("setting activity")
            }

            if let game = game,
               let players = session?.activity.players,
               let playerID = session?.localParticipant.id,
               let playerIndex = players.firstIndex(of: playerID) {
                NavigationLink(isActive: .init(get: { game != nil },
                                               set: { _ in session?.activity.game = nil }),
                               destination: { GameView(game: .init(get: { game },
                                                                 set: { session?.activity.game = $0 }),
                                                       playerIndex: playerIndex) }) { }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.green)
        .onAppear {
            configureSession()
        }
    }
    
    private func configureSession() {
        // todo enable messaging?
        //for await message in messenger.messages(of: Type.self) {
        //    self.receiveMessage(message)
        //}
        
        /*session.$activeParticipants.sink {
            self.participants = $0
        }.store(in: &cancellables)*/
        
        session?.$activity.sink {
            print("updated activity", $0)
            self.game = $0.game
        }.store(in: &cancellables)
    }
    
    private func receiveMessage() {
        
    }
}