//
//  GameViewModel.swift
//  GuessGame
//
//  Created by Ляйсан on 20.09.2025.
//

import Foundation

@Observable
class GameViewModel  {
    var game: Game
    var hint: String { game.hint }
    var didWin: Bool { game.didWin }
    var gameIsStarted = false
    var gameIsOver = false
    var numberToGuess: Int { game.numberToGuess }
    var remainingAttempts: Int { game.remainingAttempts }
    static var userStatistic = UserStatistics()
    
    init(difficulty: Difficulty, rangeStart: Int, rangeEnd: Int) {
        self.game = Game(difficulty: difficulty, rangeStart: rangeStart, rangeEnd: rangeEnd)
    }
    
    func play(guess: Int) {
        if game.numberToGuess == guess {
            gameIsStarted = false
            gameIsOver = true
            game.didWin = true
            GameViewModel.userStatistic.victories += 1
        } else if (game.remainingAttempts - 1) != 0 {
            if guess > game.numberToGuess {
                game.remainingAttempts -= 1
                game.hint = "Lower"
            } else {
                game.remainingAttempts -= 1
                game.hint = "Higher"
            }
        } else {
            gameIsStarted = false
            gameIsOver = true
            game.didWin = false
            GameViewModel.userStatistic.losses += 1
        }
    }
}
