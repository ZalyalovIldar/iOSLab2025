//
//  CryptoService.swift
//  Lesson7
//
//  Created by Timur Minkhatov on 24.12.2025.
//

import Foundation

protocol CryptoService {
    func fetchCryptos() async throws -> [Crypto]
}

enum CryptoServiceError: Error {
    case invalidURL
    case networkError
    case decodingError
}

final class RealCryptoService: CryptoService {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    
    func fetchCryptos() async throws -> [Crypto] {
        guard let url = URL(string: urlString) else {
            throw CryptoServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
            return cryptos
        } catch is DecodingError {
            throw CryptoServiceError.decodingError
        } catch {
            throw CryptoServiceError.networkError
        }
    }
}
