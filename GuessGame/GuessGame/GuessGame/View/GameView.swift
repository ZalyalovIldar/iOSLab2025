//
//  ContentView.swift
//  GuessGame
//
//  Created by Ляйсан on 20.09.2025.
//

import SwiftUI

struct GameView: View {
    @State var game: GameViewModel
    @State private var selectedLevel = Difficulty.easy
    @State private var rangeStart = "1"
    @State private var rangeEnd = "100"
    @State private var userGuess = ""
    @State private var isShowingAlert = false
    @State private var isAnimatedMotivationSymbol = false
    
    var body: some View {
        ZStack {
            GradientBackground(color: .blue)
            VStack {
                gameTitle
                modePicker
                if game.gameIsStarted {
                    attemptsLeftCounter
                    userInput
                } else if game.gameIsOver {
                    gameResult
                    motivationalText
                } else {
                    rangeSetter
                    userInput.opacity(0)
                }
                numberToGuess
                gameHint.opacity(game.hint != "" && game.gameIsStarted ? 1 : 0)
                controlButtons
                Spacer()
            }
            .padding()
            .onChange(of: selectedLevel) {
                game = GameViewModel(difficulty: selectedLevel, rangeStart: 1, rangeEnd: 100)
            }
        }
        .hideKeyboardOnTap()
        .alert("Invalid", isPresented: $isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Make sure the start is smaller than the end")
        }
    }
    
    private var gameTitle: some View {
        HStack {
            LargeTitle(text: "Guess It Game ")
            Image(systemName: game.gameIsStarted ? "flag.2.crossed.fill" : "flag.2.crossed")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
            Spacer()
        }
    }
    
    private var modePicker: some View {
        Picker("Difficulty level", selection: $selectedLevel) {
            ForEach(Difficulty.allCases, id: \.self) { mode in
                Text(mode.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
        .tint(.blue)
        .background(Color.gray.opacity(0.6).cornerRadius(20))
        .padding(.vertical)
    }
    
    private var rangeSetter: some View {
        HStack {
            Text("Set range")
                .font(.title3)
                .foregroundStyle(.white)
            TextField("1", text: $rangeStart)
                .textFieldStyle(.plain)
                .padding(.horizontal, 10)
                .glassEffect()
                .keyboardType(.numberPad)
            Text("to")
                .font(.system(size: 17))
                .foregroundStyle(.white)
            TextField("100", text: $rangeEnd)
                .textFieldStyle(.plain)
                .padding(.horizontal, 10)
                .glassEffect()
                .keyboardType(.numberPad)
        }
        .padding()
    }
    
    private var attemptsLeftCounter: some View {
        Text("Attempts left: \(game.remainingAttempts)")
            .font(.title3)
            .foregroundStyle(.white.opacity(0.9))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue.opacity(0.25))
                    .frame(width: 375, height: 25)
            )
            .padding()
    }
    
    private var gameHint: some View {
        HStack {
            Image(systemName: "lightbulb.max")
            Text(game.hint)
        }
        .foregroundStyle(.blue)
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
        .glassEffect()
    }
    
    private var userInput: some View {
        TextField("", text: $userGuess, prompt: Text("Enter your guess").foregroundStyle(.white))
            .textFieldStyle(.plain)
            .keyboardType(.numberPad)
            .padding(.horizontal, 20)
            .frame(width: 170, height: 60)
            .glassEffect(.clear)
            .foregroundStyle(.white)
            .padding()
    }
    
    private var motivationalText: some View {
        ZStack {
            userInput.opacity(0)
            HStack {
                Text(game.didWin ? "Fantastic" : "Try your best!")
                if isAnimatedMotivationSymbol {
                    Image(systemName: game.didWin ? "hands.and.sparkles" : "heart.badge.bolt")
                        .symbolEffect(.pulse)
                } else {
                    Image(systemName: game.didWin ? "hands.and.sparkles" : "heart.badge.bolt")
                }
            }
            .foregroundStyle(game.didWin ? Color.greenish : Color.reddish)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .glassEffect()
            .onTapGesture {
                isAnimatedMotivationSymbol.toggle()
            }
        }
    }
    
    private var numberToGuess: some View {
        Text(game.gameIsOver ? "\(game.numberToGuess)" : "?")
            .foregroundStyle(game.gameIsOver && game.didWin ?  Color.greenish : game.gameIsOver && !game.didWin ? Color.reddish : .gray.opacity(0.7))
            .font(.system(size: 100, weight: .bold))
            .padding(.vertical, 30)
    }
    
    private var newGameButton: some View {
        Text(game.gameIsOver ? "New game +" : "New +")
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, game.gameIsOver ? 50 : 10)
            .padding(.vertical, 15)
            .glassEffect(.clear.tint(.blue.opacity(0.7)).interactive())
            .onTapGesture {
                game.gameIsStarted = false
                game.gameIsOver = false
            }
    }
    
    private var gameResult: some View {
        Text(game.didWin ? "You nailed it!" : "Game over")
            .font(.title3)
            .bold()
            .foregroundStyle(.white.opacity(0.9))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(game.didWin ? Color.greenish : Color.reddish)
                    .frame(width: 375)
            )
            .padding()
    }
    
    private var controlButtons: some View {
        HStack {
            if game.gameIsStarted {
                ButtonLabel(text: "Guess", backgroundColor: .gray)
                    .onTapGesture {
                        if let guess = Int(userGuess) {
                            game.play(guess: guess)
                        }
                    }
            } else if !game.gameIsOver {
                ButtonLabel(text: "Start Playing", backgroundColor: .gray)
                    .onTapGesture {
                        if let start = Int(rangeStart), let end = Int(rangeEnd), start < end {
                            game = GameViewModel(difficulty: selectedLevel, rangeStart: start, rangeEnd: end)
                            game.gameIsStarted = true
                        } else {
                            isShowingAlert = true
                        }
                    }
            }
            newGameButton
        }
        .padding(.vertical, 50)
    }
}

#Preview {
    GameView(game: GameViewModel(difficulty: Difficulty.easy, rangeStart: 1, rangeEnd: 100))
}
