//
//  MovieDetailView.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI
import PhotosUI

struct MovieDetailView: View {
    @Environment(\.dismiss)
    private var dismiss
    @Binding var movie: Movie
    @Bindable var movieViewModel: MovieViewModel
    
    @State private var photoViewModel = PhotoSelectionViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                movieTitle
                photoPicker
                    .padding(.top, 20)
                movieDescription
                
                GenreYearPicker(genre: $movie.genre, year: $movie.releaseYear)
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                deleteButton
            }
        }
    }
    
    private var movieTitle: some View {
        TextField("Title", text: $movie.title)
            .font(.largeTitle.bold())
    }
    private var deleteButton: some View {
        Button {
            movieViewModel.delete(movieId: movie.id)
            dismiss()
        } label: {
            Image(systemName: "trash")
        }
        .tint(.brightVine)
    }
    
    private var movieDescription: some View {
        TextEditor(text: $movie.description)
            .foregroundStyle(.white)
            .padding(.top, 10)
            .frame(height: 150)
    }
    
    private var photoPicker: some View {
        PhotosPicker(selection: $photoViewModel.selection, matching: .images) {
            if let image = photoViewModel.image {
                UIImagePoster(image: image)
            } else if let image = movieViewModel.getPoster(imageName: movie.imageName) {
                UIImagePoster(image: image)
            } else {
                ImagePlaceholder()
            }
        }
        .onChange(of: photoViewModel.image) { _, newValue in
            if let image = newValue {
                let imageName = UUID().uuidString + ".png"
                movieViewModel.updatePoster(image: image, imageName: imageName, movieId: movie.id)
            }
        }
    }
}

#Preview {
    @Previewable @State var movie = Movie(title: "Stranger Things", genre: Genre.fantasy, description: "fnoefopjpfpmf cvowfpoef cofpwmefenfo onfoenf vfnenf vnowifniwnfow vvpfkwpmf fwfofn noefv ofnonf", releaseYear: 2016, imageName: "st")
    NavigationStack {
        MovieDetailView(movie: $movie, movieViewModel: MovieViewModel())
    }
}
