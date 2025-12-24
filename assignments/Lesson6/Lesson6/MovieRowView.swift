//
//  MovieRowView.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 22.12.2025.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "film.fill")
                .font(.system(size: 40))
                .foregroundStyle(.blue.gradient)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Label(movie.genre, systemImage: "tag.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Label(String(movie.releaseYear), systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
