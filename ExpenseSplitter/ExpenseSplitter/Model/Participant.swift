//
//  Participant.swift
//  ExpenseSplitter
//
//  Created by Artur Bagautdinov on 29.09.2025.
//

import Foundation

struct Participant: Identifiable {
    let id = UUID()
    var name: String
    var expense: Double
}
