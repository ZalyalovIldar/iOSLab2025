//
//  MovieDetailView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 18.12.2025.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Binding var movie: Movie
    
    @State private var originalTitle: String = ""
    @State private var originalGenre: String = ""
    @State private var originalYear: Int = 0
    private let allowedRange = 1900...2100
    
    private let yearFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 1900
        formatter.maximum = 2100
        formatter.allowsFloats = false
        return formatter
    }()
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextField("e.g. Inception", text: $movie.title)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Genre")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextField("e.g. Sci-Fi", text: $movie.genre)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Release Year")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextField("e.g. 2010",
                              value: $movie.releaseYear,
                              formatter: yearFormatter)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical, 4)
                
            } header: {
                Label("Movie Info", systemImage: "info.circle")
                    .foregroundStyle(.black)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    ZStack(alignment: .topLeading) {
                        if movie.description.isEmpty {
                            Text("Short plot summary...")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 6)
                        }
                        
                        TextEditor(text: $movie.description)
                            .frame(minHeight: 150)
                            .padding(4)
                            .background(Color.secondary.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
                .padding(.vertical, 4)
                
            } header: {
                Label("Details", systemImage: "text.alignleft")
                    .foregroundStyle(.black)
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            Color.backgroundColor
        )
        .navigationTitle(movie.title.isEmpty ? "Movie Details" : movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            originalTitle = movie.title
            originalGenre = movie.genre
            originalYear = movie.releaseYear
        }
        .onDisappear {
            if movie.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                movie.title = originalTitle
            }
            
            if movie.genre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                movie.genre = originalGenre
            }
            
            if !allowedRange.contains(movie.releaseYear) {
                movie.releaseYear = originalYear
            }
        }
    }
}

#Preview {
    @Previewable @State var previewMovie = Movie(
        title: "The Matrix",
        genre: "Action",
        description: "A computer hacker learns about the true nature of reality in a dystopian future.", releaseYear: 1999
    )
    return MovieDetailView(movie: $previewMovie)
}
