//
//  PlaceCardView.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import SwiftUI

struct PlaceCardView: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.name)
                .font(.headline)
                .lineLimit(2)
            
            Text(place.country)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(place.year)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if !place.notes.isEmpty {
                Text(place.notes)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(height: 160)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
