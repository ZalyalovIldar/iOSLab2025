//
//  NetworkManager.swift
//  CryptoList
//
//  Created by Ляйсан
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(for url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw APError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse(data: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else { throw APError.invalidResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw APError.badStatusCode(response.statusCode) }
        
        return data
    }
}
