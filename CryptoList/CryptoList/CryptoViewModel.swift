//
//  CryptoViewModel.swift
//  CryptoList
//
//  Created by Azamat Zakirov on 29.12.2025.
//

import Foundation
import Observation

@Observable
class CryptoViewModel {
    var items: [Crypto] = []
    var isLoading = false
    var error: Error?
    
    private let service: CryptoService
    
    init(service: CryptoService = RealCryptoService()) {
        self.service = service
    }
    
    func load(forceRefresh: Bool = false) async {
        isLoading = true
        error = nil
        
        do {
            var cryptos = try await service.fetchCryptos(forceRefresh: forceRefresh)
            cryptos.sort { $0.currentPrice > $1.currentPrice }
            items = cryptos
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    var topGainers: [Crypto] {
        Array(items.prefix(5))
    }
    
    func formatPrice(_ price: Double) -> String {
        if price >= 1000 {
            return String(format: "$%.2f", price)
        } else if price >= 1 {
            return String(format: "$%.2f", price)
        } else {
            return String(format: "$%.6f", price)
        }
    }
}
