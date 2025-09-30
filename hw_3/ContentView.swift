import Foundation
import SwiftUI

struct Participant: Identifiable, Codable {
    var id: UUID
    var name: String
    var amountSpent: Double
    
    init(id: UUID = UUID(), name: String, amountSpent: Double = 0.0) {
        self.id = id
        self.name = name
        self.amountSpent = amountSpent
    }
}

final class SplitterViewModel: ObservableObject {
    @Published private var participantsDict: [UUID: Participant] = [:] {
        didSet {
            saveParticipants()
        }
    }
    
    private let participantsSaveKey = "participants"
    
    var participants: [Participant] {
        Array(participantsDict.values).sorted { $0.name < $1.name }
    }
    
    var totalAmount: Double {
        participantsDict.values.reduce(0) { $0 + $1.amountSpent }
    }
    
    var amountPerPerson: Double {
        participantsDict.isEmpty ? 0 : totalAmount / Double(participantsDict.count)
    }
    
    func getBalance(for participant: Participant) -> Double {
        participant.amountSpent - amountPerPerson
    }
    
    init() {
        loadParticipants()
    }
    
    func addParticipant(name: String, amountSpent: Double) {
        let participant = Participant(name: name, amountSpent: amountSpent)
        participantsDict[participant.id] = participant
    }
    
    func deleteParticipant(at offsets: IndexSet) {
        let sorted = participants
        for index in offsets {
            participantsDict.removeValue(forKey: sorted[index].id)
        }
    }
    
    private func saveParticipants() {
        if let encoded = try? JSONEncoder().encode(Array(participantsDict.values)) {
            UserDefaults.standard.set(encoded, forKey: participantsSaveKey)
        }
    }
    
    private func loadParticipants() {
        if let data = UserDefaults.standard.data(forKey: participantsSaveKey),
           let decoded = try? JSONDecoder().decode([Participant].self, from: data) {
            participantsDict = Dictionary(uniqueKeysWithValues: decoded.map { ($0.id, $0) })
        }
    }
    
    func exportToJSON() -> URL? {
        guard let data = try? JSONEncoder().encode(Array(participantsDict.values)) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("expenses.json")
        try? data.write(to: url)
        return url
    }
    
    func importFromURL(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }
        
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Participant].self, from: data) {
            participantsDict = Dictionary(uniqueKeysWithValues: decoded.map { ($0.id, $0) })
        }
    }
}

struct ContentView: View {
    @StateObject private var vm = SplitterViewModel()
    @State private var isAddingParticipant = false
    @State private var isImporting = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.participants.isEmpty {
                    EmptyStateView()
                } else {
                    ParticipantListView(vm: vm)
                }
            }
            .navigationTitle("Expense Splitter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    MenuView(
                        isImporting: $isImporting,
                        exportURL: vm.exportToJSON()
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { isAddingParticipant = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingParticipant) {
                AddParticipantView().environmentObject(vm)
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                if case .success(let url) = result {
                    vm.importFromURL(url)
                }
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "Нет участников",
            systemImage: "",
            description: Text("Нажмите '+', чтобы добавить первого участника.")
        )
    }
}

struct ParticipantListView: View {
    @ObservedObject var vm: SplitterViewModel
    
    var body: some View {
        List {
            SummarySection(totalAmount: vm.totalAmount, amountPerPerson: vm.amountPerPerson)
            ParticipantsSection(participants: vm.participants, vm: vm)
        }
    }
}

struct SummarySection: View {
    let totalAmount: Double
    let amountPerPerson: Double
    
    var body: some View {
        Section(header: Text("Итоги")) {
            SummaryRow(title: "Всего потрачено:", value: totalAmount)
            SummaryRow(title: "Средний чек на человека:", value: amountPerPerson)
        }
    }
}

struct SummaryRow: View {
    let title: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(String(format: "%.2f ₽", value)).bold()
        }
    }
}

struct ParticipantsSection: View {
    let participants: [Participant]
    @ObservedObject var vm: SplitterViewModel
    
    var body: some View {
        Section(header: Text("Участники")) {
            ForEach(participants) { participant in
                ParticipantRow(participant: participant, balance: vm.getBalance(for: participant))
            }
            .onDelete(perform: vm.deleteParticipant)
        }
    }
}

struct ParticipantRow: View {
    let participant: Participant
    let balance: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(participant.name).font(.headline)
                Text("Потратил: \(participant.amountSpent, specifier: "%.2f") ₽")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            BalanceView(balance: balance)
        }
        .padding(.vertical, 4)
    }
}

struct BalanceView: View {
    let balance: Double
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(String(format: "%.2f ₽", abs(balance)))
                .font(.headline)
                .foregroundColor(balanceColor)
            Text(balanceDescription)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var balanceDescription: String {
        if balance > 0.01 { return "Получает" }
        else if balance < -0.01 { return "Должен" }
        else { return "В расчёте" }
    }
    
    private var balanceColor: Color {
        if balance > 0.01 { return .green }
        else if balance < -0.01 { return .red }
        else { return .primary }
    }
}

struct MenuView: View {
    @Binding var isImporting: Bool
    let exportURL: URL?
    
    var body: some View {
        Menu {
            Button { isImporting = true } label: {
                Label("Импорт из файла", systemImage: "square.and.arrow.down")
            }
            if let url = exportURL {
                ShareLink(item: url, subject: Text("Мои расходы"), message: Text("Вот файл с нашими общими расходами.")) {
                    Label("Экспорт в файл", systemImage: "square.and.arrow.up")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

struct AddParticipantView: View {
    @EnvironmentObject var vm: SplitterViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var amountText = ""
    @FocusState private var isAmountFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Данные участника")) {
                    TextField("Имя", text: $name)
                    TextField("Потраченная сумма", text: $amountText)
                        .keyboardType(.decimalPad)
                        .focused($isAmountFieldFocused)
                }
                Section {
                    Button("Добавить") {
                        let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                        vm.addParticipant(name: name, amountSpent: amount)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Новый участник")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Готово") { isAmountFieldFocused = false }
                    }
                }
            }
        }
    }
}


@main
struct ExpenseSplitterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
