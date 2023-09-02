import SwiftUI

@main
struct CardsApp: App {
    @State var model = ViewModel()
    
    #if os(visionOS)
    @State var immersionStyle: ImmersionStyle = .mixed
    #endif
    
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
        
        ImmersiveSpace(id: "immersive-space") {
            ImmersiveView()
                .environmentObject(model)
        }.immersionStyle(selection: $immersionStyle, in: .mixed)
        #endif
    }
}
