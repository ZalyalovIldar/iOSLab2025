//
//  ContentView.swift
//  Homework3
//
//  Created by Анастасия on 30.09.2025.
//

import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    let name: String
}

struct ContentView: View {
    
    @State private var personName: String = ""
    @State private var people: [Person] = []
    @State private var expenseText: String = ""
    @State private var expenses: [Double] = []
    
    var body: some View {
        VStack {
            AddPersoneView(personName: $personName, onAdd: addPerson)
            PeopleListView(people: people, onDelete: deletePerson)
            AddExpenseView(expenseText: $expenseText, onAdd: addExpense)
            ResultsView(people: people, expenses: expenses)
        }
        .padding()
    }
    
    func addPerson() {
        if !personName.isEmpty {
            people.append(Person(name: personName))
            personName = ""
        }
    }
    
    func deletePerson(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
        
    }
        
    func addExpense() {
        if people.isEmpty {
            return
        }
        if let expenseValue = Double(expenseText) {
            expenses.append(expenseValue)
            expenseText = ""
        }
    }
}

struct AddPersoneView: View {
    @Binding var personName: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                TextField("Новый участник", text: $personName)
                    .textFieldStyle(.roundedBorder)
                Button("Добавить") {
                    onAdd()
                }
                .frame(height: 33)
                .padding(.horizontal)
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
        }
    }
}

struct PeopleListView: View {
    let people: [Person]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            Section("Участники и их расходы") {
                ForEach(people) { person in
                    Text(person.name)
                }
                .onDelete(perform: onDelete)
            }
        }
    }
}

struct AddExpenseView: View {
    @Binding var expenseText: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack {
            TextField("Расходы по участникам:", text: $expenseText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            Button("Добавить") {
                onAdd()
            }
            .frame(height: 33)
            .padding(.horizontal)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
    }
}

struct ResultsView: View {
    let people: [Person]
    let expenses: [Double]
    
    var body: some View {
        List {
            Section("Расходы по участникам:") {
                if !expenses.isEmpty {
                    ForEach(expenses.indices, id: \.self) { index in
                        Text("\(expenses[index], specifier: "%.2f")")
                    }
                } else {
                    Text("Добавьте расходы")
                        .foregroundColor(.gray)
                }
            }
            
            Section("Кто кому должен:") {
                if people.count == expenses.count && !expenses.isEmpty {
                    let total = expenses.reduce(0, +)
                    let average = total / Double(people.count)
                    
                    ForEach(people.indices, id: \.self) { index in
                        let difference = expenses[index] - average
                        
                        if difference > 0 {
                            Text("\(people[index].name) должен(a) получить \(difference, specifier: "%.2f") ₽")
                                .foregroundColor(.green)
                        } else if difference < 0 {
                            Text("\(people[index].name) должен(a) отдать \(abs(difference), specifier: "%.2f") ₽")
                                .foregroundColor(.red)
                        } else {
                            Text("\(people[index].name) ничего не должен(a).")
                                .foregroundColor(.primary)
                        }
                    }
                } else {
                    if people.isEmpty && expenses.isEmpty{
                        ContentUnavailableView(
                            "Нет данных", systemImage: "person.2.slash", description: Text("Добавьте участников и расходы для расчета"))
                    } else if people.isEmpty {
                        ContentUnavailableView(
                            "Нет участников",
                            systemImage: "person.2.slash", description: Text("Добавьте участников для расчета"))
                    } else if expenses.isEmpty {
                        ContentUnavailableView(
                            "Нет расходов", systemImage: "minus.circle.fill", description: Text("Добавьте расходы для расчета"))
                    } else {
                        Text("Количество участников не совпадает с количеством расходов")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
