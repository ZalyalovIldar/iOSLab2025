//
//  ContentView.swift
//  GuessIt
//
//  Created by Artur Bagautdinov on 22.09.2025.
//

import SwiftUI

struct GameView: View {
    
    @State private var userInput: String = ""
    @State private var gameMessage: String = ""
    @State private var currentAttempt: Int = 1
    @State var maxAttempts: Int
    @State private var targetNumb: Int = 0
    @State private var showingResult = false
    @State private var gameResult: GameResult?
    @State private var shouldCloseToStart = false
    
    @Environment(\.dismiss)
    private var dismiss
    
    @AppStorage("wins")
    private var wins = 0
    
    @AppStorage("losses")
    private var losses = 0
    
    let min: Int
    let max: Int
    
    var body: some View {
        
        VStack(spacing: 40) {
            
            TitleView()
            
            VStack(spacing: 20) {
                
                Divider()
                    .background(Color(.gray))
                    .padding(.horizontal)
                
                StatsView(wins: $wins, losses: $losses)
                
                Divider()
                    .background(Color(.gray))
                    .padding(.horizontal)
                
            }
            
            TextField("Guess the number from \(min) to \(max)",
                      text: $userInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .clipped(antialiased: true)
            .keyboardType(.numberPad)
            .padding(.horizontal)
            
            Button("Guess the number") {
                generateNumber()
            }
            .padding()
            .background(gradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            
            HStack(spacing: 50) {
                
                VStack(spacing: 10) {
                    
                    Text("Remaining attempts")
                    
                    Text("\(maxAttempts)")
                        .foregroundStyle(Color.white)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gradient)
                                .foregroundColor(.blue.opacity(0.4))
                                .frame(width: 35, height: 35)
                        )
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: 170, height: 80))
                
                VStack(spacing: 10) {
                    
                    Text("Current attempt")
                    
                    Text("\(currentAttempt)")
                        .foregroundStyle(Color.white)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gradient)
                                .frame(width: 35, height: 35)
                        )
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: 170, height: 80))
                
            }
            Text("\(gameMessage)")
                .padding()
                .font(.headline)
                .multilineTextAlignment(.center)
            
        }
        .padding()
        .onAppear {
            targetNumb = Int.random(in: min...max)
        }
        .sheet(isPresented: $showingResult) {
            if let result = gameResult {
                ResultView(isWin: result.isWin,
                           targetNumber: result.targetNumber,
                           attemptsUsed: result.attemptsUsed,
                           min: result.min,
                           max: result.max,
                           shouldCloseToStart: $shouldCloseToStart)
            }
        }
        .onChange(of: shouldCloseToStart) {
            if shouldCloseToStart {
                dismiss()
            }
        }
        .interactiveDismissDisabled(true)
        
    }
    
    private func generateNumber() {
        
        guard let userGuess = Int(userInput) else {
            gameMessage = "Enter a valid number, please"
            return
        }
        
        if userGuess == targetNumb, currentAttempt > 0 {
            
            wins += 1
            gameResult = GameResult(isWin: true, targetNumber: targetNumb, attemptsUsed: currentAttempt, min: min, max: max)
            showingResult = true
            
        }
        
        if userGuess > targetNumb, currentAttempt > 0 {
            
            maxAttempts -= 1
            currentAttempt += 1
            gameMessage = "Wrong! The number is smaller"
            
        } else if currentAttempt > 0 {
            
            maxAttempts -= 1
            currentAttempt += 1
            gameMessage = "Wrong! The number is bigger"
            
        }
        
        if maxAttempts == 0 {
            
            losses += 1
            gameResult = GameResult(isWin: false, targetNumber: targetNumb, attemptsUsed: currentAttempt - 1, min: min, max: max)
            showingResult = true
            
        }
    }
}

struct TitleView: View {
    var body: some View {
        Text("Guess it!")
            .font(.system(size: 40))
            .bold()
            .foregroundStyle(gradient)
    }
}

var gradient: Gradient {
    Gradient(colors: [.blue, .purple])
}

struct GameResult {
    let isWin: Bool
    let targetNumber: Int
    let attemptsUsed: Int
    let min: Int
    let max: Int
}

#Preview {
    GameView(maxAttempts: 10, min: 10, max: 11)
}
