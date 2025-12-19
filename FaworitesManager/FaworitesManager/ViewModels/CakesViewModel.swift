//
//  CakesViewModel.swift
//  FaworitesManager
//
//  Created by krnklvx on 17.12.2025.
//

import Foundation
import SwiftUI

// @MainActor все методы выполняются на главном потоке
@MainActor
// ObservableObject протокол позволяет вьюхе следить за изменениями
class CakesViewModel: ObservableObject {
    // @Published изменяется и View автоматически обновляется
    @Published var cakes: [Cake] = []
    // выбранная буква для фильтрации nil это все тортики
    @Published var selectedLetter: String? = nil
    // направление сортировки true А-Я и false Я-А
    @Published var sortAscending: Bool = true
    
    // хранилище для работы с файлом
    private let store = CakesStore()
    
    // инициализатор
    init() {
        // загружаем тортики при запуске приложения
        // Task для асинхронной функции
        Task {
            await loadCakes()
        }
    }
    
    // загрузка тортиков из файла
    func loadCakes() async {
        do {
            // загружаем данные из файла
            try await store.load()
            // получаем тортики и обновляем массив
            cakes = await store.getCakes()
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    // добавить новый тортик
    func addCake(name: String) {
        // проверяем что название не пустое иначе выходим
        guard !name.isEmpty else { return }
        // создаём новый тортик
        let cake = Cake(name: name)
        // Task для асинхронной операции
        Task {
            do {
                // Добавляем в хранилище
                try await store.add(cake)
                // перезагружаем
                await loadCakes()
            } catch {
                print("Ошибка добавления: \(error)")
            }
        }
    }
    
    // удалить тортик
    func removeCake(_ cake: Cake) {
        // Task для асинхронной операции
        Task {
            do {
                // удаляем из хранилища
                try await store.remove(cake)
                // перезагружаем
                await loadCakes()
            } catch {
                print("Ошибка удаления: \(error)")
            }
        }
    }
    
    // очистить все тортики
    func clearAll() {
        // Task для асинхронной операции
        Task {
            do {
                // удаляем все из хранилища
                try await store.removeAll()
                // Перезагружаем список станет пустым
                await loadCakes()
            } catch {
                print("Ошибка очистки: \(error)")
            }
        }
    }
    
    // вычисляемое свойство фильтрует и сортирует тортики
    var filteredAndSortedCakes: [Cake] {
        // копируем массив
        var result = cakes
        
        // Фильтр по первой букве если буква выбрана
        if let letter = selectedLetter {
            // filter соответствуют условию
            result = result.filter { cake in
                // есть ли первая буква
                if let firstChar = cake.name.first {
                    return String(firstChar).uppercased() == letter.uppercased()
                }
                // если первой буквы нет не показываем этот тортик
                return false
            }
        }
        // если буква не выбрана фильтр не применяется
        
        // сортировка
        result.sort { cake1, cake2 in
            if sortAscending {
                // по возрастанию
                return cake1.name < cake2.name
            } else {
                // по убыванию
                return cake1.name > cake2.name
            }
        }
        
        return result
    }
    
    // список букв для фильтрации
    var availableLetters: [String] {
        // пустой массив
        var letters: [String] = []
        for cake in cakes {
            // есть ли первая буква
            if let firstChar = cake.name.first {
                // символ в строку и в верхний регистр
                let letter = String(firstChar).uppercased()
                // чтобы не было дубликатов
                if !letters.contains(letter) {
                    // букву в массив
                    letters.append(letter)
                }
            }
        }
        // отсортированный массив
        return letters.sorted()
    }
}
