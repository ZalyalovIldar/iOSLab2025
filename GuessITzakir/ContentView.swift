import SwiftUI

enum Difficulty: String, CaseIterable {
    case easy = "Легкий"
    case medium = "Средний"
    case hard = "Сложный"
    
    var attemptsLimit: Int? {
        switch self {
        case .easy: return nil
        case .medium: return 10
        case .hard: return 5
        }
    }
}

struct GameRecord: Identifiable {
    let id = UUID()
    let secretNumber: Int
    let attempts: Int
    let won: Bool
    let difficulty: Difficulty
}

struct ContentView: View {
    @FocusState private var isInputActive: Bool
    
    @State private var userInput: String = ""
    @State private var diceGameMessage: Text = Text("")
    @State private var countOfAttempts: Int = 0
    @State private var start: String = "1"
    @State private var end: String = "100"
    @State private var secretNumber: Int = Int.random(in: 1...100)
    
    @State private var countWin: Int = 0
    @State private var countLose: Int = 0
    @State private var gameEnded: Bool = false
    @State private var haswon: Bool = false
    @State private var selectedDifficulty: Difficulty = .easy
    
    @State private var gameHistory: [GameRecord] = []

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    
                    Picker("Сложность", selection: $selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    
                    
                    HStack {
                        TextField("От", text: $start)
                            .keyboardType(.numberPad)
                            .focused($isInputActive)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .shadow(radius: 5)

                        TextField("До", text: $end)
                            .keyboardType(.numberPad)
                            .focused($isInputActive)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .shadow(radius: 5)

                    }
                    .padding(.horizontal)
                    
                    
                    Text("Guess It!")
                        .padding()
                        .bold()
                        .font(.title)
                    TextField("Введите число", text: $userInput)
                        .keyboardType(.numberPad)
                        .focused($isInputActive)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .shadow(radius: 5)
                        .frame(width: 200)
                        .disabled(gameEnded)
                        .padding(30)

                    
                    Button("Проверить") {
                        rollDice()
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 180, height: 50)
                    .background(Color.indigo)
                    .cornerRadius(45)
                    .shadow(radius: 10)
                    .disabled(gameEnded || userInput.isEmpty)
                    
                    VStack {
                        diceGameMessage
                            .padding()
                    }
                    Text("Попыток: \(countOfAttempts)")
                        .font(.title2)
                        .padding(10)
                    
                    
                    HStack(spacing: 40) {
                        Text("Побед: \(countWin)")
                            .foregroundColor(.green)
                            .font(.title3)
                            .bold()

                            
                        Text("Поражений: \(countLose)")
                            .foregroundColor(.red)
                            .font(.title3)
                            .bold()

                    }
                    .font(.headline)
                    
                    Spacer()
                }
                VStack {
                    Spacer()
                    
                    HStack {
                        NavigationLink(destination: StatisticsView(history: gameHistory)) {
                            Text("Статистика")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(Color.orange)
                                .cornerRadius(40)
                                .shadow(radius: 3)
                                .bold()

                        }
                        
                        Spacer()
                        
                        Button("Новая игра") {
                            restartGame()
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 60)
                        .background(Color.green)
                        .cornerRadius(40)
                        .shadow(radius: 3)
                        .bold()

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                
                
            }
            .padding()
            .onAppear { restartGame() }
            .onChange(of: start) { _ in restartGame() }
            .onChange(of: end) { _ in restartGame() }
            .onChange(of: selectedDifficulty) { _ in restartGame() }
        }
        .onTapGesture {
            isInputActive = false
            }
    }
    
    
    private func rollDice() {
        guard let userInputInt = Int(userInput) else {
            diceGameMessage = Text("Введите число.")
            return
        }
        guard let low = Int(start), let high = Int(end), low < high else {
            diceGameMessage = Text("Некорректный диапазон.")
            return
        }
        guard (low...high).contains(userInputInt) else {
            diceGameMessage = Text("Число должно быть в диапазоне \(low)-\(high).")
            return
        }
        
        countOfAttempts += 1
        
        if userInputInt == secretNumber {
            diceGameMessage =
                Text("Поздравляем! Вы угадали число ")
            + Text("\(secretNumber)").foregroundColor(.green).bold().font(.title2)
                + Text(" за \(countOfAttempts) попыток!")
            countWin += 1
            haswon = true
            gameEnded = true
        } else if userInputInt < secretNumber {
            diceGameMessage = Text("Загаданное число больше ") + Text("\(userInput).")
        } else {
            diceGameMessage = Text("Загаданное число меньше ") + Text("\(userInput).")
        }
        
        if let limit = selectedDifficulty.attemptsLimit,
           countOfAttempts >= limit,
           !haswon {
            diceGameMessage = Text("Вы исчерпали все \(limit) попыток. Загаданное число было \(secretNumber).")
            countLose += 1
            gameEnded = true
        }
        
        if gameEnded {
            let record = GameRecord(secretNumber: secretNumber,
                                    attempts: countOfAttempts,
                                    won: haswon,
                                    difficulty: selectedDifficulty)
            gameHistory.append(record)
        }
    }
    
    private func restartGame() {
        if !gameEnded && !haswon && countOfAttempts > 0 {
            countLose += 1
            
            let record = GameRecord(secretNumber: secretNumber,
                                    attempts: countOfAttempts,
                                    won: haswon,
                                    difficulty: selectedDifficulty)
            gameHistory.append(record)
        }
        
        guard let low = Int(start), let high = Int(end), low < high else {
            diceGameMessage = Text("Ошибка диапазона!")
            return
        }
        
        secretNumber = Int.random(in: low...high)
        diceGameMessage = Text("")
        countOfAttempts = 0
        userInput = ""
        haswon = false
        gameEnded = false
    }

}

struct StatisticsView: View {
    let history: [GameRecord]
    
    var body: some View {
        List(history.reversed()) { record in
            HStack {
                VStack(alignment: .leading) {
                    Text("Уровень: \(record.difficulty.rawValue)")
                    Text("Число: \(record.secretNumber)")
                    Text("Попытки: \(record.attempts)")
                }
                Spacer()
                Text(record.won ? "Победа" : "Поражение")
                    .foregroundColor(record.won ? .green : .red)
            }
            .padding(.vertical, 5)
        }
        .navigationTitle("История игр")
    }
}
#Preview {
    ContentView()
}

/// TODO:
/// Base
///1)Загадать число.✅
///2)Ввод числа пользователем..✅
///3)Подсказка «Больше/Меньше»..✅
///4)Счётчик попыток..✅
///5)Сообщение о результате..✅
///Plus
///1)Кнопка «Новая игра»..✅.
///2)Счётчик побед/поражений..✅
///3)Возможность выбрать диапазон чисел..✅
///Pro
///1)Настройки сложности (лёгкая/средняя/сложная).✅
///2)Экран статистики с историей игр.✅
///3)Локализация RU/EN.❌
