//
//  ContentView.swift
//  ExpenseSplitter
//
//  Created by Айнур on 28.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var name: String = ""
    @State private var sumText: String = ""
    @State private var members: [String: Double] = [:] // теперь словарь
    
    var totalSum: Double {
        members.values.reduce(0, +)
    }
    
    var avgSum: Double {
        guard !members.isEmpty else {
            return 0
        }
        return totalSum / Double(members.count)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            AddMemberView(
                name: $name,
                expenseText: $sumText,
                onAdd: addMember
            )
            
            MembersListView(
                members: members,
                avgSum: avgSum
            )
            
            if !members.isEmpty {
                Text("Общие расходы: \(totalSum, specifier: "%.2f") руб.")
                Text("Средний расход: \(avgSum, specifier: "%.2f") руб.")
            }
        }
        .padding()
    }
    
    func addMember() {
        guard !name.isEmpty, let expense = Double(sumText) else {
            return
        }
        members[name] = expense
        
        name = ""
        sumText = ""
    }
}

struct AddMemberView: View {
    @Binding var name: String
    @Binding var expenseText: String
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            TextField("Имя", text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(width: 120)
            
            TextField("Сумма", text: $expenseText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 120)
            
            Button("Добавить") { onAdd() }
                .frame(height: 35)
                .padding(.horizontal)
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct MembersListView: View {
    let members: [String: Double]
    let avgSum: Double
    
    var sortedMembers: [(key: String, value: Double)] {
        members.sorted { first, second in
            first.key < second.key
        }
    }
    
    var body: some View {
        List(sortedMembers, id: \.key) { name, sum in
            let diff = sum - avgSum

            HStack {
                Text(name)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(sum, specifier: "%.2f") руб.")
                        .foregroundColor(.gray)
                    Text(fixPlusAndMinus(for: diff))
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 5)
        }
    }
    
    private func fixPlusAndMinus(for diff: Double) -> String {
        if diff > 0 {
            return "+\(diff) руб."
        } else if diff < 0 {
            return "\(diff) руб."
        } else {
            return "0.00 руб."
        }
    }
}

#Preview {
    ContentView()
}

