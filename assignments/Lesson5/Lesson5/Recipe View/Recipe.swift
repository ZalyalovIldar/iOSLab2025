//
//  Recipe.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 05.11.2025.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var imageName: String
    var summary: String
    var category: String
    let dateAdded: Date
    
    init(id: UUID = UUID(), title: String, imageName: String, summary: String, category: String, dateAdded: Date = Date()) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.summary = summary
        self.category = category
        self.dateAdded = dateAdded
    }
    
    static let categories = ["Main", "Starter", "Side", "Sweet dishes", "Other"]
    
    static let placeholder = Recipe(
        title: "Unknown Recipe",
        imageName: "placeholder",
        summary: "No description available",
        category: "Other"
    )
}
