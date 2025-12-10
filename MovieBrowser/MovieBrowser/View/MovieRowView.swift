//
//  MovieRowView.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI

struct MovieRowView: View {
    var movie: Movie
    @Bindable var movieViewModel: MovieViewModel
    
    var body: some View {
        VStack {
            moviePoster
            movieTitle
        }
        .padding(10)
        .glassEffect(.clear, in: .rect(cornerRadius: 25))
    }
    
    @ViewBuilder private var moviePoster: some View {
        if let image = movieViewModel.getPoster(imageName: movie.imageName) {
            UIImagePoster(image: image)
        } else {
            ImagePlaceholder()
        }
    }
    
    private var movieTitle: some View {
        Text(movie.title)
            .font(.headline)
            .foregroundStyle(.white)
            .lineLimit(1)
            .padding(.top, 15)
            .padding(.bottom, 7)
    }
}

#Preview {
    MovieRowView(movie: Movie(title: "Stranger Things", genre: Genre.fantasy, description: "fnoefopjpfpmf cvowfpoef cofpwmefenfo onfoenf vfnenf vnowifniwnfow vvpfkwpmf fwfofn noefv ofnonf", releaseYear: 2016, imageName: "st"), movieViewModel: MovieViewModel())
}
