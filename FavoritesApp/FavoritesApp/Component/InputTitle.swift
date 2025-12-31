//
//  InputTitle.swift
//  FavoritesApp
//
//  Created by Ляйсан

import SwiftUI

struct InputTitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
    }
}

#Preview {
    InputTitle(text: "Ordinary")
}
