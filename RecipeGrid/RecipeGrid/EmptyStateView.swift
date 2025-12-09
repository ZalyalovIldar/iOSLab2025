//
//  EmptyStateView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 08.12.2025.
//

import SwiftUI

import SwiftUI

struct EmptyStateView: View {
    
    var title: String
    var message: String
    var systemImage: String
    var isLandscape: Bool

    var body: some View {
            
            Group {
                
                if isLandscape {
                    
                    HStack(spacing: 24) {
                        
                        icon
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text(title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(message)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.horizontal, 32)
                } else {
                    
                    VStack(spacing: 16) {
                        
                        icon
                        
                        Text(title)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(32)
                }
            }
    }
    
    private var icon: some View {
        
        Image(systemName: systemImage)
            .font(.system(size: 52))
            .foregroundColor(.secondary)
    }
}

#Preview {
    EmptyStateView(title: "No Recipes Yet", message: "Create your first recipe to get started!", systemImage: "leaf", isLandscape: false)
}
