//
//  AddMovieView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 18.12.2025.
//

import SwiftUI
import PhotosUI

struct AddMovieView: View {
    
    @Bindable var viewModel: MoviesViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    @State private var releaseYear: Int = Calendar.current.component(.year, from: Date())
    @State private var posterType: PosterType = .sfSymbol
    @State private var posterName: String = "film"
    @State private var selectedItem: PhotosPickerItem?
    @State private var posterImageData: Data?
    
    private let years: [Int] = Array(1900...Calendar.current.component(.year, from: Date())).reversed()
    
    var body: some View {
        
        Form {
            
            Section {
                TextField("Title", text: $title)
                TextField("Genre", text: $genre)
                
                Picker("Release year", selection: $releaseYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 20)
            } header: {
                Label("Main info", systemImage: "info.circle")
                    .foregroundStyle(.black)
            }
            
            Section {
                Picker("Poster type", selection: $posterType) {
                    Text("SF Symbol").tag(PosterType.sfSymbol)
                    Text("Photo").tag(PosterType.photo)
                }
                .pickerStyle(.segmented)
                
                if posterType == .sfSymbol {
                    TextField("e.g. film, popcorn.fill", text: $posterName)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                } else {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Choose photo")
                        }
                    }
                }
                
                HStack {
                    
                    Spacer()
                    posterPreview
                        .font(.system(size: 40))
                        .padding(.vertical, 4)
                    Spacer()
                }
                
                if posterType == .photo,
                   posterImageData != nil {
                    Button("Remove photo") {
                        posterImageData = nil
                    }
                    .font(.callout)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
                }
            } header: {
                Label("Poster", systemImage: "photo")
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
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        posterImageData = data
                    }
                }
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
                    viewModel.add(
                        movie: Movie(
                            title: title,
                            genre: genre,
                            description: description,
                            releaseYear: releaseYear,
                            posterType: posterType,
                            posterName: posterName,
                            posterImageData: posterType == .photo ? posterImageData : nil
                        )
                    )
                    dismiss()
                }
                .disabled(!canSave)
            }
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !genre.trimmingCharacters(in: .whitespaces).isEmpty &&
        releaseYear >= 1900 && releaseYear <= 2100 &&
        (posterType == .sfSymbol
         ? !posterName.trimmingCharacters(in: .whitespaces).isEmpty
         : posterImageData != nil)
    }
    
    @ViewBuilder private var posterPreview: some View {
        switch posterType {
        case .sfSymbol:
            Image(systemName: posterName.isEmpty ? "questionmark.square.dashed" : posterName)
                .font(.system(size: 120))
        case .photo:
            if let data = posterImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 100))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddMovieView(viewModel: MoviesViewModel())
    }
}
