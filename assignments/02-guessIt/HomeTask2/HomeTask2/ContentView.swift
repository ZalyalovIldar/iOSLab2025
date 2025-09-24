//
//  ContentView.swift
//  HomeTask2
//


import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var randomNum = Int.random(in: 1...100)
    @State private var attemptsLeft = 7
    @State private var GameMessage = "Попробуй угадать число!!!"
    @State private var gameOver = false
    
    @State private var wins = 0
    @State private var loses = 0
    
    @State private var minRange: String = "1"
    @State private var maxRange: String = "100"
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue.opacity(0.9), .purple.opacity(0.9)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack() {
                Spacer()
                
                VStack(spacing: 17){
                    Text("Игра: Угадай число")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    HStack{
                        TextField("Мин", text: $minRange)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                        Text("-")
                        TextField("Макс", text: $maxRange)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                        
                        Button("Новая игра"){
                            newGame()
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    Text("Загадано число в выбранном диапазоне")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Ваш вариант", text: $userInput)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    Button("Проверить") {
                        checkGuess()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(gameOver ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(gameOver)
                    
                    Text(GameMessage)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.top, 8)

                    Text("Осталось попыток: \(attemptsLeft)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Divider()
                    
                    HStack {
                        Text("Победы: \(wins)")
                            .foregroundColor(.green)
                        Spacer()
                        Text("Поражения: \(loses)")
                            .foregroundColor(.red)
                    }
                    .font(.footnote)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }
    private func checkGuess() {
        
        guard let guess = Int(userInput) else {
            GameMessage = "Введите корректное число!"
            return
        }
        
        if gameOver { return }

        if guess == randomNum {
            GameMessage = "Победа!"
            gameOver = true
            wins += 1
        } else if guess < randomNum {
            GameMessage = "Число больше"
        } else {
            GameMessage = "Число меньше"
        }

        attemptsLeft -= 1
        if attemptsLeft == 0 && !gameOver {
            GameMessage = "Проигрыш(( Было \(randomNum)"
            gameOver = true
            loses += 1
        }
    }
    
    private func newGame() {
        
        guard let min = Int(minRange), let max = Int(maxRange), min < max else {
            GameMessage = "Введите корректный диапазон!"
            return
        }
        
        randomNum = Int.random(in: min...max)
        attemptsLeft = 7
        GameMessage = "Попробуй угадать число!"
        userInput = ""
        gameOver = false
    }
}

#Preview {
    ContentView()
}
