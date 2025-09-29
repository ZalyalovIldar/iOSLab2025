//
//  ExpenseViewModel.swift
//  ExpenseSplitter
//
//  Created by Artur Bagautdinov on 29.09.2025.
//

import SwiftUI
import Combine

class ExpenseViewModel: ObservableObject {
    
    @Published var participants: [Participant] = []
    @Published var newName: String = ""
    @Published var newExpense: String = ""
    
    func addParticipant() {
        guard !newName.isEmpty, let expense = Double(newExpense) else { return }
        let participant = Participant(name: newName, expense: expense)
        participants.append(participant)
        newName = ""
        newExpense = ""
    }
    
    var averageExpense: Double {
        guard !participants.isEmpty else { return 0 }
        let total = participants.reduce(0) { $0 + $1.expense }
        return total / Double(participants.count)
    }
    
    func balances() -> [String: Double] {
        var result: [String: Double] = [:]
        for p in participants {
            result[p.name] = p.expense - averageExpense
        }
        return result
        
    }
}

