import SwiftUI

@main
struct CardsApp: App {
    @State var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainMenu()
                .environmentObject(model)
        }
    }
}
