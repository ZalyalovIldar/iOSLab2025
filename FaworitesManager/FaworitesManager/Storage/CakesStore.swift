//
//  CakesStore.swift
//  FaworitesManager
//
//  Created by krnklvx on 17.12.2025.
//

import Foundation

// Actor гарантирует что операции выполняются по очереди
actor CakesStore {
    // массив тортиков
    private var cakes: [Cake] = []
    //где сохраняем данные
    private let fileName = "cakes.json"
    
    // вычисляемое свойство путь к файлу в папке Documents приложения
    private var fileURL: URL {
        // получаем путь к папке Documents
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // добавляем имя файла к пути
        return documentsPath.appendingPathComponent(fileName)
    }
    
    // загрузка тортиков из файла
    func load() async throws {
        // существует ли файл
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // читаем данные
            let data = try Data(contentsOf: fileURL)
            //JSON в массив
            cakes = try JSONDecoder().decode([Cake].self, from: data)
        }
    }
    
    // сохранение тортиков в файл
    func save() async throws {
        // массив тортиков в JSON
        let data = try JSONEncoder().encode(cakes)
        // записываем в файл
        try data.write(to: fileURL)
    }
    
    // получить все тортики
    func getCakes() -> [Cake] {
        return cakes
    }
    
    // добавить новый тортик
    func add(_ cake: Cake) async throws {
        // добавляем в массив
        cakes.append(cake)
        // сохраняем в файл
        try await save()
    }
    
    // удалить тортик
    func remove(_ cake: Cake) async throws {
        // removeAll удаляет все элементы
        // $0 элемент массива в замыкании $0.id == cake.id проверяет совпадение id
        cakes.removeAll { $0.id == cake.id }
        // сохраняем изменения
        try await save()
    }
    
    // кдалить все тортики
    func removeAll() async throws {
        // очищаем массив
        cakes.removeAll()
        // сохраняем изменения
        try await save()
    }
}
