//
//  APIError.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case invalidData
}
