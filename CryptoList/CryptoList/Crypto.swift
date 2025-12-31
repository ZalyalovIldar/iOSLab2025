//
//  Crypto.swift
//  CryptoList
//
//  Created by Azamat Zakirov on 29.12.2025.
//

import Foundation

struct Crypto: Codable, Identifiable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currentPrice = "current_price"
        case image
    }
}
