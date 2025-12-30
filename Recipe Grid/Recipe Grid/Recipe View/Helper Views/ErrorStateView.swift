//
//  ErrorStateView.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size:36))
                .foregroundStyle(.red)
            Text(message)
                .font(.headline)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}
