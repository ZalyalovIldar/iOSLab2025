//
//  APError.swift
//  CryptoListTest
//
//  Created by Ляйсан
//

import Foundation

enum APError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case badStatusCode(Int)
    case decodingError
    case unableToComplete
}
