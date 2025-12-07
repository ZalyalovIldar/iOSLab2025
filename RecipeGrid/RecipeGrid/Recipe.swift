//
//  Recipe.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//
import SwiftUI
import UIKit

struct Recipe: Identifiable, Hashable {
    let id: UUID = UUID()
    var title: String
    var imageName: String
    var summary: String
    var category: String
    var imageType: RecipeImageType
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
