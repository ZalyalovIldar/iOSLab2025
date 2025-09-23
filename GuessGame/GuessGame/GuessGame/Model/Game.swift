//
//  UserStatistic.swift
//  GuessGame
//
//  Created by Ляйсан on 20.09.2025.
//

import Foundation

typealias Difficulty = Game.Difficulty

struct Game {
    var difficulty: Difficulty
    var numberToGuess: Int
    var hint = ""
    var remainingAttempts: Int
    var didWin = false
    
    init(difficulty: Difficulty, rangeStart: Int, rangeEnd: Int) {
        self.difficulty = difficulty
        self.numberToGuess = Int.random(in: rangeStart...rangeEnd)
        self.remainingAttempts = difficulty.attempts
    }
    
    enum Difficulty: String, CaseIterable {
        case easy
        case medium
        case hard
        
        var attempts: Int {
            switch self {
            case .easy: return 5
            case .medium: return 3
            case .hard: return 1
            }
        }
    }
}

