// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var people: [Person] = []
    @State private var name: String = ""
    @State private var spend: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    TextField("Имя человека", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Сумма трат", text: $spend)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()
                
                Button("Добавить человека") {
                    addNewPerson()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || spend.isEmpty)
                
                if people.isEmpty {
                    Text("Список пуст")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(people, id: \.name) { person in
                            HStack {
                                Text(person.name)
                                Spacer()
                                Text(formatPersonSpendInfo(person: person))
                            }
                        }
                    }
                }
                
                Spacer()
                
                if !people.isEmpty {
                    Text("Средние траты: \(Person.splitter(personList: people), specifier: "%.2f") руб")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Учет трат")
        }
    }
    
    private func addNewPerson() {
        guard let amount = Int(spend) else { return }
        
        let newPerson = Person(name: name, spends: amount)
        people.append(newPerson)
        name = ""
        spend = ""
    }
    
    private func calculateDifference(for person: Person) -> Double {
        let averageSpend = Person.splitter(personList: people)
        return Double(person.spends) - averageSpend
    }
    
    private func formatPersonSpendInfo(person: Person) -> String {
        let difference = calculateDifference(for: person)
        let differenceString = String(format: "%.2f", difference)
        return "\(differenceString) руб / \(person.spends) руб"
    }
}

#Preview {
    ContentView()
}
