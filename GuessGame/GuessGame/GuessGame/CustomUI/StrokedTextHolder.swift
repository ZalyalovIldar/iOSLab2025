//
//  StrokedTextHolder.swift
//  GuessGame
//
//  Created by Ляйсан on 23.09.2025.
//

import SwiftUI

struct StrokedTextHolder: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .padding()
            .frame(width: 360, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.blue, lineWidth: 1.3)
                    .glassEffect(.clear, in: .rect(cornerRadius: 25))
            }
    }
}

#Preview {
    StrokedTextHolder(text: "Easy: 5 attempts                                              \n\nMedium: 3 attempts \n\nHard: 1 attempt")
}
