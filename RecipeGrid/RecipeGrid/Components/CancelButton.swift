//
//  CancelButton.swift
//  RecipeGrid
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI

struct CancelButton: View {
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

#Preview {
    CancelButton()
}
