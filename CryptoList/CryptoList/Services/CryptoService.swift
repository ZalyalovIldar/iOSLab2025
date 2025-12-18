//
//  CryptoService.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//
//общение с интернетом

import Foundation

protocol CryptoService { //как интерфейс
    func fetchCryptos() async throws -> [Crypto] //асинхронная функция те может занять время не блокируя приложение, возвращает массив криптовалют
}

class RealCryptoService: CryptoService { //выполняет протокол выше
    private var url: URL {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd") else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    func fetchCryptos() async throws -> [Crypto] { //реализуем функцию
        let (data, _) = try await URLSession.shared.data(from: url) //URLSession инструмент для работы с инетом, .shared общий экземпл]р на всё приложение, .data(from: url) метод загружающий данные по адресу, try для обработки ошибки прерыванин подключение к интернету, await дождись пока не закончится загрузка, let (data, _) получаем 2 значения 1)сами данные 2)ответ сервера который мы игнорируем
        //те приложение отправляет запрос на сервер
        //ждет ответа
        //получает данные в формате JSON
        let decoder = JSONDecoder() //создаем декодер из json
        return try decoder.decode([Crypto].self, from: data) //переводим json(data) в массив crypto и возвращаем результат
    }
}
