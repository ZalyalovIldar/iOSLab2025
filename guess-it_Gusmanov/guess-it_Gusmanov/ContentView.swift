import SwiftUI

struct ContentView: View {
    @State private var targetNumber = Int.random(in: 1...100)
    @State private var userGuess = ""
    @State private var message = "испытай себя"
    @State private var attempts = 0
    @State private var gameOver = false
    @State private var showAlert = false
    @State private var wins = 0
    @State private var losses = 0
    @State private var minRange = 1
    @State private var maxRange = 100
    @State private var showRangeSettings = false
    @State private var isSurrendered = false
    @State private var currentLanguage = "ru"
    
    var localizedStrings: [String: [String: String]] = [
        "ru": [
            "gameTitle": "игра угадай число",
            "testYourself": "испытай себя",
            "wins": "Победы",
            "losses": "Поражения",
            "attempt": "Попытка",
            "range": "Диапазон",
            "enterNumber": "Написать число",
            "check": "Проверить",
            "newGame": "Новая игра",
            "surrender": "Сдаться",
            "resetStats": "Сбросить статистику",
            "rangeSettings": "Настройки диапазона",
            "minNumber": "Минимальное число",
            "maxNumber": "Максимальное число",
            "currentRange": "Текущий диапазон",
            "quickSettings": "Быстрые настройки",
            "easy": "Легко",
            "medium": "Средне",
            "hard": "Сложно",
            "cancel": "Отмена",
            "save": "Сохранить",
            "victory": "Поздравляем!",
            "defeat": "Игра окончена",
            "error": "Ошибка",
            "victoryMessage": "Вы угадали число %d за %d попыток!",
            "defeatMessage": "Вы сдались... Загаданное число было: %d\nПопробуйте еще раз!",
            "errorMessage": "Пожалуйста, введите число от %d до %d",
            "numberError": "Число должно быть от %d до %d",
            "integerError": "Пожалуйста, введите целое число",
            "greater": "Больше! Попытка: %d",
            "less": "Меньше! Попытка: %d",
            "victoryEmoji": "🎉 Победа! Загаданное число: %d",
            "defeatEmoji": "😔 Вы сдались... Число было: %d"
        ],
        "en": [
            "gameTitle": "Guess the Number Game",
            "testYourself": "test yourself",
            "wins": "Wins",
            "losses": "Losses",
            "attempt": "Attempt",
            "range": "Range",
            "enterNumber": "Enter number",
            "check": "Check",
            "newGame": "New Game",
            "surrender": "Surrender",
            "resetStats": "Reset Statistics",
            "rangeSettings": "Range Settings",
            "minNumber": "Minimum number",
            "maxNumber": "Maximum number",
            "currentRange": "Current range",
            "quickSettings": "Quick settings",
            "easy": "Easy",
            "medium": "Medium",
            "hard": "Hard",
            "cancel": "Cancel",
            "save": "Save",
            "victory": "Congratulations!",
            "defeat": "Game Over",
            "error": "Error",
            "victoryMessage": "You guessed the number %d in %d attempts!",
            "defeatMessage": "You gave up... The hidden number was: %d\nTry again!",
            "errorMessage": "Please enter a number from %d to %d",
            "numberError": "Number must be between %d and %d",
            "integerError": "Please enter an integer",
            "greater": "Greater! Attempt: %d",
            "less": "Less! Attempt: %d",
            "victoryEmoji": "🎉 Victory! Hidden number: %d",
            "defeatEmoji": "😔 You gave up... Number was: %d"
        ]
    ]
    
    func localized(_ key: String) -> String {
        return localizedStrings[currentLanguage]?[key] ?? key
    }
    
    func localized(_ key: String, _ parameters: Int...) -> String {
        let format = localizedStrings[currentLanguage]?[key] ?? key
        return String(format: format, arguments: parameters.map { $0 as CVarArg })
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    LanguageSwitchView(currentLanguage: $currentLanguage)
                }
                .padding(.horizontal, 40)
                
