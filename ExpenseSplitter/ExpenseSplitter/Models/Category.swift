//
//  Category.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

enum Category: String, CaseIterable, Codable {
    case food, clothing, transport, health, other, total
    
    var color: Color {
        switch self {
        case .food: return .yellow
        case .clothing: return .pink
        case .transport: return .orange
        case .health: return .blue
        case .other: return .purple
        case .total: return .gray
        }
    }
}
