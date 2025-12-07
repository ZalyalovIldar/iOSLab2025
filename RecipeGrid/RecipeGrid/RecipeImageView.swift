//
//  RecipeImageView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 07.12.2025.
//

import SwiftUI

struct RecipeImageView: View {
    
    let imageType: RecipeImageType
    let imageName: String

    var body: some View {
        Group {
            switch imageType {
            case .symbol:
                if imageName != "" {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    PlaceholderImageView()
                }
                
            case .photo:
                if let uiImage = RecipeImageStorage.shared.load(fileName: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }
            case .none:
                PlaceholderImageView()
                
            }
        }
        .frame(width: 120, height: 120)
    }
}

extension RecipeImageView {
    init(recipe: Recipe) {
        self.imageType = recipe.imageType
        self.imageName = recipe.imageName
    }
}

#Preview {
    RecipeImageView(recipe: Recipe.init(title: "Test", imageName: "", summary: "Test", category: "Test", imageType: .symbol))
}
