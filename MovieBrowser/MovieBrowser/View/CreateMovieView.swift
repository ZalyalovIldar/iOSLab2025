//
//  CreateMovieView.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI
import PhotosUI

struct CreateMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var movieViewModel: MovieViewModel
    
    @State private var photoViewModel = PhotoSelectionViewModel()

    var isValidInput: Bool {
        !movieViewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !movieViewModel.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.title3.bold())
                        .padding(.top)
                    
                    TextField("", text: $movieViewModel.title)
                        .fontWeight(.medium)
                        .padding()
                        .glassEffect(.clear)
                    
                    Text("Description")
                        .font(.title3.bold())
                        .padding(.top)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.clear)
                            .glassEffect(.clear, in: .rect(cornerRadius: 20))
                        TextEditor(text: $movieViewModel.description)
                            .scrollContentBackground(.hidden)
                            .padding()
                    }
                    .frame(height: 150)
                    
                    Text("Poster")
                        .font(.title3.bold())
                        .padding(.top)
                    PhotosPicker(selection: $photoViewModel.selection, matching: .images) {
                        if let image = photoViewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            Image("questionmark")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    GenreYearPicker(genre: $movieViewModel.selectedGenre, year: $movieViewModel.releaseYear)
                        .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("New Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let image = photoViewModel.image {
                            movieViewModel.addMovie(image: image, imageName: "\(image).png")
                        } else {
                            movieViewModel.addMovie(image: UIImage(named: "questionmark"), imageName: "questionmark.png")
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(isValidInput ? .gray : .black)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(isValidInput ? .brightVine : .secondary)
                    .disabled(!isValidInput)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateMovieView(movieViewModel: MovieViewModel())
    }
}
