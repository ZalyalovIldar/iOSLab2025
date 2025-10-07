//
//  StatisticsView.swift
//  GuessGame
//
//  Created by Ляйсан on 20.09.2025.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ZStack {
            GradientBackground(color: .blue)
            VStack {
                title
                VStack {
                    StatisticsInfo(sfSymbol: "star.fill", sfSymbloColor: .yellow, shadowColor: .orange, title: "Victories", text: "Score: \(GameViewModel.userStatistic.victories)/\(GameViewModel.userStatistic.totalGames)", textColor: .beige, gradientColors: [.lBrown, .dBrown])
                        .padding(.vertical, 40)
                    StatisticsInfo(sfSymbol: "xmark.circle.fill", sfSymbloColor: .dBlue, shadowColor: .blue, title: "Losses", text: "Score: \(GameViewModel.userStatistic.losses)/\(GameViewModel.userStatistic.totalGames)", textColor: .lightBlue, gradientColors: [.lBlue, .dBlue])
                        .padding(.vertical, 5)
                }
                Spacer()
            }
            .padding()
        }
    }
    
    private var title: some View {
        HStack {
            LargeTitle(text: "Statistics ")
            Image(systemName: "numbers")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
            Spacer()
        }
    }
    
    struct StatisticsInfo: View {
        var sfSymbol: String
        var sfSymbloColor: Color
        var shadowColor: Color
        var title: String
        var text: String
        var textColor: Color
        var gradientColors: [Color]
        
        var body: some View {
            HStack(spacing: 20) {
                Image(systemName: sfSymbol)
                    .foregroundStyle(sfSymbloColor)
                    .font(.system(size: 25))
                    .shadow(color: shadowColor, radius: 10)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                    Text(text)
                        .foregroundStyle(textColor)
                }
            }
            .padding(.horizontal, 35)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background() {
                RoundedRectangle(cornerRadius: 38)
                    .fill(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
                    .frame(width: 360, height: 85)
                    .glassEffect()
            }
        }
    }
}

#Preview {
    StatisticsView()
}