                HStack {
                    VStack {
                        Text(localized("wins"))
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("\(wins)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(localized("losses"))
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("\(losses)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 40)
                
                Text(localized("gameTitle"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button(action: {
                    showRangeSettings.toggle()
                }) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("\(localized("range")): \(minRange)-\(maxRange)")
                    }
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Text("\(localized("attempt")): \(attempts)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text(message)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .frame(minHeight: 80)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                
                TextField(localized("enterNumber"), text: $userGuess)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: checkGuess) {
                    Text(localized("check"))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(userGuess.isEmpty || gameOver)
                
                HStack(spacing: 15) {
                    Button(action: startNewGame) {
                        Text(localized("newGame"))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: surrender) {
                        Text(localized("surrender"))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(gameOver)
                }
                .padding(.horizontal)
                
                Button(action: resetStats) {
                    Text(localized("resetStats"))
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $showRangeSettings) {
            AdvancedRangeSettingsView(
                minRange: $minRange,
                maxRange: $maxRange,
                isPresented: $showRangeSettings,
                currentLanguage: $currentLanguage,
                localized: localized,
                onSave: applyNewRange
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isSurrendered ? localized("defeat") : (gameOver ? localized("victory") : localized("error"))),
                message: Text(getAlertMessage()),
                dismissButton: .default(Text("OK")) {
                    if gameOver {
                        startNewGame()
                    }
                }
            )
        }
    }
    
    func getAlertMessage() -> String {
        if isSurrendered {
            return localized("defeatMessage", targetNumber)
        } else if gameOver {
            return localized("victoryMessage", targetNumber, attempts)
        } else {
            return localized("errorMessage", minRange, maxRange)
        }
    }
    
    func checkGuess() {
        guard let guess = Int(userGuess) else {
            message = localized("integerError")
            showAlert = true
            isSurrendered = false
            return
        }
        
        guard guess >= minRange && guess <= maxRange else {
            message = localized("numberError", minRange, maxRange)
            showAlert = true
            isSurrendered = false
            return
        }
        
        attempts += 1
        
        if guess == targetNumber {
            message = localized("victoryEmoji", targetNumber)
            gameOver = true
            wins += 1
            isSurrendered = false
            showAlert = true
        } else if guess < targetNumber {
            message = localized("greater", attempts)
        } else {
            message = localized("less", attempts)
        }
        
        userGuess = ""
    }
    
    func startNewGame() {
        targetNumber = Int.random(in: minRange...maxRange)
        userGuess = ""
        message = localized("testYourself")
        attempts = 0
        gameOver = false
        isSurrendered = false
        print("Новое число: \(targetNumber)")
    }
    
    func surrender() {
        message = localized("defeatEmoji", targetNumber)
        losses += 1
        gameOver = true
        isSurrendered = true
        showAlert = true
    }
    
    func applyNewRange() {
        if minRange >= maxRange {
            minRange = 1
            maxRange = 100
        }
        startNewGame()
    }
    
    func resetStats() {
        wins = 0
        losses = 0
        startNewGame()
    }
}

struct LanguageSwitchView: View {
    @Binding var currentLanguage: String
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                currentLanguage = "ru"
            }) {
                Text("RU")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(currentLanguage == "ru" ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(currentLanguage == "ru" ? .white : .black)
                    .cornerRadius(6)
            }
            
            Button(action: {
                currentLanguage = "en"
            }) {
                Text("EN")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(currentLanguage == "en" ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(currentLanguage == "en" ? .white : .black)
                    .cornerRadius(6)
            }
        }
    }
}

struct AdvancedRangeSettingsView: View {
    @Binding var minRange: Int
    @Binding var maxRange: Int
    @Binding var isPresented: Bool
    @Binding var currentLanguage: String
    let localized: (String) -> String
    let localizedWithParams: (String, Int...) -> String
    let onSave: () -> Void
    let rangePresets = [
        ("easy", 1, 50),
        ("medium", 1, 100),
        ("hard", 1, 200),
        ("expert", 1, 500),
        ("extreme", 1, 1000),
        ("custom", 0, 0)
    ]
    
    init(minRange: Binding<Int>, maxRange: Binding<Int>, isPresented: Binding<Bool>,
         currentLanguage: Binding<String>, localized: @escaping (String) -> String, onSave: @escaping () -> Void) {
        self._minRange = minRange
        self._maxRange = maxRange
        self._isPresented = isPresented
        self._currentLanguage = currentLanguage
        self.localized = localized
        self.localizedWithParams = { key, parameters in
            String(format: localized(key), arguments: parameters.map { $0 as CVarArg })
        }
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(localized("rangeSettings"))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            LanguageSwitchView(currentLanguage: $currentLanguage)
                .padding(.bottom, 10)

            VStack(spacing: 15) {
                VStack(alignment: .leading) {
                    Text(localized("minNumber"))
                        .font(.headline)
                    HStack {
                        TextField("", value: $minRange, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Stepper("", value: $minRange, in: 1...9999)
                            .labelsHidden()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(localized("maxNumber"))
                        .font(.headline)
                    HStack {
                        TextField("", value: $maxRange, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Stepper("", value: $maxRange, in: 2...10000)
                            .labelsHidden()
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            
            Text("\(localized("currentRange")): \(minRange)-\(maxRange)")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, 10)

            VStack(spacing: 10) {
                Text(localized("quickSettings"))
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(rangePresets, id: \.0) { preset in
                        if preset.0 != "custom" {
                            Button(action: {
                                minRange = preset.1
                                maxRange = preset.2
                            }) {
                                Text(localized(preset.0))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(getPresetColor(preset.0))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(localized("cancel")) {
                    isPresented = false
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(10)
                
                Button(localized("save")) {
                    onSave()
                    isPresented = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
    }
    
    func getPresetColor(_ preset: String) -> Color {
        switch preset {
        case "easy": return .green
        case "medium": return .blue
        case "hard": return .orange
        case "expert": return .red
        case "extreme": return .purple
        default: return .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
