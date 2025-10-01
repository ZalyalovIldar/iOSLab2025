//
//  ExpenseViewModel.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import Foundation

@Observable
class ExpenseViewModel {
    var selectedUserID: UUID?
    let savedDataKey = "users"
    var users: [User] = [] {
        didSet {
            saveUsersData()
        }
    }

    init(names: [String]) {
        for i in 0..<names.count {
            if names[i] != "" {
                let user = User(name: names[i])
                users.append(user)
            }
        }
        if !users.isEmpty {
            selectedUserID = users[0].id
        }
    }
    
    func saveUsersData() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: savedDataKey)
        }
    }
    
    func getUsersData() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: savedDataKey),
              let usersData = try? JSONDecoder().decode([User].self, from: data)
        else { return false }
        users.self = usersData
        return true
    }
    
    func addExpenseByCategory(expense: Expense, category: Category) {
        getSelectedUser()?.expenses[category, default: []].append(expense)
    }
    
    func getSelectedUser() -> User? {
        return users.first(where: { $0.id == selectedUserID })
    }
    
    func totalCostByCategory(category: Category) -> Double {
        guard let user = getSelectedUser(), let expense = user.expenses[category] else { return 0}
        return expense.reduce(0) { $0 + $1.cost }
    }
    
    func totalPersonalPrice() -> Double {
        guard let user = getSelectedUser() else { return 0 }
        var total = 0.0
        for category in Category.allCases {
            if let expenses = user.expenses[category] {
                total += expenses.reduce(0) { $0 + $1.cost }
            }
        }
        user.totalPersonalExpenses = total
        return total
    }
    
    func totalToPay() -> Double {
        var totalToPay = 0.0
        for i in 0..<users.count {
            totalToPay += users[i].totalPersonalExpenses
        }
        return totalToPay / Double(users.count)
    }
    
    func deleteUser(ids: [UUID]) {
        for i in 0..<ids.count {
            if let userToDeleteIndex = users.firstIndex(where: { $0.id == ids[i] }) {
                users.remove(at: userToDeleteIndex)
                if !users.isEmpty {
                    selectedUserID = users[0].id
                }
                
            }
        }
    }
}
