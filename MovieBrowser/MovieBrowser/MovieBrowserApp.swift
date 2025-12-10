//
//  MovieBrowserApp.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI

@main
struct MovieBrowserApp: App {
    @State private var movieViewModel = MovieViewModel()
    var body: some Scene {
        WindowGroup {
            MoviesView(movieViewModel: movieViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
