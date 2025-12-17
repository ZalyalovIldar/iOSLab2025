//
//  Crypto.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//

import Foundation

struct Crypto: Codable, Identifiable {//json id
    let id: String //айди
    let name: String //название
    let symbol: String //символ
    let currentPrice: Double //текущая цена
    let image: String //ссылка на картинку
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currentPrice = "current_price" //для json
        case image
    }
}
