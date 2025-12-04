//
//  EmptyStateView.swift
//  IOS_LAB_HW5
//
//  Created by krnklvx on 03.12.2025.
//
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "multiply.circle")
                .symbolEffect(.wiggle.byLayer, options: .nonRepeating)
                .font(.system(size: 60))
            
            Text("Нет рецептов")
                .font(.title2)
                .bold()
            
            Text("Добавьте новый рецепт, нажав +")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

