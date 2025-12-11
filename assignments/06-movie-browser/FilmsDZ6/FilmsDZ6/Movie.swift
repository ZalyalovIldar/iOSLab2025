//
//  Movie.swift
//  FilmsDZ6
//
//  Created by Иван Метальников on 11.12.2025.
//

import Foundation


struct Movie: Identifiable, Hashable{
    let id: UUID
    var title: String
    var genre: String
    var description: String
    var realeseYear: Int
}
