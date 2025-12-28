//  ContentView.swift
//  divider
//


import SwiftUI

struct OnePeople: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var spent: Double
}

struct ContentView: View {
    @State private var all: [OnePeople] = []
    @State private var name_in: String = ""
    @State private var spent_in: String = ""
    @State private var json_on = false
    @State private var json_text: String = ""
    private let Key = "all"
    
    private func save(){
        let data = try? JSONEncoder().encode(all)
        UserDefaults.standard.set(data, forKey: Key)
    }
    
    private func load(){
        guard let data = UserDefaults.standard.data(forKey: Key),
            let saved = try? JSONDecoder().decode([OnePeople].self, from: data)
        else { return }
        all = saved
    }
    
    private func json_export(){
        guard let data = try? JSONEncoder().encode(all),
              let text = String(data: data, encoding: .utf8)
        else { return }
        json_text = text
        json_on = true
    }
    private func json_import(){
        if let data = json_text.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([OnePeople].self, from: data){
            all = decoded
        }
    }
    
    private var all_spent: Double {
        var sum: Double = 0
        for one in all {
            sum += one.spent
        }
        return sum
    }
    
    private var avg_spent: Double {
        all.isEmpty ? 0 : (all_spent / Double(all.count))
    }
    private func gett(_ one: OnePeople) -> Double {
        return one.spent - avg_spent
    }
    
    private func newPeople() {
        guard !name_in.isEmpty, let s = Double(spent_in) else { return }
        all.append(OnePeople(name: name_in, spent: s))
        name_in = ""
        spent_in = ""
    }
    private func delete(at offsets: IndexSet){
        all.remove(atOffsets: offsets)
    }
    
    var body: some View{
        VStack(spacing: 16){
            Add(name_in: $name_in, spent_in: $spent_in, onAdd: newPeople)
            Summary(avg_spent: avg_spent, all_spent: all_spent)

            if all.isEmpty{
                Image(systemName: "person.3")
                            .font(.system(size: 45))
                            .foregroundStyle(.secondary)
                            .padding(.top, 40)

                Text("Список пока пустой")
                    .font(.title3)
                    .fontWeight(.semibold)
            } else{
                List{
                    ForEach(all){
                        one in
                        Person(one: one, balance: gett(one))
                    }
                    .onDelete(perform: delete)
                }
            }
            Spacer()
        }
        HStack {
            Button("Экспорт JSON") { json_export() }
            Button("Импорт JSON") { json_on = true }
        }
        .buttonStyle(.bordered)
        .onAppear(perform: load)
        .sheet(isPresented: $json_on) {
            VStack(spacing: 12) {
                Text("JSON")
                    .font(.headline)
                
                TextEditor(text: $json_text)
                    .border(.secondary)
                
                HStack {
                    Button("Закрыть") { json_on = false }
                    Button("Импорт") { json_import(); json_on = false }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onChange(of: all){_ in save()}
        .padding()
    }
}

struct Person: View {
    let one: OnePeople
    let balance: Double
    var body: some View{
        HStack{
            Text(one.name)
            Spacer()
            Text(String(format: "%.2f", balance))
                .foregroundColor(balance > 0 ? .green : .red)
        }
    }
}
    
struct Add: View{
    @Binding var name_in: String
    @Binding var spent_in: String
    let onAdd: () -> Void
    var body: some View{
        VStack(spacing: 16){
            TextField("Имя", text: $name_in)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Сумма", text: $spent_in)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            
            Button("Добавить", action: onAdd)
                .buttonStyle(.borderedProminent)
            
        }
        .padding()
    }
}

struct Summary: View{
    let avg_spent: Double
    let all_spent: Double
    var body: some View{
        VStack(alignment: .leading, spacing: 8){
            Text("Итого: \(String(format: "%.2f", all_spent))")
            Text("Среднее: \(String(format: "%.2f", avg_spent))")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


#Preview {
    ContentView()
}
