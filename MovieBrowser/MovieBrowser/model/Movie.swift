//
//  Movie.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import Foundation

struct Movie: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var genre: String
    var description: String
    var releaseYear: Int
}
