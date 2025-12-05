//
//  MovieDetailView.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie //для чтения редактирования и сохранения
    let viewModel: MoviesViewModel //для метода update
    
    var body: some View {
        Form {
            Section("Постер") {
                HStack {
                    Spacer()
                    Image(systemName: movie.posterSymbol)
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    Spacer()
                }
                .padding()
                
                Picker("Символ постера", selection: $movie.posterSymbol) {
                    Text("Film").tag("film.fill")
                    Text("Eye").tag("eye.fill")
                    Text("Sparkles").tag("sparkles")
                    Text("Shield").tag("shield.fill")
                    Text("Star").tag("star.fill")
                    Text("Heart").tag("heart.fill")
                    Text("Flame").tag("flame.fill")
                    Text("Crown").tag("crown.fill")
                }
            }
            
            Section("Заголовок") {
                TextField("Заголовок", text: $movie.title)
            }
            
            Section("Жанр") {
                TextField("Жанр", text: $movie.genre)
            }
            
            Section("Описание") {
                TextField("Описание", text: $movie.description, axis: .vertical)
                    .lineLimit(5...10)
            }
            
            Section("Год выпуска") {
                Stepper("\(movie.releaseYear)", value: $movie.releaseYear, in: 1900...2025)
            }
        }
        .navigationTitle("Редактировать фильм")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: movie) { oldValue, newValue in //срабатывает при изменении
            viewModel.updateMovie(newValue) //обновление после редактирования без отдельного save
        }
    }
}
