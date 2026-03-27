//
//  MovieViewModel.swift
//  FilmsDZ6
//
//  Created by Иван Метальников on 11.12.2025.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class MovieViewModel{
    var movies: [Movie] = []
    
    func addMovie(title: String){
        movies.insert(
            Movie(id: UUID(), title: title, genre: String(), description: String(), realeseYear: Int()),
        at: 0)
    }
    
    func deleteMovie(at offsets: IndexSet){
        movies.remove(atOffsets: offsets)
    }
    
}
