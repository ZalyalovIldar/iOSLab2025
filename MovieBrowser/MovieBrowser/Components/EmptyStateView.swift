//
//  EmptyStateView.swift
//  MovieBrowser
//
//  Created by Ляйсан on 15/12/25.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subTitle: String
    let imageName: String
    let buttonLabel: String
    let action: () -> ()
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundStyle(.lightGrey)
                .padding(5)
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text(subTitle)
                .font(.subheadline)
                .foregroundStyle(.lightGrey)
            Button {
                action()
            } label: {
                Text(buttonLabel)
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.glassProminent)
            .tint(.lightVine)
            .padding(10)
        }
    }
}

#Preview {
    EmptyStateView(title: "No Movies", subTitle: "Tap plus button to add a movie", imageName: "popcorn", buttonLabel: "New Movies", action: {})
}
