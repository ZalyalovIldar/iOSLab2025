import SwiftUI

struct ContentView: View {
    
    @State private var people: [Person] = []
    @State private var newPerson = ""
    @State private var newSpent = ""
    
    var totalSpent: Double {
        var sum = 0.0
        for person in people {
            sum += person.spent
        }
        return sum
    }
    
    var averageSpent: Double {
        if people.isEmpty {
            return 0
        } else {
            return totalSpent / Double(people.count)
        }
    }
    
    var body: some View {
            VStack {
                VStack {
                    TextField("Имя друга", text: $newPerson)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Сумма", text: $newSpent)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Добавить") {
                        addPerson()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                // Статистика
                VStack {
                    Text("Всего: \(totalSpent, specifier: "%.2f") ₽")
                    Text("На человека: \(averageSpent, specifier: "%.2f") ₽")
                }
                .font(.headline)
                .padding()
                
                if people.isEmpty {
                    ContentUnavailableView(
                        "Нет участников",
                        systemImage: "person.2.circlepath.circle",
                        description: Text("Добавьте друзей чтобы разделить расходы")
                    )
                } else {
                    List {
                        ForEach(people) { person in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(person.name)
                                        .font(.headline)
                                    Text("Потратил: \(person.spent, specifier: "%.2f") ₽")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text(balanceText(for: person))
                                    .foregroundColor(balanceColor(for: person))
                            }
                        }
                        .onDelete(perform: deletePerson)
                    }
                }
            }
            .navigationTitle("Дележ расходов")
        }
        
        func addPerson() {
            if let amount = Double(newSpent) {
                let person = Person(name: newPerson, spent: amount)
                people.append(person)
                newPerson = ""
                newSpent = ""
            }
        }
        
        func deletePerson(at offsets: IndexSet) {
            people.remove(atOffsets: offsets)
        }
        
        func balanceText(for person: Person) -> String {
            let balance = person.spent - averageSpent
            if balance > 0 {
                return "+\(balance, default: "%.2f") ₽"
            } else if balance < 0 {
                return "\(balance, default: "%.2f") ₽"
            } else {
                return "0 ₽"
            }
        }
        
        func balanceColor(for person: Person) -> Color {
            let balance = person.spent - averageSpent
            if balance > 0 {
                return .green
            } else if balance < 0 {
                return .red
            } else {
                return .blue
            }
        }
    }
