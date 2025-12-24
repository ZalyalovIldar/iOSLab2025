//
//  CryptosViewModel.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 23.12.2025.
//

import Foundation

@Observable
final class CryptosViewModel {
    
    enum State: Equatable {
        case loading
        case empty
        case content
        case error(String)
    }
    
    var cryptos: [Crypto] = []
    var state: State = .loading
    
    private let service: CryptoService
    
    init(cryptos: [Crypto] = [], service: CryptoService) {
        self.cryptos = cryptos
        self.service = service
    }
    
    func load(forceReload: Bool = false) async {
        do {
            cryptos = try await service.obtainCryptos(forceReload: forceReload)
            state = cryptos.isEmpty ? .empty : .content
        }
        catch NetworkError.decodingFailed {
            cryptos = []
            state = .error("Failed to decode data")
        }
        catch let NetworkError.badStatusCode(code) {
            cryptos = []
            state = .error("Bad status code: \(code)")
        }
        catch NetworkError.invalidURL {
            cryptos = []
            state = .error("Invalid API URL")
        }
        catch {
            cryptos = []
            state = .error("Unexpected error")
        }
    }
    
    enum SortOption: String, CaseIterable, Identifiable {
        case none
        case priceDesc
        case priceAsc
        case nameAsc
        case nameDesc
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .priceDesc:  return "Price: High → Low"
            case .priceAsc:   return "Price: Low → High"
            case .nameAsc:    return "Name A–Z"
            case .nameDesc:   return "Name Z–A"
            case .none:       return "No sorting"
            }
        }
    }
    
    var sortOption: SortOption = .none
    
    var sortedCryptos: [Crypto] {
        switch sortOption {
        case .priceAsc:
            return cryptos.sorted { $0.currentPrice < $1.currentPrice }
        case .priceDesc:
            return cryptos.sorted { $0.currentPrice > $1.currentPrice }
            
        case .nameAsc:
            return cryptos.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDesc:
            return cryptos.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .none:
            return cryptos
        }
    }
    
    var topGainers: [Crypto] {
        cryptos
            .filter { ($0.priceChangePercentage24h ?? 0) > 0 }
            .sorted { ($0.priceChangePercentage24h ?? 0) > ($1.priceChangePercentage24h ?? 0) }
            .prefix(10)
            .map { $0 }
    }
}
