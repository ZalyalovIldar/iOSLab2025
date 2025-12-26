//
//  CryptoViewModel.swift
//  Lesson7
//
//  Created by Timur Minkhatov on 24.12.2025.
//

import Foundation
import Observation

@Observable
final class CryptoViewModel {
    
    private let service: CryptoService
    
    var items: [Crypto] = []
    var isLoading = false
    var error: String?
    
    private var cachedItems: [Crypto]?
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func load() async {
        if let cached = cachedItems {
            items = cached
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let cryptos = try await service.fetchCryptos()
            items = cryptos
            cachedItems = cryptos
        } catch {
            self.error = "Failed to load cryptocurrencies"
        }
        
        isLoading = false
    }
    
    func sortByPrice(ascending: Bool) {
        if ascending {
            items.sort { $0.currentPrice < $1.currentPrice }
        } else {
            items.sort { $0.currentPrice > $1.currentPrice }
        }
    }
}
