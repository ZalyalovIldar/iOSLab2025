//
//  MoviesDetailView.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 22.12.2025.
//

import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "film.stack.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue.gradient)
                        .frame(height: 120)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
            
            Section("Movie Information") {
                TextField("Title", text: $movie.title)
                
                TextField("Genre", text: $movie.genre)
                
                TextField("Release Year", value: $movie.releaseYear, format: .number)
                    .keyboardType(.numberPad)
            }
            
            Section("Description") {
                TextEditor(text: $movie.description)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
