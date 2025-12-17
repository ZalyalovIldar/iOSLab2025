//
//  MovieRowView.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    @State private var isAppeared = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Постер
            Image(systemName: movie.posterSymbol)
                .font(.system(size: 40))
                .foregroundStyle(.blue)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                
                HStack {
                    Text(movie.genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(movie.releaseYear)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text(movie.description)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                isAppeared = true
            }
        }
    }
}

#Preview {
    List {
        MovieRowView(movie: Movie(
            title: "The Matrix",
            genre: "Sci-Fi",
            description: "A computer hacker learns about the true nature of reality.",
            releaseYear: 1999,
            posterSymbol: "eye.fill"
        ))
    }
}

#Preview {
    List {
        MovieRowView(movie: Movie(
            id: UUID(),
            title: "The Matrix",
            genre: "Sci-Fi",
            description: "A computer hacker learns about the true nature of reality.",
            releaseYear: 1999
        ))
    }
}
