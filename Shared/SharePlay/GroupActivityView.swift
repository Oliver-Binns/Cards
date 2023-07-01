//
//  GroupActivityView.swift
//  Card Play
//
//  Created by Binns, Oliver on 29/05/2022.
//
import GroupActivities
import SwiftUI
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
