//
//  Favorite.swift
//  Favorites Manager
//
//  Created by Azamat Zakirov on 31.12.2025.
//

import Foundation

struct Favorite: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var year: Int?
    
    init(id: UUID = UUID(), title: String, author: String, year: Int? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.year = year
    }
    
    var firstLetter: String {
        title.prefix(1).uppercased()
    }
}
