//
//  MovieBrowserApp.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

@main
struct MovieBrowserApp: App {
    @State private var viewModel = MoviesViewModel() //храним состояние если изменяется то обновляем экран
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: viewModel)
        }
    }
}
