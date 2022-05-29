//
//  GroupActivityView.swift
//  Card Play
//
//  Created by Binns, Oliver on 29/05/2022.
//
import GroupActivities
import SwiftUI
import UIKit

@available(iOS 15.4, *)
struct GroupActivityView<ActivityType: GroupActivity>: UIViewControllerRepresentable, Identifiable {
    let id = UUID()
    let type: () async throws -> ActivityType

    func makeUIViewController(context: Context) -> GroupActivitySharingController {
        GroupActivitySharingController(preparationHandler: type)
    }
    
    func updateUIViewController(_ uiViewController: GroupActivitySharingController, context: Context) {
        
    }
}
