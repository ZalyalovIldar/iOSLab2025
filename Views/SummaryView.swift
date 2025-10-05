//
//  SummaryView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//


import SwiftUI

struct SummaryView: View {
    let total: Double
    let average: Double
    let personsCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Итого: ")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack {
                Text("Общая сумма:")
                Spacer()
                Text("\(total, specifier: "%.2f")")
                    .fontWeight(.medium)
            }
                        
            HStack {
                Text("Средняя сумма:")
                Spacer()
                Text("\(average, specifier: "%.2f")")
                    .fontWeight(.medium)
            }
                        
            HStack {
                Text("Участников:")
                Spacer()
                Text("\(personsCount) чел.")
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}