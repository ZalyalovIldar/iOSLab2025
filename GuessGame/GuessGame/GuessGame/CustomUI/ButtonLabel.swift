//
//  GrayTypeButton.swift
//  GuessGame
//
//  Created by Ляйсан on 21.09.2025.
//

import SwiftUI

struct ButtonLabel: View {
    var text: String
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(width: 175)
            .padding(.vertical, 15)
            .glassEffect(.clear.tint(backgroundColor).interactive())
    }
}

#Preview {
    ButtonLabel(text: "Start playing", backgroundColor: .gray)
}
