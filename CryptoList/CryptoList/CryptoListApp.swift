//
//  CryptoListApp.swift
//  CryptoList
//
//  Created by Ляйсан
//

import SwiftUI

@main
struct CryptoListApp: App {
    @State var coinViewModel = CoinViewModel(service: CoinsServiceImplementation())
    
    var body: some Scene {
        WindowGroup {
            CryptoListView(coinViewModel: coinViewModel)
        }
    }
}
