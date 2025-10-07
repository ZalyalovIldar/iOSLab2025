//
//  UserStatistics.swift
//  GuessGame
//
//  Created by Ляйсан on 21.09.2025.
//

import Foundation

struct UserStatistics {
    var victories = 0
    var losses = 0
    var totalGames: Int {
        losses + victories
    }
}
