//
//  AddMovieView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 18.12.2025.
//

import SwiftUI

struct AddMovieView: View {
    
    private let yearFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 1900
        formatter.maximum = 2100
        formatter.allowsFloats = false
        return formatter
    }()
    
    @Bindable var viewModel: MoviesViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    @State private var releaseYear: Int = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Genre", text: $genre)
                
                TextField("Release year",
                          value: $releaseYear,
                          formatter: yearFormatter)
                .keyboardType(.numberPad)
                
            } header: {
                Label("Main info", systemImage: "info.circle")
                    .foregroundStyle(.black)
            }
            
            Section {
                TextEditor(text: $description)
                    .frame(minHeight: 120)
            } header: {
                Label("Description", systemImage: "text.alignleft")
                    .foregroundStyle(.black)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundColor)
        .navigationTitle("New movie")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    viewModel.add(movie: Movie(title: title, genre: genre, description: description, releaseYear: releaseYear))
                    dismiss()
                }
                .disabled(!canSave)
            }
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !genre.trimmingCharacters(in: .whitespaces).isEmpty &&
        releaseYear >= 1900 && releaseYear <= 2100
    }
    
}

#Preview {
    NavigationStack {
        AddMovieView(viewModel: MoviesViewModel())
    }
}
