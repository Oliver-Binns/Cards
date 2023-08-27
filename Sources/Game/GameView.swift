import CardsModel
import SwiftUI

struct GameView: View {
    @Binding var game: any Game
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        VStack {
            if model.players.count < game.players,
               let session = model.sharePlay.session {
                // we don't have enough players for the current game!
                LobbyView(game: $game, session: session)
            } else {
                // required play count reached...
                TableView(game: $game)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dynamicGreen)
    }
}
