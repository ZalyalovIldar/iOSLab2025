import SwiftUI

struct FilmRowView: View {
    
    let film: Film
    
    var body: some View {
        HStack(spacing: 12) {
            VStack {
                Text("\(film.year)")
                    .font(.subheadline.bold())
                Text("год")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(film.name)
                    .font(.headline)
                
                Text(film.category.isEmpty ? "Жанр не указан" : film.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if !film.notes.isEmpty {
                    Text(film.notes)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    List {
        FilmRowView(film: Film.demo[0])
        FilmRowView(film: Film.demo[1])
    }
}
