//
//  ResultView.swift
//  GuessIt
//
//  Created by Artur Bagautdinov on 22.09.2025.
//

import SwiftUI

struct ResultView: View {
    
    let isWin: Bool
    let targetNumber: Int
    let attemptsUsed: Int
    let min: Int
    let max: Int
    
    @Binding var shouldCloseToStart: Bool
    
    @Environment(\.dismiss)
    private var dismiss
    
    @AppStorage("wins")
    private var wins = 0
    
    @AppStorage("losses")
    private var losses = 0
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Image(systemName: isWin ? "trophy.fill" : "xmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(isWin ? .yellow : .red)
            
            Text(isWin ? "Congratulations!" : "Game Over")
                .font(.title)
                .fontWeight(.bold)
            
            Text("The number was: \(targetNumber)")
                .font(.headline)
            
            Text("Attempts used: \(attemptsUsed)")
                .font(.headline)
            
            StatsView(wins: $wins, losses: $losses)
            
            Button("Play Again") {
                dismiss()
                shouldCloseToStart = true
                
            }
            .padding()
            .background(gradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            
        }
        .padding()
        .interactiveDismissDisabled(true)
        
    }
}

#Preview {
    ResultView(isWin: true, targetNumber: 42, attemptsUsed: 5, min: 1, max: 100, shouldCloseToStart: .constant(false))
}
