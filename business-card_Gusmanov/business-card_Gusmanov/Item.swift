//
//  Item.swift
//  business-card_Gusmanov
//
//  Created by tvoryxuiny on 9/20/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
