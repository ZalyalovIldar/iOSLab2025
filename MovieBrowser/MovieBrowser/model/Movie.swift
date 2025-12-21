//
//  Movie.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import Foundation

enum PosterType: String, Codable, CaseIterable, Hashable {
    case sfSymbol
    case photo
}

struct Movie: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var genre: String
    var description: String
    var releaseYear: Int
    var posterType: PosterType = .sfSymbol
    var posterName: String = "film"
    var posterImageData: Data? = nil
}

