//
//  TabBarView.swift
//  GuessGame
//
//  Created by Ляйсан on 20.09.2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Tab("", systemImage: "gamecontroller") {
                GameView(game: GameViewModel(difficulty: Difficulty.easy, rangeStart: 1, rangeEnd: 100))
            }
            Tab("", systemImage: "chart.bar") {
                StatisticsView()
            }
            
            Tab("", systemImage: "text.page", role: .search) {
                RulesView()
            }
        }
    }
}

#Preview {
    TabBarView()
}
