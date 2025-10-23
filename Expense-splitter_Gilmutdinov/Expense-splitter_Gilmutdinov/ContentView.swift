import SwiftUI

class Person: Identifiable {
    let id = UUID()
    var name: String
    var spent: Double
    
    init(name: String, spent: Double) {
        self.name = name
        self.spent = spent
    }
}

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
            AddPersonView(newPerson: $newPerson, newSpent: $newSpent, onAdd: addPerson)
            PersonsListView(people: people, balanceText: balanceText, balanceColor: balanceColor, delete: deletePerson)
            StatisticsView(totalSpent: totalSpent, averageSpent: averageSpent)
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
        let formattedBalance = balance.formatted(.number.precision(.fractionLength(2)))
        if balance > 0 {
            return "+\(formattedBalance) ₽"
        } else if balance < 0 {
            return "\(formattedBalance) ₽"
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

struct AddPersonView: View {
    @Binding var newPerson: String
    @Binding var newSpent: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack {
            TextField("Имя друга", text: $newPerson)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Сумма", text: $newSpent)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Добавить") {
                onAdd()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct PersonsListView: View {
    let people : [Person]
    let balanceText: (Person) -> String
    let balanceColor: (Person) -> Color
    let delete: (IndexSet) -> Void
    
    var body: some View {
        VStack {
            if people.isEmpty {
                ContentUnavailableView("Нет участников",
                                       systemImage: "person.2.circlepath.circle",
                                       description: Text("Добавьте друзей чтобы разделить расходы"))
            } else {
                List {
                    ForEach(people) { person in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(person.name)
                                    .font(.headline)
                                Text("Потратил: \(person.spent, format: .number.precision(.fractionLength(2))) ₽")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.gray))
                            }
                            
                            Spacer()
                            
                            Text(balanceText(person))
                                .foregroundStyle(balanceColor(person))
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
        }
    }
}

struct StatisticsView: View {
    let totalSpent: Double
    let averageSpent: Double
    
    var body: some View {
        VStack {
            Text("Всего: \(totalSpent, format: .number.precision(.fractionLength(2))) ₽")
            Text("На человека: \(averageSpent, format: .number.precision(.fractionLength(2))) ₽")
        }
        .font(.headline)
        .padding()
    }
}
