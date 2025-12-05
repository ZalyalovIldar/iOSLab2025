//
//  EmptyStateView.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import SwiftUI

struct EmptyStateView: View {
    let action: () -> ()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Image(systemName: "carrot")
                    .font(.largeTitle)
                    .foregroundStyle(.lightGrey)
                    .padding(10)
                Text("No Recipes")
                    .foregroundStyle(.white)
                    .font(.title2.bold())
                Text("Tap the button below to add recipe")
                    .font(.subheadline)
                    .foregroundStyle(.lightGrey.opacity(0.9))
                Button {
                    action()
                } label: {
                    Text("New Recipe")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)
                }
                .buttonStyle(.glassProminent)
                .tint(.orange)
                .padding(10)
            }
        }
    }
}

#Preview {
    EmptyStateView(action: {})
}
