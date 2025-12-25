//
//  CoinViewModel.swift
//  CryptoList
//
//  Created by Ляйсан
//

import Foundation

@Observable
final class CoinViewModel {
    let service: CoinsService
    
    var coins: [Coin] = []
    var alert: AlertItem?
    var isLoading = false
    var isSortedByPrice = false
    
    var sortedCoins: [Coin] {
        var result = coins
        
        if isSortedByPrice {
            result = result.sorted { $0.currentPrice > $1.currentPrice }
        }
        return result
    }
    
    var topGainersCoins: [Coin] {
        let coins = coins.sorted { ($0.priceChangePercentage24h ?? 0) > ($1.priceChangePercentage24h ?? 0) }
        return Array(coins.prefix(5))
    }
    
    private var fetchTask: Task<Void, Never>?
    
    init(service: CoinsService) {
        self.service = service
        
        getCoins()
    }
    
    func getCoins() {
        fetchTask?.cancel()
        
        fetchTask = Task {
            do {
                await MainActor.run { self.isLoading = true }
                let coins = try await service.fetchFavorites(url: Constants.baseURL)
                
                await MainActor.run {
                    self.coins = coins  
                    self.isLoading = false
                }
            } catch {
                if error is CancellationError { return }
                await MainActor.run {
                    self.isLoading = false
                    setAlertItem(error: error)
                }
            }
        }
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    private func setAlertItem(error: Error) {
        if let error = error as? APError {
            switch error {
            case .invalidURL:
                alert = AlertContext.invalidURL
            case .invalidData:
                alert = AlertContext.invalidData
            case .invalidResponse:
                alert = AlertContext.invalidResponse
            case .badStatusCode(let code):
                alert = AlertContext.badStatusCode(code)
            case .decodingError:
                alert = AlertContext.decodingError
            case .unableToComplete:
                alert = AlertContext.unableToComplete
            }
        } else {
            alert = AlertItem(title: "Unexpected Error", message: "\(error.localizedDescription)")
        }
    }
}
