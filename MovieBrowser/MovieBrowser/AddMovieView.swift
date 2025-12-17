//
//  AddMovieView.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

struct AddMovieView: View {
    @Bindable
    var viewModel: MoviesViewModel
    @Environment(\.dismiss)
    var dismiss
    
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    @State private var releaseYear: Int = 2024
    @State private var posterSymbol: String = "film.fill"
    
    let posterSymbols = [
        ("Film", "film.fill"),
        ("Eye", "eye.fill"),
        ("Sparkles", "sparkles"),
        ("Shield", "shield.fill"),
        ("Star", "star.fill"),
        ("Heart", "heart.fill"),
        ("Flame", "flame.fill"),
        ("Crown", "crown.fill")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Poster") {
                    HStack {
                        Spacer()
                        Image(systemName: posterSymbol)
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                    .padding()
                    
                    Picker("Poster Symbol", selection: $posterSymbol) {
                        ForEach(posterSymbols, id: \.1) { name, symbol in
                            Text(name).tag(symbol)
                        }
                    }
                }
                
                Section("Title") {
                    TextField("Title", text: $title)
                }
                
                Section("Genre") {
                    TextField("Genre", text: $genre)
                }
                
                Section("Description") {
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section("Release Year") {
                    Stepper("\(releaseYear)", value: $releaseYear, in: 1900...2025)
                }
            }
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addMovie(
                            title: title,
                            genre: genre,
                            description: description,
                            releaseYear: releaseYear,
                            posterSymbol: posterSymbol
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddMovieView(viewModel: MoviesViewModel())
}

