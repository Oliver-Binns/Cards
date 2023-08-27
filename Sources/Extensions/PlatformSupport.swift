import SwiftUI
import SwiftUINavigation

extension View {
    func inlineNavigationTitle() -> some View {
        #if os(macOS)
        self
        #else
        navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    func givenNameContentType() -> some View {
        #if os(macOS)
        self
        #else
        textContentType(.givenName)
        #endif
    }
}
