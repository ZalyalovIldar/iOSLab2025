import SwiftUI
struct Person: Identifiable {
    let id = UUID()
    let name: String
    var amountSpent: Double
    var netBalance: Double = 0
}

struct ContentView: View {
    @State private var people: [Person] = []
    @State private var newPersonName = ""
    @State private var newAmount = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                Section("Добавить участника") {
                    HStack {
                        TextField("Имя", text: $newPersonName)
                            .autocapitalization(.words)
                            
                Spacer()
                            
                TextField("Сумма", text: $newAmount)
                    .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                            
                        Button("Добавить") {
                                addPerson()
                            }
                            .disabled(newPersonName.isEmpty || newAmount.isEmpty)
                        }
                    }
                    
                    if !people.isEmpty {
                        PeopleListView(people: $people, calculateBalances: calculateBalances)
                    } else {
                        ContentUnavailableView {
                            Label("Никто не добавлен", systemImage: "person.crop.circle.fill.badge.xmark")
                        } description: {
                            Text("Добавьте участников, чтобы начать делить расходы.")
                        }
                    }
                }
                
                Divider()
                
                TotalSummaryView(people: people)
            }
            .navigationTitle("Expense Splitter")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func addPerson() {
        guard let amount = Double(newAmount) else { return }
        
        let person = Person(name: newPersonName, amountSpent: amount)
        people.append(person)
        newPersonName = ""
        newAmount = ""
        calculateBalances()
    }
    
    private func calculateBalances() {
        guard !people.isEmpty else { return }
        
        let total = people.reduce(0) { $0 + $1.amountSpent }
        let average = total / Double(people.count)
        people = people.map { person in
            var p = person
            p.netBalance = average - person.amountSpent
            return p
        }
    }
}

struct PeopleListView: View {
    @Binding var people: [Person]
    var calculateBalances: () -> Void
    
    var body: some View {
        Section("Участники") {
        ForEach($people) { $person in
            HStack {
            Text(person.name)
                .font(.headline)
                Spacer()
                    Text("\(person.amountSpent, format: .currency(code: "RUB"))")
                        .foregroundColor(.secondary)
                    BalanceBadge(amount: person.netBalance)
                }
            }
            .onDelete { offsets in
                people.remove(atOffsets: offsets)
                calculateBalances()
            }
        }
    }
}

struct BalanceBadge: View {
    let amount: Double
    
    var body: some View {
        let isPositive = amount > 0
        
        Label(
            isPositive ? "Получит \(abs(amount), format: .currency(code: "RUB"))" : "Должен \(abs(amount), format: .currency(code: "RUB"))",
            systemImage: isPositive ? "arrow.down" : "arrow.up"
        )
        .labelStyle(.titleAndIcon)
        .padding(8)
        .font(.caption)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isPositive ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        )
        .foregroundColor(isPositive ? .green : .red)
    }
}

struct TotalSummaryView: View {
    let people: [Person]
    
    var total: Double {
        people.reduce(0) { $0 + $1.amountSpent }
    }
    
    var average: Double {
        people.isEmpty ? 0 : total / Double(people.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Всего потрачено:")
                .font(.headline)
            
            Text(total, format: .currency(code: "RUB"))
                .font(.title2)
                .fontWeight(.bold)
            
            if !people.isEmpty {
                Text("Каждый должен потратить: \(average, format: .currency(code: "RUB"))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    ContentView()
}
