//
//  NetworkError.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
}
