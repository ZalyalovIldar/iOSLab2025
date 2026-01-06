//
//  Crypto.swift
//  CryptoCurrencies DZ7
//
//  Created by Иван Метальников on 06.01.2026.
//

import Foundation

struct Crypto: Decodable, Identifiable{
    let id: UUID = UUID()
    let name: String
    let symbol: String
    let currentPrice: Double
    let imageURL: String
    
}

extension Crypto{
    enum CodingKeys: String, CodingKey {
        case name, symbol
        
        case currentPrice = "current_price"
        case imageURL = "image"
    }
}
