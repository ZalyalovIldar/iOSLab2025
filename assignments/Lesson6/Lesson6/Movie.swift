//
//  Movie.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 21.12.2025.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var genre: String
    var description: String
    var releaseYear: Int
    
    init(id: UUID = UUID(), title: String, genre: String, description: String, releaseYear: Int) {
        self.id = id
        self.title = title
        self.genre = genre
        self.description = description
        self.releaseYear = releaseYear
    }
}

extension Movie {
    static let samples: [Movie] = [
        Movie(
            title: "The Shawshank Redemption",
            genre: "Drama",
            description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
            releaseYear: 1994
        ),
        Movie(
            title: "The Dark Knight",
            genre: "Action",
            description: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.",
            releaseYear: 2008
        ),
        Movie(
            title: "Inception",
            genre: "Sci-Fi",
            description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea.",
            releaseYear: 2010
        ),
        Movie(
            title: "Forrest Gump",
            genre: "Drama",
            description: "The presidencies of Kennedy and Johnson unfold through the perspective of an Alabama man with an IQ of 75.",
            releaseYear: 1994
        ),
        Movie(
            title: "The Matrix",
            genre: "Sci-Fi",
            description: "A computer hacker learns about the true nature of his reality and his role in the war against its controllers.",
            releaseYear: 1999
        )
    ]
}
