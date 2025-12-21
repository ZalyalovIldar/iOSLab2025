//
//  MovieRowView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

struct MovieRowView: View {
    
    let movie: Movie
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            poster
                .frame(height: 120)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(movie.title)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack {
                
                Text(movie.genre)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.16))
                    )
                    .foregroundStyle(.white)
                
                Text(String(movie.releaseYear))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
        .background(
            Color.cardGradient
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 8, y: 4)
    }
    
    @ViewBuilder private var poster: some View {
        
        switch movie.posterType {
        case .sfSymbol:
            Image(systemName: movie.posterName)
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.9))
        case .photo:
            if let data = movie.posterImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 32))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
}

#Preview {
    MovieRowView(movie: .init(
        title: "Inception",
        genre: "Sci-Fi",
        description: "A mind-bending thriller.",
        releaseYear: 2010,
        posterType: .sfSymbol,
        posterName: "film"
    ))
    .padding()
    .background(.black)
}
