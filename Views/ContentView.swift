//
//  ContentView.swift
//  OOPSwift
//
//  Created by krnklvx on 01.10.2025.
//

//import SwiftUI
//import Foundation
//
//struct Person: Identifiable, Codable { //из данных и в данные
//    let id = UUID()
//    var name: String
//    var amount: Double
//}
//
//struct ContentView: View {
//    
//    @State private var persons: [Person] = []
//    @State private var newName = ""
//    @State private var newAmount = ""
//    @State private var errorMessage: String = ""
//    @State private var showingExportSheet = false
//    @State private var showingImportSheet = false
//    @State private var jsonText = ""
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            Text("Делим-делим")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.top)
//            
//            eximportButtons
//                       .padding(.bottom)
//            
//            addPersonForm
//            
//            if !errorMessage.isEmpty {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            if persons.isEmpty {
//                emptyView
//            } else {
//                personListView
//                summaryView
//            }
//            Spacer()
//        }
//        .padding()
//        
//        .onAppear {
//            loadFromUserDefaults() // Загружаем данные при запуске приложения
//        }
//        .sheet(isPresented: $showingExportSheet) {
//            exportView // Показываем окно экспорта когда showingExportSheet = true
//        }
//        .sheet(isPresented: $showingImportSheet) {
//            importView // Показываем окно импорта когда showingImportSheet = true
//        }
//    }
//    
//    private var total: Double { //общая сумма
//        persons.reduce(0) {//начинаем с начального
//            $0 + $1.amount //$0 накопленная сумма (в начале 0) $1 текущий элемент.amount его значение
//        }
//    }
//    
//    private var average: Double {
//        guard !persons.isEmpty else { return 0 } //чтобы не поделить на 0
//        return total / Double(persons.count)
//    }
//    
//    private var debtors: [Person] { //должники
//        persons.filter {
//            $0.amount < average
//        }
//    }
//    
//    private var creditors: [Person] { //получатели
//        persons.filter {
//            $0.amount > average
//        }
//    }
//    
//    private func balanceMoney(for person: Person) -> Double {
//        person.amount - average //< должен > получит
//    }
//    
//    private func saveToUserDefaults() {
//        if let encoded = try? JSONEncoder().encode(persons) {
//            UserDefaults.standard.set(encoded, forKey: "savedPersons")
//        }
//    }
//    
//    private func loadFromUserDefaults() {
//        if let savedData = UserDefaults.standard.data(forKey: "savedPersons"),
//           let decoded = try? JSONDecoder().decode([Person].self, from: savedData) {
//            persons = decoded
//        }
//    }
//    
//    private func exportToJSON() {
//        if let jsonData = try? JSONEncoder().encode(persons),
//           let jsonString = String(data: jsonData, encoding: .utf8) {
//            jsonText = jsonString
//            showingExportSheet = true
//        }
//    }
//    
//    private func importFromJSON() {
//        guard let jsonData = jsonText.data(using: .utf8) else {
//            errorMessage = "Неверный формат JSON"
//            return
//        }
//        
//        do {
//            let importedPersons = try JSONDecoder().decode([Person].self, from: jsonData)
//            persons = importedPersons
//            saveToUserDefaults()
//            showingImportSheet = false
//            jsonText = ""
//            errorMessage = ""
//        } catch {
//            errorMessage = "Ошибка импорта: неверные данные"
//        }
//    }
//    
//    private var eximportButtons: some View {
//        HStack(spacing: 20) {
//            Button("Экспорт JSON") {
//                exportToJSON()
//            }
//            .padding()
//            .background(Color.green)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//            
//            Button("Импорт JSON") {
//                showingImportSheet = true
//            }
//            .padding()
//            .background(Color.orange)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//        .padding()
//    }
//    
//    private var exportView: some View {
//        NavigationView {
//            VStack {
//                Text("JSON данные для экспорта:")
//                    .font(.headline)
//                    .padding()
//                
//                TextEditor(text: $jsonText)
//                    .border(Color.gray)
//                    .padding()
//                
//                Button("Скопировать") {
//                    UIPasteboard.general.string = jsonText
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                
//                Spacer()
//            }
//            .navigationTitle("Экспорт")
//            .navigationBarItems(trailing: Button("Готово") {
//                showingExportSheet = false
//            })
//        }
//    }
//    
//    private var importView: some View {
//            NavigationView {
//                VStack {
//                    Text("Вставьте JSON данные:")
//                        .font(.headline)
//                        .padding()
//                    
//                    TextEditor(text: $jsonText)
//                        .border(Color.gray)
//                        .padding()
//                    
//                    Button("Импортировать") {
//                        importFromJSON()
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .disabled(jsonText.isEmpty)
//                    
//                    Spacer()
//                }
//                .navigationTitle("Импорт")
//                .navigationBarItems(trailing: Button("Отмена") {
//                    showingImportSheet = false
//                    jsonText = ""
//                })
//            }
//        }
//    
//    private func addPerson() {
//        let correctedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        guard !correctedName.isEmpty else { errorMessage = "Имя не может быть пустым"
//            return
//        }
//        
//        guard !persons.contains(where: { $0.name.lowercased() == correctedName.lowercased() }) else {
//                errorMessage = "Участник с таким именем уже существует"
//                return
//            }
//        
//        
//        let correctedAmount = newAmount.replacingOccurrences(of: ",", with: ".")
//        
//        guard let amount = Double(correctedAmount), amount > 0 else {
//            errorMessage = "Введите корректную сумму"
//            return
//        }
//        
//        guard amount >= 0 else {
//            errorMessage = "Сумма не может быть отрицательной"
//            return
//        }
//        
//        let newPerson = Person(name: correctedName, amount: amount)
//        persons.append(newPerson)
//        saveToUserDefaults()
//        
//        newName = ""
//        newAmount = ""
//        errorMessage = ""
//    }
//    
//    private func deletePerson(at offset: IndexSet) {
//        persons.remove(atOffsets: offset)
//    }
//    
//    private var addPersonForm: some View {
//        VStack(spacing: 15) {
//            Text("Добавить участника")
//                .font(.headline)
//            
//            HStack {
//                Text("Имя: ")
//                TextField("Введите имя", text: $newName)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            }
//            
//            HStack {
//                Text("Сумма: ")
//                TextField("Введите сумму", text: $newAmount)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            }
//            
//            Button(action: addPerson) {
//                Text("Добавить")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .clipShape(Capsule())
//                
//            }
//            .buttonStyle(.plain)
//            .disabled(newName.isEmpty || newAmount.isEmpty)
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
//    
//    private var emptyView: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "person.3")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            Text("Пупупу, никого нет(")
//                .font(.title2)
//                .fontWeight(.semibold)
//            
//            Text("Используй форму для добавления или импортируй данные")
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//        }
//        .padding()
//    }
//    
//    private var personListView: some View {
//        VStack {
//            Text("Список участников")
//                .font(.headline)
//                .padding(.bottom, 5)
//            
//            List {
//                ForEach(persons) { person in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(person.name)
//                                .font(.headline)
//                            
//                            Text("Потратил: \(person.amount, specifier: "%.2f")₽")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        Spacer()
//                        
//                        VStack(alignment: .trailing) {
//                            
//                            let personBalance = balanceMoney(for: person)
//                            
//                            Text("\(personBalance >= 0 ? "+" : "")\(personBalance, specifier: "%.2f")₽")
//                                .font(.headline)
//                                .foregroundColor(personBalance >= 0 ? .green: .red)
//                            
//                            Text(personBalance >= 0 ? "Получит": "Должен")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .padding(.vertical, 8)
//                }
//                .onDelete(perform: deletePerson)
//            }
//            .frame(height: 200)
//        }
//    }
//    
//    private var summaryView: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Итого: ")
//                .font(.headline)
//                .padding(.bottom, 5)
//            
//            HStack {
//            Text("Общая сумма:")
//                Spacer()
//                Text("\(total, specifier: "%.2f")")
//                    .fontWeight(.medium)
//            }
//                        
//            HStack {
//                Text("Средняя сумма:")
//                Spacer()
//                Text("\(average, specifier: "%.2f")")
//                    .fontWeight(.medium)
//            }
//                        
//            HStack {
//                Text("Участников:")
//                Spacer()
//                Text("\(persons.count) чел.")
//                    .fontWeight(.medium)
//            }
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
//}
//
//#Preview {
//    ContentView()
//}
