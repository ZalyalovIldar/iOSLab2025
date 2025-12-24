//
//  MoviesApp.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 22.12.2025.
//

import SwiftUI

@main
struct MoviesApp: App {
    
    @State private var viewModel = MoviesViewModel()
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: viewModel)
        }
    }
}
