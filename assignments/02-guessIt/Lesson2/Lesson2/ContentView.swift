//
//  ContentView.swift
//  Lesson2
//
//  Created by Timur Minkhatov on 16.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userInput: String = ""
    @State private var diceGameMessage: String = ""
    @State private var diceRoll = 0
    @State private var attempts = 0
    @State private var gameWon = false
    @State private var gameLost = false
    @State private var maxAttempts = 6
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var wins = 0
    @State private var losses = 0
    @State private var minValueText: String = ""
    @State private var maxValueText: String = ""
    @State private var gameStarted: Bool = false
    @State private var userMinValue: Int = 0
    @State private var userMaxValue: Int = 0
    
    enum Difficulty: String, CaseIterable {
        case easy = "Легкий"
        case medium = "Средний"
        case hard = "Сложный"
        
        var maxAttempts: Int {
            switch self {
            case .easy:
                return 6
            case .medium:
                return 5
            case .hard:
                return 4
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Ваша история игр")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 10) {
                Text("Победы: \(wins)")
                Text("Поражения: \(losses)")
            }
            
            Text("Выберите уровень")
                .font(.headline)
            
            Picker("Сложность", selection: $selectedDifficulty) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: selectedDifficulty) {
                maxAttempts = selectedDifficulty.maxAttempts
                resetGame()
            }
            
            Text("Выберите диапазон чисел для игры")
                .font(.headline)
            
            HStack {
                TextField("От", text: $minValueText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 80)
                    .disabled(gameStarted)
                            
                Text("до")
                        
                TextField("До", text: $maxValueText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 80)
                    .disabled(gameStarted)
                    
                Button("Установить") {
                    checkGameCondition()
                }
                .disabled(gameStarted)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(6)
            }
            .padding(.horizontal)

            Text("\(diceGameMessage)")
                .padding()
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(minHeight: 80)
            
            TextField(getRangeText(), text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)
                .disabled(!gameStarted || gameWon || gameLost)
            
            Button(gameStarted ? "Проверить число" : "Начать игру") {
                if gameStarted {
                    rollDice()
                } else {
                    startGame()
                }
            }
            .padding()
            .background(gameStarted ? Color.green : Color.green)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(gameWon || gameLost)
            
            if gameStarted {
                Text("Попыток использовано: \(attempts) из \(maxAttempts)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if gameWon || gameLost {
                Button("Новая игра") {
                    resetGame()
                }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }
    
    private func getRangeText() -> String {
        if !minValueText.isEmpty && !maxValueText.isEmpty {
            return "Угадай число от \(minValueText) до \(maxValueText)"
        } else {
            return "Установите диапазон чисел"
        }
    }
    
    private func checkGameCondition() {
        guard let minValue = Int(minValueText) else {
            diceGameMessage = "Введите корректное число для минимального диапазона."
            return
        }
        
        guard let maxValue = Int(maxValueText) else {
            diceGameMessage = "Введите корректное число для максимального диапазона."
            return
        }
        
        if maxValue <= minValue {
            diceGameMessage = "Максимальное число должно быть больше минимального."
            return
        }
        
        if maxValue - minValue < 1 {
            diceGameMessage = "Диапазон должен содержать хотя бы 2 числа."
            return
        }
        
        userMinValue = minValue
        userMaxValue = maxValue
        diceGameMessage = "Диапазон установлен: от \(minValue) до \(maxValue)"
    }
    
    private func startGame() {
        guard userMinValue != 0 && userMaxValue != 0 else {
            diceGameMessage = "Сначала установите корректный диапазон"
            return
        }
        
        diceRoll = Int.random(in: userMinValue...userMaxValue)
        gameStarted = true
        diceGameMessage = "Игра началась! Угадайте число от \(userMinValue) до \(userMaxValue)"
    }
    
    private func rollDice() {
        guard let userGuess = Int(userInput) else {
            diceGameMessage = "Введите корректное число для угадывания."
            return
        }
        
        guard userGuess >= userMinValue && userGuess <= userMaxValue else {
            diceGameMessage = "Введите число от \(userMinValue) до \(userMaxValue)."
            return
        }
        
        attempts += 1
        
        if userGuess == diceRoll {
            diceGameMessage = "Поздравляю, вы угадали число \(diceRoll)!"
            gameWon = true
            wins += 1
        } else if attempts >= maxAttempts {
            gameLost = true
            diceGameMessage = "Ходы закончились. Число было: \(diceRoll)."
            losses += 1
        } else if userGuess < diceRoll {
            diceGameMessage = "Число больше, чем вы написали. Осталось попыток: \(maxAttempts - attempts)"
        } else {
            diceGameMessage = "Число меньше, чем вы написали. Осталось попыток: \(maxAttempts - attempts) ответ \(diceRoll)" // убрать ответ
        }
    }
    
    private func resetGame() {
        userInput = ""
        diceGameMessage = ""
        attempts = 0
        gameWon = false
        gameLost = false
        maxAttempts = selectedDifficulty.maxAttempts
        gameStarted = false
        minValueText = ""
        maxValueText = ""
        userMinValue = 0
        userMaxValue = 0
    }
}

#Preview {
    ContentView()
}
