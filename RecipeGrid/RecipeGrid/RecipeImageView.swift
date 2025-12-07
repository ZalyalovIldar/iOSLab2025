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
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

            case .photo:
                if let uiImage = RecipeImageStorage.shared.load(fileName: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(12)
                } else {
                    Text("Image not uploaded yet")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

extension RecipeImageView {
    init(recipe: Recipe) {
        self.imageType = recipe.imageType
        self.imageName = recipe.imageName
    }
}
