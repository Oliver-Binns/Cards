import SwiftUI

@main
struct CardsApp: App {
    @State var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainMenu()
                .environmentObject(model)
        }
        
        #if os(visionOS)
        WindowGroup("Your Cards", id: "hand-view") {
            InputMenu()
                .environmentObject(model)
        }
        .defaultSize(width: 600, height: 600, depth: 1)
        #endif
    }
}
