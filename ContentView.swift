//
//  ContentView.swift
//  
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI

struct ContentView: View {
    
    @State private var userInput: String = ""
    @State private var diceGameMessage: String = ""
    @State private var targetNumber: Int = Int.random(in: 1...100)
    @State private var remainingAttempts: Int = 5
    @State private var isGameOver: Bool = false
    
    @State private var minRange: Int = 1
    @State private var maxRange: Int = 100
    @State private var wins: Int = 0
    @State private var losses: Int = 0
    @State private var history: [String] = []
    
    @State private var difficulty: String = "Лёгкая"
    @State private var language: String = "ru"
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(localized("guessNumber"))
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Picker(localized("difficulty"), selection: $difficulty) {
                Text(localized("easy")).tag("Лёгкая")
                Text(localized("medium")).tag("Средняя")
                Text(localized("hard")).tag("Сложная")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: difficulty) { _ in
                confirmRange()
            }
            
            Button("\(language.uppercased())") {
                language = (language == "ru") ? "en" : "ru"
            }
            .padding()
            
            HStack {
                TextField(localized("min"), value: $minRange, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 80)
                
                TextField(localized("max"), value: $maxRange, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 80)
            }
            .padding(.horizontal)
            
            Button(localized("confirmRange")) {
                confirmRange()
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundStyle(.indigo)
            
            Divider()
                .padding()
            
            TextField("\(localized("enterNumber")) \(minRange)-\(maxRange)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)
            
            Button(localized("check")) {
                rollDice()
            }
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("\(diceGameMessage)")
                .padding()
            
            Divider()
            
            VStack {
                Text("\(localized("attemptsLeft")): \(remainingAttempts)")
                    .padding()
                
                if isGameOver {
                    Text(localized("gameOver"))
                    
                    Button(localized("newGame")) {
                        resetGame()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                HStack {
                    Text("\(localized("wins")): \(wins)")
                    Text("\(localized("losses")): \(losses)")
                }
                .font(.subheadline)
                
                Text(localized("history"))
                    .font(.headline)
                ScrollView {
                    ForEach(history.reversed(), id: \.self) { entry in
                        Text(entry)
                    }
                }
                .frame(height: 100)
            }
        }
        .padding()
    }
    
    
    private func rollDice() {
        guard let userGuess = Int(userInput) else {
            diceGameMessage = localized("enterValidNumber")
            return
        }
        
        guard (minRange...maxRange).contains(userGuess) else {
            diceGameMessage = "\(localized("numberInRange")) \(minRange)-\(maxRange)."
            return
        }
        
        remainingAttempts -= 1
        
        if userGuess == targetNumber {
            diceGameMessage = "\(localized("congrats")) \(targetNumber)!"
            wins += 1
            history.append("\(localized("win")) \(targetNumber)")
            isGameOver = true
        } else if remainingAttempts == 0 {
            diceGameMessage = "\(localized("lost")) \(targetNumber)."
            losses += 1
            history.append("\(localized("loss")) \(targetNumber)")
            isGameOver = true
        } else if userGuess < targetNumber {
            diceGameMessage = localized("higher")
        } else {
            diceGameMessage = localized("lower")
        }
        
        userInput = ""
    }
    
    private func resetGame() {
        targetNumber = Int.random(in: minRange...maxRange)
        userInput = ""
        diceGameMessage = "\(localized("guessNumber")) \(minRange)-\(maxRange)"
        remainingAttempts = difficultyAttempts()
        isGameOver = false
    }
    
    private func confirmRange() {
        if minRange < 1 {
            minRange = 1
            diceGameMessage = localized("minOne")
            return
        }
        
        if maxRange > 10000 {
            maxRange = 10000
            diceGameMessage = localized("maxLimit")
            return
        }
        
        if minRange >= maxRange {
            diceGameMessage = localized("wrongRange")
            return
        }
        
        remainingAttempts = difficultyAttempts()
        resetGame()
    }
    
    private func difficultyAttempts() -> Int {
        switch difficulty {
        case "Лёгкая":
            return 5
        case "Средняя":
            return 5
        case "Сложная":
            return 3
        default:
            return 5
        }
    }
    
    private func localized(_ key: String) -> String {
           let dict: [String: [String: String]] = [
               "guessNumber": ["ru": "Угадай число", "en": "Guess the number"],
               "difficulty": ["ru": "Сложность", "en": "Difficulty"],
               "easy": ["ru": "Лёгкая", "en": "Easy"],
               "medium": ["ru": "Средняя", "en": "Medium"],
               "hard": ["ru": "Сложная", "en": "Hard"],
               "min": ["ru": "Мин", "en": "Min"],
               "max": ["ru": "Макс", "en": "Max"],
               "confirmRange": ["ru": "Подтвердить диапазон", "en": "Confirm range"],
               "enterNumber": ["ru": "Введите число от", "en": "Enter number from"],
               "check": ["ru": "Проверить удачу", "en": "Check"],
               "attemptsLeft": ["ru": "Осталось попыток", "en": "Attempts left"],
               "gameOver": ["ru": "Игра окончена", "en": "Game over"],
               "newGame": ["ru": "Новая игра", "en": "New game"],
               "wins": ["ru": "Победы", "en": "Wins"],
               "losses": ["ru": "Поражения", "en": "Losses"],
               "history": ["ru": "История игр", "en": "History"],
               "enterValidNumber": ["ru": "Введите корректное число", "en": "Enter valid number"],
               "numberInRange": ["ru": "Число должно быть в диапазоне", "en": "Number must be in range"],
               "congrats": ["ru": "Поздравляем! Вы угадали число", "en": "Congrats! You guessed"],
               "lost": ["ru": "К сожалению, вы не угадали. \n Выпало число", "en": "You lost! Number was"],
               "higher": ["ru": "Больше! Попробуй ещё раз.", "en": "Higher! Try again."],
               "lower": ["ru": "Меньше! Попробуй ещё раз.", "en": "Lower! Try again."],
               "minOne": ["ru": "Минимум не может быть меньше 1.", "en": "Min cannot be less than 1."],
               "maxLimit": ["ru": "Максимум ограничен числом 10 000.", "en": "Max limited to 10,000."],
               "wrongRange": ["ru": "Ошибка: мин >= макс", "en": "Error: min >= max"],
                "win": ["ru": "Победа", "en": "Won"],
                "loss": ["ru": "Поражение", "en": "Loss"]
        ]
        
           return dict[key]?[language] ?? key
       }
   }

#Preview {
    ContentView()
}
