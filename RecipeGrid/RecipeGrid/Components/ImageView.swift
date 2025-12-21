//
//  Image.swift
//  RecipeGrid
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI

struct ImageView: View {
    let recipe: Recipe
    let folderName: String
    
    var body: some View {
        if let savedImage = LocalFileManager.shared.getImage(imageName: recipe.imageName, folderName: folderName) {
            Image(uiImage: savedImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scaledToFit()
        } else {
            Image("imagePlaceholder")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scaledToFit()
        }
    }
}
