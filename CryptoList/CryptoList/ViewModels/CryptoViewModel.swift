//
//  CryptoViewModel.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//
/*
 CryptoViewModel
 хранит данные список криптовалют
 управляет состоянием загружается ли, есть ли ошибка
 выполняет действия загрузить данные, обновить
 */

import Foundation
import Observation

enum SortOption: String, CaseIterable { //виды сортировки
    case priceDescending = "Price: High to Low"
    case priceAscending = "Price: Low to High"
    case nameAscending = "Name: A to Z"
    case nameDescending = "Name: Z to A"
}

@Observable //для отслеживания состояния
class CryptoViewModel {
    var items: [Crypto] = [] //массив списка криптовалют
    var isLoading = false //загружается ли сейчас
    var error: String? //строка ошибки может быть nil
    var sortOption: SortOption = .priceDescending //хранит способ сортировки по умолчанию от большей к меньшей
    
    private let service: CryptoService //сервис для загрузк данных
    private var cachedItems: [Crypto]? //сохраненные закэшированные данные
    
    init(service: CryptoService = RealCryptoService()) { //инициализация сервиса
        self.service = service
    }
    
    func load() async { //функция для загрузки данных из интернета
        if let cached = cachedItems { //если есть сохраненные данные
            items = cached //используем их
            applySort()
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let fetchedItems = try await service.fetchCryptos()
            
            items = fetchedItems
            cachedItems = fetchedItems
            applySort()
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func refresh() async {
        cachedItems = nil
        await load()
    }
    
    func applySort() { //применение сортировки
        switch sortOption { //смотрим на sortOption и в зависимости от этого выбираем кейс
        case .priceDescending:
            items.sort { $0.currentPrice > $1.currentPrice } //от б к м
        case .priceAscending:
            items.sort { $0.currentPrice < $1.currentPrice } //от м к б
        case .nameAscending:
            items.sort { $0.name < $1.name } //по алфавиту
        case .nameDescending:
            items.sort { $0.name > $1.name } //против алфавита
        }
    }
    
    var topGainers: [Crypto] { //вычислимое св-во возвращает список криптовалют
        Array(items.prefix(5)) //берет аервые 5 элементов из массива и превращает в массив
    }
}
