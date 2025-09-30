//
//  ContentView.swift
//  guessIt
//
//  Created by Айнур on 16.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var result: String = ""
    @State private var attempts: Int = 5
    @State private var range1: String = ""
    @State private var range2: String = ""
    @State private var diceRoll: Int = 0
    @State private var wins: Int = 0
    @State private var losses: Int = 0
    @State private var maxAttempts: Int = 5
    
    var body: some View {
        Text("Выберите уроверь сложности")
            .padding(.horizontal)
            .font(.headline)
        
        VStack(spacing : 20) {
            
            HStack {
                Button("Легко") {
                    maxAttempts = 10
                    attempts = maxAttempts
                    startNewGame()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button("Средне") {
                    maxAttempts = 5
                    attempts = maxAttempts
                    startNewGame()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button("Сложно") {
                    maxAttempts = 3
                    attempts = maxAttempts
                    startNewGame()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Divider()
                .padding(.vertical, 10)
            
            Text("Выберите диапазон")
                .padding(.horizontal)
                .font(.headline)
            
            HStack {
                
                TextField("От", text: $range1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
                TextField("До", text: $range2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
            }
            
            TextField("Введите число от \(range1) до \(range2)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.numberPad)
                
            Button("Угадать число") {
                rollDice()
                userInput = ""
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.headline)
            
            Button("Новая игра") {
                wins = 0
                losses = 0
                startNewGame()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.headline)
        
            Text(result)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius:10))
            
            Divider()
                .padding(0)
            
            HStack(spacing: 40) {
                Text("Победы: \(wins)")
                    .font(.headline)
                    .padding()
                Text("Поражения: \(losses)")
                    .font(.headline)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius:10))
                
        }
        .padding()
    }
    func startNewGame() {
        guard let min = Int(range1), let max = Int(range2) else {
            result = "Неверный диапазон чисел"
            return
        }
        
        diceRoll = Int.random(in: min...max)
        result = "Новая игра! Угадайте число от \(min) до \(max). Кол-во попыток: \(maxAttempts)."
        userInput = ""
    }
    
    func rollDice() {
        guard let min = Int(range1), let max = Int(range2), min <= max else {
            result = "Неверный диапазон чисел"
            return
        }
        
        guard let userGuess = Int(userInput), userGuess >= min, userGuess <= max else {
            result = "Число вне диапазона от \(min) до \(max)!"
            return
        }
        
        if diceRoll == 0 {
            diceRoll = Int.random(in: min...max)
        }
        
        if userGuess < diceRoll {
            attempts -= 1
            if attempts == 0 {
                losses += 1
                result = "Вы проиграли! Было \(diceRoll)."
                diceRoll = 0
                attempts = maxAttempts
                return
            }
            
            result = "Больше, чем \(userGuess). Осталось попыток: \(attempts)."
            
        } else if userGuess > diceRoll {
            attempts -= 1
            if attempts == 0 {
                losses += 1
                result = "Вы проиграли! Было \(diceRoll)."
                diceRoll = 0
                attempts = maxAttempts
                return
            }
            
            result = "Меньше, чем \(userGuess). Осталось попыток: \(attempts)."
            
        } else {
            result = "Вы угадали! Было \(diceRoll)."
            wins += 1
            diceRoll = 0
            attempts = maxAttempts
        }
    }
}

#Preview {
    ContentView()
}
