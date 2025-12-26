//
//  Lesson7App.swift
//  Lesson7
//
//  Created by Timur Minkhatov on 24.12.2025.
//

import SwiftUI

@main
struct Lesson7App: App {
    
    @State private var viewModel = CryptoViewModel(service: RealCryptoService())
    
    var body: some Scene {
        WindowGroup {
            CryptoListView(viewModel: viewModel)
        }
    }
}
