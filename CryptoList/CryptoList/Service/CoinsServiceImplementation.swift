//
//  FavoritesServiceImplementation.swift
//  CryptoList
//
//  Created by Ляйсан
//

import Foundation

final class CoinsServiceImplementation: CoinsService {
    func fetchFavorites(url: String) async throws -> [Coin] {
        let data = try await NetworkManager.shared.fetchData(for: url)
        
        guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else { throw APError.decodingError }
        return coins
    }
}
