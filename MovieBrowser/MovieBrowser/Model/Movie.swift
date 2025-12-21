//
//  Movie.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import Foundation

enum Genre: String, Identifiable, Hashable, CaseIterable, Codable {
    case comedy
    case drama
    case fantasy
    case thriller
    
    var id: String { rawValue }
}

struct Movie: Identifiable, Hashable, Codable {
    let id: String
    var title: String
    var genre: Genre
    var description: String
    var releaseYear: Int
    var imageName: String
    
    init(id: String = UUID().uuidString, title: String, genre: Genre, description: String, releaseYear: Int, imageName: String) {
        self.id = id
        self.title = title
        self.genre = genre
        self.description = description
        self.releaseYear = releaseYear
        self.imageName = imageName
    }
    
    static let mockMovies: [Movie] = [
        Movie(title: "Inception", genre: .thriller, description: "A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea into the mind of a C.E.O.", releaseYear: 2010, imageName: "st"),
        Movie(title: "The Grand Budapest Hotel", genre: .comedy, description: "A writer encounters the owner of an aging high-class hotel, who tells him of his early years serving as a lobby boy in the hotel's glorious years under an exceptional concierge.", releaseYear: 2014, imageName: "st"),
        Movie(title: "Parasite", genre: .drama, description: "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.", releaseYear: 2019, imageName: "st"),
        Movie(title: "Pan's Labyrinth", genre: .fantasy, description: "In the falangist Spain of 1944, the bookish young stepdaughter of a sadistic army officer escapes into an eerie but captivating fantasy world.", releaseYear: 2006, imageName: "st"),
        Movie(title: "Little Miss Sunshine", genre: .comedy, description: "A family struggles to support their youngest daughter's dream of competing in a beauty pageant.", releaseYear: 2006, imageName: "st"),
        Movie(title: "Moonlight", genre: .drama, description: "A young African-American man grapples with his identity and sexuality while experiencing the everyday struggles of childhood, adolescence, and adulthood.", releaseYear: 2016, imageName: "st"),
        Movie(title: "The Shape of Water", genre: .fantasy, description: "At a top secret research facility in the 1960s, a lonely janitor forms a unique relationship with an amphibious creature.", releaseYear: 2017, imageName: "water"),
        Movie(title: "Gone Girl", genre: .thriller, description: "With his wife's disappearance having become the focus of an intense media circus, a man sees the spotlight turned on him when it's suspected that he may not be innocent.", releaseYear: 2014, imageName: "gonegirl"),
        Movie(title: "Amélie", genre: .comedy, description: "Amélie is an innocent and naive girl in Paris with her own sense of justice. She decides to help those around her and, along the way, discovers love.", releaseYear: 2001, imageName: "amelie"),
        Movie(title: "Whiplash", genre: .drama, description: "A promising young drummer enrolls at a cut-throat music conservatory where his dreams of greatness are mentored by an instructor who will stop at nothing to realize a student's potential.", releaseYear: 2014, imageName: "whiplash")
    ]
}

