import GroupActivities
import SwiftUI

#if canImport(UIKit)
import UIKit

struct GroupActivityView<ActivityType: GroupActivity>: UIViewControllerRepresentable, Identifiable {
    let id = UUID()
    let type: () async throws -> ActivityType

    func makeUIViewController(context: Context) -> UIViewController {
        if #available(iOS 15.4, *) {
            return GroupActivitySharingController(preparationHandler: type)
        } else {
            return .init()
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
#endif
