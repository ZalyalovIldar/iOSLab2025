//
//  Difficulty.swift
//  GuessIt
//
//  Created by Artur Bagautdinov on 22.09.2025.
//
enum Difficulty: String, CaseIterable, Identifiable, Hashable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var id: String { self.rawValue }
}

extension Difficulty {
    var attemptCount: Int {
        switch self {
        case .easy:
            return 15
        case .medium:
            return 10
        case .hard:
            return 5
        }
    }
}
