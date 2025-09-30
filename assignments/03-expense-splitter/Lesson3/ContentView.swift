//
//  ContentView.swift
//  Lesson3
//
//  Created by Timur Minkhatov on 30.09.2025.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    let name: String
    var expenses: Double = 0.0
}

struct SettlementResult: Identifiable {
    var id = UUID()
    let item: Item
    var amount: Double
    
    var formattedAmount: String {
        let roundedAmount = (amount * 10).rounded() / 10
        return String(format: "%.1f", roundedAmount)
    }
}



struct ContentView: View {
    
    @State private var itemName: String = ""
    @State private var items: [Item] = []
    @State private var expenses: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                AddItemView(itemName: $itemName,
                            expenses: $expenses,
                            onAdd: addItem)
               
                if items.isEmpty {
                    ContentUnavailableView("Нет участников",
                                           systemImage: "person.3",
                                           description: Text("Добавьте участников для распределения расходов"))
                } else {
                    SettlementResultsView(items: items, onDelete: deleteItems)
                }
            }
            .padding()
            .navigationTitle("Рассчет расходов")
        }
    }
    
    func addItem() {
        let expensesValue = (Double(expenses) ?? 0.0)
        let roundedExpensesValue = (expensesValue * 10).rounded() / 10
        items.append(Item(name: itemName, expenses: roundedExpensesValue))
        itemName = ""
        expenses = ""
    }
    
    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

struct AddItemView: View {
    
    @Binding var itemName: String
    @Binding var expenses: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Добавьте участников")
                .font(.headline)
            
            HStack {
                
                TextField("Имя вашего участника", text: $itemName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Сумма", text: $expenses)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
            }
            
            Button("Добавить") {
                onAdd()
            }
            .padding(.horizontal)
            .background(Color.blue)
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue)
    }
}

struct SettlementResultsView: View {
    let items: [Item]
    let onDelete: (IndexSet) -> Void
    
    private var settlementsResults: [SettlementResult] {
        calculateSettlements()
    }
    
    private var allExpensesZero: Bool {
        settlementsResults.allSatisfy( { abs($0.amount) < 0.1 } )
    }
    
    var body: some View {
        VStack {
            SummaryView(items: items, results: settlementsResults)
            
            Text("Результаты")
                .font(.headline)
            
            ItemsListView(results: settlementsResults, onDelete: onDelete)
        }
    }
    
    private func calculateSettlements() -> [SettlementResult] {
        guard !items.isEmpty else { return [] }
        
        let totalExpenses = items.reduce(0) { $0 + $1.expenses }
        let averageExpensesPerPerson = totalExpenses / Double(items.count)
        
        return items.map { item in
            let amount = item.expenses - averageExpensesPerPerson
            let roundedAmount = (amount * 10).rounded() / 10
            return SettlementResult(item: item, amount: roundedAmount)
        }
    }
}

struct SummaryView: View {
    let items: [Item]
    let results: [SettlementResult]
    
    private var totalExpenses: Double {
        let total = items.reduce(0) { $0 + $1.expenses }
        return (total * 10).rounded() / 10
    }
    
    private var averageExpense: Double {
        guard !items.isEmpty else { return 0 }
        let average = totalExpenses / Double(items.count)
        return (average * 10).rounded() / 10
    }
    
    var body: some View {
        VStack {
            Text("Итоги")
                .font(.headline)
            
            HStack {
                VStack {
                    Text("Участников: \(items.count)")
                    
                    Text("Общие расходы: \(totalExpenses, specifier: "%.1f")")
                    
                    Text("На одного человека: \(averageExpense, specifier: "%.1f")")
                }
                .font(.subheadline)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ItemsListView: View {
    let results: [SettlementResult]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach (results) { result in
                SettlementRowView(result: result)
            }
            .onDelete(perform: onDelete)
        }
        .listStyle(PlainListStyle())
    }
}

struct SettlementRowView: View {
    let result: SettlementResult
    
    var body: some View {
        HStack {
            VStack {
                Text(result.item.name)
                    .font(.headline)
                Text("Потратил: \(result.item.expenses, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Text("\(result.formattedAmount)")
                .font(.headline)
                .foregroundColor(amountColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(amountColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
    
    private var amountColor: Color {
        if result.amount > 0 {
            return .green
        } else if result.amount < 0 {
            return .red
        } else {
            return .gray
        }
    }
}
#Preview {
    ContentView()
}
