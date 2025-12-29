//
//  DefaultNetworkService.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

final class DefaultNetworkService: NetworkService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchData(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw APIError.invalidURL }
        
        let (data, response) = try await urlSession.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse(data: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw APIError.badStatusCode(response.statusCode) }
        
        return data
    }
}
