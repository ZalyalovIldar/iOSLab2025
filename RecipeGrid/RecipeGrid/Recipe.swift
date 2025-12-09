//
//  Recipe.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import SwiftUI
import UIKit

struct Recipe: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var imageName: String
    var summary: String
    var category: String
    var imageType: RecipeImageType
    
    init(
        id: UUID = UUID(),
        title: String,
        imageName: String,
        summary: String,
        category: String,
        imageType: RecipeImageType
    ) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.summary = summary
        self.category = category
        self.imageType = imageType
    }
}

enum RecipeImageType: String, Codable {
    case symbol
    case photo
    case none
}

extension Recipe {
    
    mutating func saveImage(_ image: UIImage) throws {
        let fileName = "\(self.id.uuidString).jpg"
        try RecipeImageStorage.shared.save(image: image, fileName: fileName)
        self.imageName = fileName
        self.imageType = .photo
    }
}
