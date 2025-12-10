//
//  GenreYearPicker.swift
//  MovieBrowser
//
//  Created by Ляйсан on 8/12/25.
//

import SwiftUI

struct GenreYearPicker: View {
    @Binding var genre: Genre
    @Binding var year: Int
    
    var body: some View {
        HStack {
            Picker("", selection: $genre) {
                ForEach(Genre.allCases) { genre in
                    Text(genre.rawValue.capitalized)
                        .tag(genre)
                }
            }
            Spacer()
            HStack(spacing: -5) {
                Text("Released in")
                    .foregroundStyle(.lightVine)
                Picker("", selection: $year) {
                    ForEach(1980..<2026) { year in
                        Text(String(year))
                            .tag(year)
                    }
                }
            }
        }
        .tint(.lightVine)
    }
}
