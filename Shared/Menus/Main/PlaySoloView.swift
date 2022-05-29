//
//  PlaySoloView.swift
//  Card Play
//
//  Created by Binns, Oliver on 29/05/2022.
//
import SwiftUI

struct PlaySoloView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink {
                SoloGame()
            } label: {
                HStack {
                    Image(systemName: "person")
                    Text("Play Solo")
                }
                .padding(8)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accentColor(.blue)
        }
        .padding()
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
