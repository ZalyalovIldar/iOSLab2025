//
//  FilmsDZ6App.swift
//  FilmsDZ6
//
//  Created by Иван Метальников on 11.12.2025.
//

import SwiftUI

@main
struct FilmsDZ6App: App {
    @State var movieViewModel: MovieViewModel = MovieViewModel()
    var body: some Scene {
        WindowGroup {
            MoviesListView(movieViewModel: movieViewModel)
        }
    }
}
