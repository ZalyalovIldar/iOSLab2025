//
//  Title.swift
//  FavoritesApp
//
//  Created by Ляйсан 

import SwiftUI

struct Title: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.largeTitle.bold())
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 35)
            .padding(.horizontal)
    }
}

#Preview {
    Title(text: "Home", color: .primaryRed)
}
