//
//  SymbolPicker.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 06.12.2025.
//

import SwiftUI

struct SymbolPicker: View {
    
    @Environment(\.dismiss) private var dismiss
    var onSelect: (String) -> Void
    
    private let symbols = [
        "fork.knife",
        "fork.knife.circle",
        "fork.knife.circle.fill",
        "takeoutbag.and.cup.and.straw",
        "takeoutbag.and.cup.and.straw.fill",
        "cup.and.saucer",
        "cup.and.saucer.fill",
        "mug",
        "mug.fill",
        "wineglass",
        "wineglass.fill",
        "birthday.cake",
        "birthday.cake.fill",
        "carrot",
        "carrot.fill",
        "leaf",
        "leaf.fill",
        "applelogo",
        "fish",
        "fish.fill",
        "flame",
        "flame.fill",
        "timer",
        "timer.circle",
        "timer.circle.fill",
        "clock",
        "clock.fill",
        "thermometer",
        "thermometer.medium",
        "chart.bar",
        "chart.pie",
        "basket",
        "basket.fill",
        "cart",
        "cart.fill",
        "shippingbox",
        "shippingbox.fill",
        "frying.pan",
        "frying.pan.fill",
        "stove",
        "stove.fill",
        "oven",
        "oven.fill",
        "drop",
        "drop.fill",
        "drop.triangle",
        "drop.triangle.fill",
        "heart",
        "heart.fill",
        "star",
        "star.fill",
        "sparkles",
        "bag",
        "bag.fill",
        "bag.circle",
        "bag.circle.fill",
        "thermometer.sun",
        "thermometer.snowflake",
        "tray",
        "tray.fill",
        "hare",
        "hare.fill",
        "leaf.arrow.circlepath",
        "cube",
        "cube.fill",
        "shippingbox.circle",
        "shippingbox.circle.fill",
        "bubbles.and.sparkles"
    ]

    private let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ForEach(symbols, id: \.self) { name in
                        
                        Button {
                            onSelect(name)
                            dismiss()
                        } label: {
                            Image(systemName: name)
                                .font(.system(size: 28))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Symbol")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        
        
    }
}

#Preview {
    SymbolPicker(onSelect: { _ in })
}

