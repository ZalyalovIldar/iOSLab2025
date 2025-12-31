import Foundation

struct Crypto: Identifiable, Codable {
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
