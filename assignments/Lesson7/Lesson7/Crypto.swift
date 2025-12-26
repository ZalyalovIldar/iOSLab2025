//
//  Crypto.swift
//  Lesson7
//
//  Created by Timur Minkhatov on 24.12.2025.
//

import Foundation

struct Crypto: Identifiable, Codable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let image: String
    let priceChangePercentage24h: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currentPrice = "current_price"
        case image
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}
