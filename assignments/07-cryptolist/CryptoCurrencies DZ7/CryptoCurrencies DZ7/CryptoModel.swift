//
//  Crypto.swift
//  CryptoCurrencies DZ7
//
//  Created by Иван Метальников on 06.01.2026.
//

import Foundation

struct Crypto: Decodable, Identifiable{
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let imageURL: URL
}

extension Crypto{
    enum CodingKeys: String, CodingKey {
        case name, symbol, id
        
        case currentPrice = "current_price"
        case imageURL = "image"
    }
}
