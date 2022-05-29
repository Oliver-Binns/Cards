//
//  ReadableWidth.swift
//  Card Play
//
//  Created by Binns, Oliver on 29/05/2022.
//
import SwiftUI

private struct ReadableGuidePadding: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            content.frame(maxWidth: 672)
            Spacer(minLength: 0)
        }
    }
}

extension View {
    func readableGuidePadding() -> some View {
        modifier(ReadableGuidePadding())
    }
}
