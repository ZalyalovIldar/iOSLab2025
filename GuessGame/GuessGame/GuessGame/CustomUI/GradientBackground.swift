//
//  GradientBackground.swift
//  GuessGame
//
//  Created by Ляйсан on 22.09.2025.
//

import SwiftUI

struct GradientBackground: View {
    var color: Color
    
    var body: some View {
        Color.black.ignoresSafeArea()
        Circle()
            .fill(color)
            .blur(radius: 90)
            .offset(x: 210, y: -520)
    }
}

#Preview {
    GradientBackground(color: .blue)
}
