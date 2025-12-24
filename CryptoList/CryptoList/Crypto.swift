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
    let priceChangePercentage24h: Double?
}

extension Crypto {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currentPrice = "current_price"
        case image
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
    
    private static let largePriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private static let smallPriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 10
        return formatter
    }()
    
    var formattedPriceUSD: String {
        let formatter = currentPrice >= 1
        ? Self.largePriceFormatter
        : Self.smallPriceFormatter
        
        return formatter.string(from: NSNumber(value: currentPrice))
        ?? "$0.00"
    }
}
