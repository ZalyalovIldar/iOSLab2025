//
//  Movie.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var genre: String
    var description: String
    var releaseYear: Int
    var posterSymbol: String // иконка для постера
    
    init(id: UUID = UUID(), title: String, genre: String, description: String, releaseYear: Int, posterSymbol: String = "film.fill") { //инициализация
        self.id = id
        self.title = title
        self.genre = genre
        self.description = description
        self.releaseYear = releaseYear
        self.posterSymbol = posterSymbol
    }
}
