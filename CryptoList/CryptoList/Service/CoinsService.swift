//
//  FavoritesService.swift
//  CryptoList
//
//  Created by Ляйсан
//

import Foundation

protocol CoinsService {
    func fetchFavorites(url: String) async throws -> [Coin]
}
