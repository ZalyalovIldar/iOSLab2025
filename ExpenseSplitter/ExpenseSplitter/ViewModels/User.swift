//
//  User.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import Foundation

@Observable
class User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var expenses: [Category: [Expense]] = [:]
    var totalPersonalExpenses = 0.0
    var isShowingOnTheScreen = false
    static var totalToPay = 0.0
    
    init(name: String) {
        self.name = name
    }
}
