import SwiftUI


@main
struct GuessItApp: App {
    @StateObject private var gvm = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(gvm)
        }
    }
}


enum RangeOption: String, CaseIterable, Identifiable {
    case r100, r500, r1000
    
    var id: String { rawValue }
    
    var max: Int {
        switch self {
        case .r100: return 100
        case .r500: return 500
        case .r1000: return 1000
        }
    }
    
    var range: ClosedRange<Int> { 1...max }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .r100: return "range.1_100"
        case .r500: return "range.1_500"
        case .r1000: return "range.1_1000"
        }
    }
}

struct GameRecord: Identifiable {
    let id = UUID()
    let target: Int
    let attemptsUsed: Int
    let win: Bool
    let difficulty: Difficulty
    let rangeMax: Int
}


final class GameViewModel: ObservableObject {
    // Настройки
    @Published var difficulty: Difficulty = .medium { didSet { newGame() } }
    @Published var rangeOption: RangeOption = .r100 { didSet { newGame() } }
    
    // Состояние игры
    @Published private(set) var targetNumber: Int = 0
    @Published private(set) var attemptsLeft: Int = 0
    @Published var guessText: String = ""
    @Published var hint: String?
    @Published private(set) var isGameOver: Bool = false
    @Published private(set) var isWin: Bool = false
    
    // Счётчики и история
    @Published private(set) var wins: Int = 0
    @Published private(set) var losses: Int = 0
    @Published private(set) var history: [GameRecord] = []
    
    init() { newGame() }
    
    var maxAttempts: Int { difficulty.maxAttempts }
    var range: ClosedRange<Int> { rangeOption.range }
    
    func newGame() {
        targetNumber = Int.random(in: range)
        attemptsLeft = maxAttempts
        guessText = ""
        hint = nil
        isGameOver = false
        isWin = false
    }
    
    func makeGuess() {
        guard !isGameOver else { return }
        
        guard let guess = Int(guessText.trimmingCharacters(in: .whitespaces)) else {
            hint = String(localized: "error.not_number")
            return
        }
        guard range.contains(guess) else {
            hint = String(localized: "error.out_of_range range.lowerBound range.upperBound")
            return
        }
        
        attemptsLeft -= 1
        
        if guess == targetNumber {
            finishGame(win: true)
            hint = String(localized: "result.win_hint")
            return
        }
        
        // Подсказки Больше/Меньше
        if guess < targetNumber {
            hint = String(localized: "hint.higher") // Загаданное больше
        } else {
            hint = String(localized: "hint.lower")  // Загаданное меньше
        }
        
        if attemptsLeft == 0 {
            finishGame(win: false)
        }
    }
    
    private func finishGame(win: Bool) {
        isGameOver = true
        isWin = win
        
        if win { wins += 1 } else { losses += 1 }
        
        let attemptsUsed = maxAttempts - attemptsLeft
        
        let record = GameRecord(
            target: targetNumber,
            attemptsUsed: attemptsUsed,
            win: win,
            difficulty: difficulty,
            rangeMax: rangeOption.max
        )
        history.insert(record, at: 0)
    }
    
    func clearHistory() {
        history.removeAll()
        wins = 0
        losses = 0
    }
}


enum Difficulty: String, CaseIterable, Identifiable {
    case easy, medium, hard
    
    var id: String { rawValue }
    
    var maxAttempts: Int {
        switch self {
        case .easy: return 10
        case .medium: return 7
        case .hard: return 5
        }
    }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .easy: return "difficulty.easy"
        case .medium: return "difficulty.medium"
        case .hard: return "difficulty.hard"
        }
    }
}


