//
//  CryptoListApp.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 22.12.2025.
//

import SwiftUI

@main
struct CryptoListApp: App {
    
    @State private var viewModel = CryptosViewModel(service: realCryptoService())
    
    var body: some Scene {
        WindowGroup {
            CryptosListView(viewModel: viewModel)
        }
    }
}
