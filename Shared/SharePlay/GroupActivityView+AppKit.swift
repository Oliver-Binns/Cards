import GroupActivities
import SwiftUI

#if canImport(AppKit)
import AppKit

struct GroupActivityView<ActivityType: GroupActivity>: NSViewControllerRepresentable, Identifiable {
    let id = UUID()
    let type: () async throws -> ActivityType

    func makeNSViewController(context: Context) -> NSViewController {
        // GroupActivitySharingController should be avaialble on macOS 13+
        // https://developer.apple.com/documentation/groupactivities/groupactivitysharingcontroller-4gtfk
        // Currently receiving the error `Cannot find 'GroupActivitySharingController' in scope`
        //
        // The following code can be uncommented in Xcode 15+
        //
        #if swift(>=5.9)
        return GroupActivitySharingController(preparationHandler: type)
        #else
        return UnsupportedViewController()
        #endif
        
    }
    
    func updateNSViewController(_ vc: NSViewControllerType, context: Context) {
        
    }
}

final class UnsupportedViewController: NSViewController {
    override func loadView() {
        view = NSView(frame: NSMakeRect(0.0, 0.0, 300, 300))
        
        let label = NSTextField(labelWithString: "This feature is not supported on your version of macOS")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
#endif
