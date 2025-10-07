//
//  LargeTitle.swift
//  GuessGame
//
//  Created by Ляйсан on 22.09.2025.
//

import SwiftUI

struct LargeTitle: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .bold()
            .foregroundStyle(.white)
    }
}
