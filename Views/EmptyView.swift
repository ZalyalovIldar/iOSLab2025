//
//  EmptyView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Пупупу, никого нет(")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Используй форму для добавления или импортируй данные")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
