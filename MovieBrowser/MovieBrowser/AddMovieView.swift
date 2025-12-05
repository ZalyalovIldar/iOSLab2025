//
//  AddMovieView.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

struct AddMovieView: View {
    @Bindable var viewModel: MoviesViewModel //обновляет View при изменениях в ViewModel
    @Environment(\.dismiss) var dismiss //ф-ия для закрытия модального окна
    
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    @State private var releaseYear: Int = 2025
    @State private var posterSymbol: String = "film.fill" //по умолчанию
    
    let posterSymbols = [
        ("Film", "film.fill"),
        ("Eye", "eye.fill"),
        ("Sparkles", "sparkles"),
        ("Shield", "shield.fill"),
        ("Star", "star.fill"),
        ("Heart", "heart.fill"),
        ("Flame", "flame.fill"),
        ("Crown", "crown.fill")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Постер") {
                    HStack {
                        Spacer()
                        Image(systemName: posterSymbol)
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                    .padding()
                    
                    Picker("Символ постера", selection: $posterSymbol) {
                        ForEach(posterSymbols, id: \.1) { name, symbol in //второй элемент из кортежа
                            Text(name).tag(symbol)
                        }
                    }
                }
                
                Section("Заголовок") {
                    TextField("Заголовок", text: $title)
                }
                
                Section("Жанр") {
                    TextField("Жанр", text: $genre)
                }
                
                Section("Описание") {
                    TextField("Описание", text: $description, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section("Год выпуска") {
                    Stepper("\(releaseYear)", value: $releaseYear, in: 1900...2025)
                }
            }
            .navigationTitle("Добавить фильм")
            .navigationBarTitleDisplayMode(.inline) //компактное отображение заголовка
            .toolbar { //в верхней части
                ToolbarItem(placement: .cancellationAction) { //кнопка отмены
                    Button("Отмена") {
                        dismiss() //закрытие окна
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) { //конпка согласия
                    Button("Добавить") {
                        viewModel.addMovie( //добавляем фильм
                            title: title,
                            genre: genre,
                            description: description,
                            releaseYear: releaseYear,
                            posterSymbol: posterSymbol
                        )
                        dismiss() //закрываем модальное окно
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) //если титл пустой то кнопка не активна
                }
            }
        }
    }
}
