//
//  Lesson9App.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import SwiftUI

@main
struct Lesson9App: App {
    
    private let viewModel = PlacesViewModel(storage: UserDefaultsPlacesStorage())
    
    var body: some Scene {
        WindowGroup {
            PlacesView(viewModel: viewModel)
        }
    }
}
