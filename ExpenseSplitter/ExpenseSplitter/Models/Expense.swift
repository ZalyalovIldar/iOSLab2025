//
//  Expense.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()
    let name: String
    let cost: Double
    let category: Category
}
