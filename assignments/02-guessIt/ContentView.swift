//
//  ContentView.swift
//  homework2
//
//  Created by Анастасия on 21.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userInput: String = ""
    @State private var result: String = ""
    @State private var diceRoll: Int = Int.random(in: 1...100)
    @State private var replay: Int = 5
    @State private var wins: Int = 0
    @State private var loses: Int = 0
    @State private var selectedRange: Int = 100
    let ranges = [100, 200, 300, 400, 500, 600, 700, 800, 900]
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Угадай число)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)
            
            Picker("Выберите диапазон", selection: $selectedRange) {
                ForEach(ranges, id: \.self) { range in
                    Text("\(range)")
                }
            }
            
            Text("Диапазон: \(selectedRange)")
                .foregroundColor(Color.gray)
            
            Button("Проверить") {
                rollDice()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(replay == 0)
            
            Text("Результат: \(result)")
                .padding()
            
            Text("Осталось попыток: \(replay)")
                .foregroundColor(Color.gray)
            
            Text("Победы: \(wins) Проигрыши: \(loses)")
                .foregroundColor(Color.gray)
            
            
            if replay == 0 || result.contains("Верно! Загадано \(diceRoll)") {
                Button("Новая игра") {
                    newGame()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }
    
    private func rollDice() {
        
        guard let userGuess = Int(userInput) else {
            result = "Пожалуйста, введите число"
            return
        }
        if userGuess == diceRoll {
            result = "Верно! Загадано \(diceRoll)"
            wins += 1
        } else if userGuess < diceRoll {
            result = "Ошибка! Число больше заданного!"
            replay -= 1
        } else {
            result = "Ошибка! Число меньше заданного!"
            replay -= 1
        }
        if replay == 0 && userGuess != diceRoll {
            result = "Проигрыш! Загадано число \(diceRoll)"
            loses += 1
        }
    }
    private func newGame() {
        diceRoll = Int.random(in: 1...selectedRange)
        replay = 5
        userInput = ""
        result = ""
    }
}

#Preview {
    ContentView()
}
