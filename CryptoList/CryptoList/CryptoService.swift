//
//  CryptoService.swift
//  CryptoList
//
//  Created by Azamat Zakirov on 29.12.2025.
//

import Foundation

protocol CryptoService {
    func fetchCryptos(forceRefresh: Bool) async throws -> [Crypto]
}

class RealCryptoService: CryptoService {
    private let baseURL = "https://api.coingecko.com/api/v3/coins/markets"
    private var cachedCryptos: [Crypto]?
    
    func fetchCryptos(forceRefresh: Bool = false) async throws -> [Crypto] {
        if !forceRefresh, let cached = cachedCryptos {
            return cached
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd")
        ]
        
        guard let url = components?.url else {
            throw CryptoServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let cryptos = try decoder.decode([Crypto].self, from: data)
        
        cachedCryptos = cryptos
        return cryptos
    }
}

enum CryptoServiceError: Error, LocalizedError {
    case invalidURL
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Failed to decode data"
        case .networkError:
            return "Network error occurred"
        }
    }
}
