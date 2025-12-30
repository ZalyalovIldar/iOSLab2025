//
//  FavoriteBook.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import Foundation

struct FavoriteBook: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var createdAt: Date
    var coverImageData: Data?
    var description: String

    init(id: UUID = UUID(), title: String, author: String, createdAt: Date = .now, coverImageData: Data? = nil, description: String = "") {
        self.id = id
        self.title = title
        self.author = author
        self.createdAt = createdAt
        self.coverImageData = coverImageData
        self.description = description
    }

    var firstLetterUppercased: String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return "#" }
        return String(first).uppercased()
    }
}
