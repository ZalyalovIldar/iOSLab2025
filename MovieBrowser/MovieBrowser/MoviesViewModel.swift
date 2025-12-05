//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import Foundation
import Observation //для отслеживания

enum SortOption: String, CaseIterable { //для сортировки
    case title = "По названию"
    case year = "По году"
    case none = "Без сортировки"
}

@Observable //отслеживаемый класс
final class MoviesViewModel {
    var movies: [Movie] = []
    var searchText: String = ""
    var sortOption: SortOption = .none //по умолчанию без сортировки
    
    private let moviesKey = "savedMovies" //ключ для сохранения в userdefaults
    
    init() {
        loadMovies() //загружаем существующие фильмы
    }
    
    var filteredAndSortedMovies: [Movie] { //вычисляемое свойство
        var result = movies //создаем копию чтобы не менять основной массив в фильтрации
        
        // Поиск
        if !searchText.isEmpty {
            result = result.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText) //поиск без учета регистра
            }
        }
        
        // Сортировка
        switch sortOption {
        case .title:
            result.sort { $0.title < $1.title } //по алфавиту
        case .year:
            result.sort { $0.releaseYear > $1.releaseYear } //по году
        case .none: //по умолчанию без сортировки
            break
        }
        
        return result //возвращаем результат
    }
    
    func addMovie(title: String, genre: String, description: String, releaseYear: Int, posterSymbol: String = "film.fill") { //функиця добавления фильма
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines) //убираем пробелы и переноси строк
        guard !trimmedTitle.isEmpty else { return } //проверка на пустоту титла
        
        let newMovie = Movie( //создаем фильм
            title: trimmedTitle,
            genre: genre,
            description: description,
            releaseYear: releaseYear,
            posterSymbol: posterSymbol
        )
        
        movies.insert(newMovie, at: 0) //добавляем в список в позицию с индексом 0 чтобы новый фильм был сверху
        saveMovies() //сохраняем
    }
    
    func removeMovie(at offsets: IndexSet) { //функция удаления по индексу
        movies.remove(atOffsets: offsets)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) { //находит фильм по индексу и обновляет
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    
    private func saveMovies() { //сохранение
        if let encoded = try? JSONEncoder().encode(movies) { //попытка преобразовать фильм в json
            UserDefaults.standard.set(encoded, forKey: moviesKey) //сохранение данных под ключ
        }
    }
    
    private func loadMovies() { //загрузка
        if let data = UserDefaults.standard.data(forKey: moviesKey), //получаем данные по ключу
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) { //попытка превратить json в массив Movie
            movies = decoded //присваиваем загруженные фильмы
        }
    }
}
