//
//  ContentView.swift
//  Splitter
//
//  Created by Иван Метальников on 29.09.2025.
//

import SwiftUI


struct Person: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double = 0
}

struct ContentView: View {
    @State var fieldPersonName: String = ""
    @State var persons: [Person] = []
    
    var bankAmount: Int {
        return Int(persons.reduce(0) { $0 + $1.amount })
    }

    var body: some View {
        VStack {
            Text("Пропито: \(bankAmount) руб.")
                .font(.title)
            InputPerson(fieldPersonName: $fieldPersonName, persons: $persons)
            PersonsList(persons: $persons)
        }
        .padding()
    }
}

struct InputPerson: View {
    @Binding var fieldPersonName: String
    @Binding var persons: [Person]
    
    var body: some View {
        HStack {
            TextField("Введите человека:",
                      text: $fieldPersonName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Добавить") {
                addPerson()
            }
            .padding()
            .frame(height: 30)
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .clipShape(.capsule)
        }
    }
    
    func addPerson() {
        if !fieldPersonName.isEmpty {
            let newPerson = Person(name: fieldPersonName)
            persons.append(newPerson)
            fieldPersonName = ""
        }
    }
}

struct PersonsList: View {
    @Binding var persons: [Person]
    
    var body: some View {
        List {
            ForEach($persons) { $person in
                PersonRow(persons: $persons, person: $person) {
                    getNeedBankDeposit(person: person)
                }
            }
        }
        .overlay {
            if persons.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
    
    func getNeedBankDeposit(person: Person) -> Int {
        let totalSpend = persons.reduce(0) { $0 + $1.amount }
        let needSpendForPerson = persons.isEmpty ? 0 : totalSpend / Double(persons.count)
        return Int(needSpendForPerson - person.amount)
    }
}

struct PersonRow: View {
    @Binding var persons: [Person]
    @Binding var person: Person
    @State private var showSheet = false
    
    var need: () -> Int

    
    private var diff: Int { need() }
    
    private var amountText: String {
        if diff == 0 {
            return "Все в порядке"
        } else if diff > 0 {
            return "Внести: \(diff) руб."
        } else {
            return "Забрать: \(-diff) руб."
        }
    }
    
    private var amountColor: Color? {
        if diff == 0 {
            return nil
        } else {
            return diff > 0 ? .red : .green
        }
    }
    
    var body: some View {
        Button { showSheet = true } label: {
            HStack {
                Text(person.name)
                Spacer()
                if let color = amountColor {
                    Text(amountText)
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(color)
                        .clipShape(.capsule)
                } else {
                    Text(amountText)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            InputPersonSheet(persons: $persons, sheetPerson: $person, showSheet: $showSheet)
        }
    }
}

struct InputPersonSheet: View {
    @Binding var persons: [Person]
    @Binding var sheetPerson: Person
    @Binding var showSheet: Bool
    @State var newAmount: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text(sheetPerson.name)
                .font(.title)
            HStack {
                TextField("Добавить оплату: ", text: $newAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                Button("OK") {
                    if let amount = Double(newAmount) {
                        sheetPerson.amount += amount
                        newAmount = ""
                        showSheet = false
                    }
                }
                .padding()
                .frame(height: 30)
                .background(Color.blue)
                .foregroundStyle(Color.white)
                .clipShape(.capsule)
            }.padding(.bottom, 20)
            
            Button("Удалить") {
                if let index = persons.firstIndex(where: { $0.id == sheetPerson.id }) {
                    _ = persons.remove(at: index)
                    showSheet = false
                }
            }
            .padding()
            .frame(height: 50)
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .clipShape(.capsule)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
