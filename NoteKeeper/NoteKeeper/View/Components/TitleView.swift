//
//  TitleView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct TitleView: View {
    
    var body: some View {
        
        Text("Note Keeper")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(
                LinearGradient(colors: [.blue, .purple],
                               startPoint: .leading,
                               endPoint: .trailing)
            )
    }
}

#Preview {
    TitleView()
}
