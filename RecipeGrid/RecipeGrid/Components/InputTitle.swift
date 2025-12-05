//
//  InputTitle.swift
//  RecipeGrid
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI

struct InputTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2.bold())
            .padding(.top)
    }
}

#Preview {
    InputTitle(title: "Title")
}
