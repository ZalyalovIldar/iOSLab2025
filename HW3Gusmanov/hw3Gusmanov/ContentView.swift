import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Список участников пуст")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Добавьте первого человека, используя форму выше")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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
                    EmptyStateView()
                } else {
                    List {
                        ForEach(people, id: \.name) { person in
                            HStack {
                                Text(person.name)
                                    .fontWeight(.medium)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(person.spends) руб")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Button(action: {
                                    delete(person)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                            .background(person.findColor(personList: people).opacity(0.1))
                            .cornerRadius(2)
                        }
                    }
                }
                
                Spacer()
                
                if !people.isEmpty {
                    VStack(spacing: 8) {
                        Text("Средние траты: \(Person.splitter(personList: people), specifier: "%.2f") руб")
                            .font(.headline)
                    }
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

    private func delete(_ person: Person) {
        if let i = people.firstIndex(where: { element in element.name == person.name}) {
            people.remove(at: i)
        }
    }
}
#Preview {
    EmptyStateView()
}
