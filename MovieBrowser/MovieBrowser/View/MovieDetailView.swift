//
//  MovieDetailView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 18.12.2025.
//

import SwiftUI
import PhotosUI

struct MovieDetailView: View {
    
    @Binding var movie: Movie
    
    @State private var originalTitle: String = ""
    @State private var originalGenre: String = ""
    @State private var originalYear: Int = 0
    
    private let allowedRange = 1800...2100
    private let years: [Int] = Array(1900...Calendar.current.component(.year, from: Date())).reversed()
    
    @State private var selectedItem: PhotosPickerItem?
    
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
                
                Picker("Release year", selection: $movie.releaseYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 20)
            } header: {
                Label("Movie Info", systemImage: "info.circle")
                    .foregroundStyle(.white)
            }
            
            Section {
                Picker("Poster type", selection: $movie.posterType) {
                    Text("SF Symbol").tag(PosterType.sfSymbol)
                    Text("Photo").tag(PosterType.photo)
                }
                .pickerStyle(.segmented)
                
                if movie.posterType == .sfSymbol {
                    TextField("e.g. film, popcorn.fill", text: $movie.posterName)
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
                if movie.posterType == .photo,
                   movie.posterImageData != nil {
                    Button("Remove photo") {
                        movie.posterImageData = nil
                    }
                    .font(.callout)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
                }

            } header: {
                Label("Poster", systemImage: "photo")
                    .foregroundStyle(.white)
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
                    .foregroundStyle(.white)
            }
        }
        .onChange(of: selectedItem) { _, newItem  in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        movie.posterImageData = data
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            Color.cardGradient
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
    
    @ViewBuilder
    private var posterPreview: some View {
        switch movie.posterType {
        case .sfSymbol:
            Image(systemName: movie.posterName.isEmpty ? "questionmark.square.dashed" : movie.posterName)
                .font(.system(size: 120))
        case .photo:
            if let data = movie.posterImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 120))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var previewMovie = Movie(
        title: "The Matrix",
        genre: "Action",
        description: "A computer hacker learns about the true nature of reality in a dystopian future.",
        releaseYear: 1999,
        posterType: .sfSymbol,
        posterName: "film"
    )
    return NavigationStack {
        MovieDetailView(movie: $previewMovie)
    }
}
