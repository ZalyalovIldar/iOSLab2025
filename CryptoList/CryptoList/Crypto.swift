//
//  Crypto.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 22.12.2025.
//

import Foundation

struct Crypto: Identifiable, Codable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let image: String
}

extension Crypto {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currentPrice = "current_price"
        case image
    }
}
