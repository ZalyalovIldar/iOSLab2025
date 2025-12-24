//
//  CryptoService.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 22.12.2025.
//

import Foundation

protocol CryptoService {
    func obtainCryptos(forceReload: Bool) async throws -> [Crypto]
}

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
}

class realCryptoService: CryptoService {
    
    private let cryptosURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    private let urlSession: URLSession
    private lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    private var cachedCryptos: [Crypto]?
    private var cacheDate: Date?
    private let cacheRefreshTime: TimeInterval = 60
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func obtainCryptos(forceReload: Bool) async throws -> [Crypto] {
        
        if !forceReload,
           let cached = cachedCryptos,
           let date = cacheDate,
           Date().timeIntervalSince(date) < cacheRefreshTime {
            return cached
        }
        
        guard let url = URL(string: cryptosURL) else {
            throw NetworkError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        
        do {
            let result = try decoder.decode([Crypto].self, from: data)
            cachedCryptos = result
            cacheDate = Date()
            return result
        }
        catch {
            throw NetworkError.decodingFailed
        }
    }
    
}