struct GameView: View {
    @EnvironmentObject private var gvm: GameViewModel
    @State private var showSettings = false
    @State private var showStats = false
    @State private var showEndAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                                CounterBadge(title: String(localized: "wins"), value: gvm.wins, color: .green)
                                CounterBadge(title: String(localized: "losses"), value: gvm.losses, color: .red)
                            }
                
                // Ввод числа
                VStack(alignment: .leading, spacing: 8) {
                    Text("enter_number \(gvm.range.lowerBound) \(gvm.range.upperBound)")
                        .font(.headline)
                    
                    HStack {
                        TextField("placeholder.enter", text: $gvm.guessText)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit { gvm.makeGuess() }
                        
                        Button {
                            gvm.makeGuess()
                        } label: {
                            Text("guess")
                                .bold()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .disabled(gvm.isGameOver)
                
                if let hint = gvm.hint {
                                Text(hint)
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.blue)
                            }
                
                // Осталось попыток
                HStack {
                    Text("attempts_left")
                    Spacer()
                    Text("\(gvm.attemptsLeft)/\(gvm.maxAttempts)")
                        .monospacedDigit()
                        .bold()
                }
                
                ProgressView(value: Double(gvm.maxAttempts - gvm.attemptsLeft), total: Double(gvm.maxAttempts))
                                .tint(.blue)
                
                Button {
                    gvm.newGame()
                } label: {
                    Label("new_game", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button {
                                showStats = true
                            } label: {
                                Image(systemName: "chart.bar")
                            }
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                            .presentationDetents([.medium])
                    }
                    .sheet(isPresented: $showStats) {
                        StatsView()
                    }
                    .onChange(of: gvm.isGameOver) { _, newValue in
                        if newValue { showEndAlert = true }
                    }
            .alert(isPresented: $showEndAlert) {
                let titleKey: LocalizedStringKey = gvm.isWin ? "result.win_title" : "result.lose_title"
                
                let message: Text = gvm.isWin
                    ? Text("result.you_found \(gvm.targetNumber)")
                    : Text("result.was \(gvm.targetNumber)")
                
                return Alert(
                    title: Text(titleKey),
                    message: message,
                    dismissButton: .default(Text("ok"))
                )
            }
            .navigationTitle("app.title")
        }
    }
}


struct CounterBadge: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.title2.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(color.opacity(0.12), in: Capsule())
        }
    }
}


struct SettingsView: View {
    @EnvironmentObject private var gvm: GameViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(String(localized: "section.difficulty"))) {
                    Picker(String(localized: "difficulty"), selection: $gvm.difficulty) {
                        ForEach(Difficulty.allCases) { dif in
                            Text(dif.localizedName).tag(dif)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text(String(localized: "section.range"))) {
                    Picker(String(localized: "range"), selection: $gvm.rangeOption) {
                        ForEach(RangeOption.allCases) { ran in
                            Text(ran.localizedName).tag(ran)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button(role: .destructive) {
                        gvm.clearHistory()
                    } label: {
                        Label(String(localized: "clear_history"), systemImage: "trash")
                    }
                }
            }
            .navigationTitle(String(localized: "settings"))
        }
    }
}


struct StatsView: View {
    @EnvironmentObject private var gvm: GameViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if gvm.history.isEmpty {
                    ContentUnavailableView(
                        "stats.empty.title",
                        systemImage: "tray",
                        description: Text("stats.empty.subtitle")
                    )
                } else {
                    List(gvm.history) { rec in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(rec.win ? "result.win_short" : "result.lose_short")
                                    .font(.headline)
                                    .foregroundStyle(rec.win ? .green : .red)
                                Spacer()
                            }
                            
                            HStack {
                                Label { Text("\(rec.target)") } icon: { Image(systemName: "target") }
                                Spacer()
                                Label { Text("\(rec.attemptsUsed)") } icon: { Image(systemName: "number.circle") }
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                            HStack {
                                Label {
                                    Text(rec.difficulty.localizedName)
                                } icon: { Image(systemName: "speedometer") }
                                Spacer()
                                Label { Text("1...\(rec.rangeMax)") } icon: { Image(systemName: "number") }
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("stats")
        }
    }
}


#Preview {
    @StateObject var gvm = GameViewModel()
    
    GameView()
        .environmentObject(gvm)
}
