//
//  RulesView.swift
//  GuessGame
//
//  Created by Ляйсан on 22.09.2025.
//

import SwiftUI

struct RulesView: View {
    @State private var rulesAreExpanded = false
    @State private var difficultyLevelsAreExpanded = false
    @Namespace private var rulesNamespace
    @Namespace private var difficultyNamespace
    
    var body: some View {
        ZStack {
            GradientBackground(color: .blue)
            VStack {
                title
                TitleForExpandingUI(text: "How to play", sfSymbol: "questionmark.circle", sfSymbolColor: .blue, shadowColor: .deepBlue, isExpanded: $rulesAreExpanded)
                    .padding(10)
                    .glassEffectID(1, in: rulesNamespace)
                
                if rulesAreExpanded {
                    StrokedTextHolder(text: "1. Set a range for randomly generated number.\n\n2. Enter your guess — you’ll get a hint.\n\n3. Keep guessing until you find the number — or run out of attempts!")
                    .padding(.vertical, 10)
                    .glassEffectID(1, in: rulesNamespace)
                    .glassEffectTransition(.matchedGeometry)
                }
                
                TitleForExpandingUI(text: "Difficulty levels", sfSymbol: "bolt.fill", sfSymbolColor: .yellow.opacity(0.9), shadowColor: .orange, isExpanded: $difficultyLevelsAreExpanded)
                    .glassEffectID(2, in: difficultyNamespace)
                
                if difficultyLevelsAreExpanded {
                    StrokedTextHolder(text: "Easy: 5 attempts                                              \n\nMedium: 3 attempts \n\nHard: 1 attempt")
                        .padding(5)
                        .glassEffectID(2, in: difficultyNamespace)
                        .glassEffectTransition(.matchedGeometry)
                }
                Spacer()
            }
        }
    }
    
    private var title: some View {
        HStack {
            LargeTitle(text: "Rules ")
            Image(systemName: rulesAreExpanded || difficultyLevelsAreExpanded ? "list.clipboard.fill" : "list.clipboard")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
            Spacer()
        }
        .padding()
    }   
}

#Preview {
    RulesView()
}
