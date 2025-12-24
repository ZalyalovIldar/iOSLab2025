//
//  AddMovieView.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 22.12.2025.
//

import SwiftUI

struct AddMovieView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    @State private var releaseYear: Int = 2024
    
    var onSave: (Movie) -> Void
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !genre.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue.gradient)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section("Movie Information") {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Genre", text: $genre)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Release Year", value: $releaseYear, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Add New Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newMovie = Movie(
                            title: title,
                            genre: genre,
                            description: description,
                            releaseYear: releaseYear
                        )
                        onSave(newMovie)
                        dismiss()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
