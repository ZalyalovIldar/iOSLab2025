//
//  Input.swift
//  FavoritesApp
//
//  Created by Ляйсан

import SwiftUI

struct Input: View {
    @Binding var text: String
    
    var body: some View {
        TextField(text, text: $text)
            .foregroundStyle(.white)
            .padding(15)
            .glassEffect(.clear, in: .rect(cornerRadius: 20))
    }
}
