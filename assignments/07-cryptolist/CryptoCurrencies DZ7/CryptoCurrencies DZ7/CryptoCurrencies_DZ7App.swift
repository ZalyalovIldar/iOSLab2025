//
//  CryptoCurrencies_DZ7App.swift
//  CryptoCurrencies DZ7
//
//  Created by Иван Метальников on 06.01.2026.
//

import SwiftUI

@main
struct CryptoCurrencies_DZ7App: App {
    private let viewModel: CryptoViewModel = .init(service: RealCryptoService())
    
    var body: some Scene {
        WindowGroup {
            CryptoView(viewModel: viewModel)
        }
    }
}
