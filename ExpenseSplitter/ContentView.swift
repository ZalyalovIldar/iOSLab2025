//
//  ContentView.swift
//  ExpenseSplitter
//
//  Created by Azamat Zakirov on 30.09.2025.
//

import SwiftUI
import Charts
import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UserDefaults {
    private static let participantsKey = "participants"
    func saveParticipants(_ participants: [Participant]) {
        if let data = try? JSONEncoder().encode(participants) {
            set(data, forKey: UserDefaults.participantsKey)
        }
    }
    func loadParticipants() -> [Participant] {
        if let data = data(forKey: UserDefaults.participantsKey),
           let participants = try? JSONDecoder().decode([Participant].self, from: data) {
                return participants
        }
        return []
    }
}

struct Participant: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var expense: String
    var expenseInt: Int {
        Int(expense) ?? 0
    }
}


struct ContentView: View {
    @State private var participants: [Participant] = []
    @State private var total: Int = 0
    @State private var average: Int = 0
    var body: some View {
        NavigationView {
            VStack{
                AddNewParticipantView { newParticipant in
                    participants.append(newParticipant)
                }
                if participants.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("Нет участников", systemImage: "person.2.slash")
                        },
                        description: {
                            Text("Добавьте хотя бы отдного человека!")
                        },
                        actions: { EmptyView() }
                    )
                    .padding()
                } else {
                    List {
                        ForEach($participants) { $participant in
                            ParticipantRow(participant: $participant, average: average)
                        }
                        .onDelete(perform: deleteParticipants)
                    }
                }
                if total > 0 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Spacer(minLength: 40)
                            
                            Chart(participants) { participant in
                                SectorMark(
                                    angle: .value("Expense", participant.expenseInt),
                                    innerRadius: .ratio(0.4),
                                    angularInset: 1.0
                                )
                                .foregroundStyle(by: .value("Name", participant.name))
                                .annotation(position: .overlay) {
                                    Text(participant.name)
                                        .font(.caption2)
                                }
                            }
                            .frame(width: min(max(CGFloat(participants.count) * 40, 300),600), height: 200)
                            Spacer(minLength: 40)
                        }
                    }
                    
                
                }
                
            
                
                Button("Рассчитать"){
                    calculateTotal()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                if total > 0 {
                    Text("Итоговая сумма: \(total) ₽, средняя доля: \(average) ₽")
                }
                HStack {
                    Button("Экспорт JSON"){ exportToJSON()}
                        .buttonStyle(.bordered)
                        
                    Button("Импорт JSON"){
                        let url = FileManager.default.temporaryDirectory.appendingPathComponent("participants.json")
                        importFromJSON(url: url)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
                
            }
            .navigationTitle(Text("Разделение расходов"))
            
        }
        
        
        .onAppear {
            participants = UserDefaults.standard.loadParticipants()
            calculateTotal()
        }
        .onChange(of: participants) {
            UserDefaults.standard.saveParticipants(participants)
            calculateTotal()
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
    }
     private func exportToJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        if let data = try? encoder.encode(participants) {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("participants.json")
            do {
                try data.write(to: url)
                print("Файл-JSON успешно сохранён по адресу: \(url)")
            } catch {
                print("Ошибка при сохранении JSON: \(error)")
            }
        }
    }
    private func importFromJSON(url: URL) {
        if let data = try? Data(contentsOf: url),
            let imported = try? JSONDecoder().decode([Participant].self, from: data) {
            participants = imported
        }
    }
    
    private func calculateTotal() {
        total = participants.reduce(0) { sum, p in
            sum + (Int(p.expense) ?? 0)
        }
        average = participants.isEmpty ? 0 : total / participants.count
    }
    private func deleteParticipants(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
    }
}
struct AddNewParticipantView: View {
    @State private var name: String = ""
    var onAdd: (Participant) -> Void
    
    var body: some View {
        HStack {
            TextField("Имя", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                guard !name.isEmpty else { return }
                let newParticipant = Participant(name: name, expense: "")
                onAdd(newParticipant)
                name = ""
                
            }) {
                Image(systemName: "person.crop.circle.badge.plus.fill")
                    .font(.title2)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}
struct ParticipantRow: View {
    @Binding var participant: Participant
    var average: Int
    var body: some View {
        let expenseInt = Int(participant.expense) ?? 0
        let diff = expenseInt - average
        HStack {
            Text(participant.name)
                .fontWeight(.medium)
            Spacer()
            TextField("Cумма", text: $participant.expense)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)
                .onSubmit {
                    UIApplication.shared.hideKeyboard()
                }
                .frame(width: 100)
            if average > 0 {
                Text("\(diff >= 0 ? "+\(diff)" : "\(diff)") ₽")
                    .foregroundColor(diff >= 0 ? .green : .red)
                    .fontWeight(.semibold)
            }
            
        }
        .padding(.vertical, 5)
    }
}





#Preview {
    ContentView()
}

