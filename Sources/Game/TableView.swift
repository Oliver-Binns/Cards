import CardsModel
import Sevens
import SwiftUI

struct TableView: View {
    @Binding var game: any Game
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        switch game {
        case let game as Sevens:
            SevensView(game: game,
                       playerIndex: model.playerIndex,
                       didPlay: model.playCard)
        default:
            Text("Table")
        }
    }
}
