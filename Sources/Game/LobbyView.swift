import CardsModel
import GroupActivities
import SwiftUI

struct LobbyView: View {
    @Binding var game: any Game
    @ObservedObject var session: GroupSession<PlayTogether>
    @EnvironmentObject var model: ViewModel
    
    var atTable: Bool {
        let localID = session.localParticipant.id
        return session.activity.participantOrder.contains(localID)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lobby 🃏")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.semibold)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 16) {
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    Image(systemName: "person.line.dotted.person.fill")
                        .symbolEffect(.pulse, isActive: true)
                        .font(.title)
                }
                
                Text("Waiting for players to join...")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Text("There are currently \(model.players.count) players at the table.")
                Text("\(game.players) players are required to start.")
                
                Button(action: joinTable) {
                    if atTable {
                        Label("Leave Table", systemImage: "arrow.up.right.square.fill")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                    } else {
                        Label("Sit Down", systemImage: "arrow.down.right.square.fill")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .accentColor(.blue)
            }
            .padding()
            .background(.background)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            Spacer()
        }
        .readableGuidePadding()
        .padding()
    }
    
    func joinTable() {
        // check if participants already contains self:
        let localID = session.localParticipant.id
        if let index = session.activity.participantOrder
            .firstIndex(of: localID) {
            session.activity.participantOrder.remove(at: index)
        } else {
            session.activity.participantOrder.append(localID)
        }
    }
}
