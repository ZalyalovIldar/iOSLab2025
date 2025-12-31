import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            Image(systemName: "film.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                
                HStack {
                    Text(movie.genre)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(movie.releaseYear)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}

#Preview {
    MovieRowView(movie: Movie(title: "The Matrix", genre: "Sci-Fi", description: "A computer hacker learns from mysterious rebels about the true nature of his reality.", releaseYear: 1999))
        .padding()
}
