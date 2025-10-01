//
//  StatsView.swift
//  GuessIt
//
//  Created by Artur Bagautdinov on 23.09.2025.
//

import SwiftUI

struct StatsView: View {
    
    @Binding var wins: Int
    @Binding var losses: Int
    
    private var rating: Double {
        let total = wins + losses
        return total > 0 ? (Double(wins) / Double(total)) * 100 : 0
    }
    
    var body: some View {
        HStack(spacing: 30) {
            
            VStack {
                Text("Wins")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("\(wins)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack {
                Text("Losses")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("\(losses)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack {
                Text("Win Rate")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("\(String(format: "%.1f", rating))%")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        
    }
}

#Preview {
    StatsView(wins: .constant(5), losses: .constant(3))
}
