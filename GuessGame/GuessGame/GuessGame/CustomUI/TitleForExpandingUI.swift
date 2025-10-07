//
//  TitleForExpandingUI.swift
//  GuessGame
//
//  Created by Ляйсан on 23.09.2025.
//

import SwiftUI

struct TitleForExpandingUI: View {
    var text: String
    var sfSymbol: String
    var sfSymbolColor: Color
    var shadowColor: Color
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack {
            Image(systemName: sfSymbol)
                .foregroundStyle(sfSymbolColor)
                .shadow(color: shadowColor, radius: 10)
                .font(.system(size: 23))
                .padding()
                .padding(.leading, 10)
            Text(text)
                .font(.system(size: 20, weight: .bold))
            Spacer()
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .padding()
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
        }
        .foregroundStyle(.white)
        .frame(width: 360, height: 80)
        .background {
            RoundedRectangle(cornerRadius: 35)
                .stroke(.blue, lineWidth: 1)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 35))
        }
    }
}

#Preview {
    TitleForExpandingUI(text: "How to play", sfSymbol: "questionmark.circle.fill", sfSymbolColor: .blue, shadowColor: .gray, isExpanded: .constant(true))
}
