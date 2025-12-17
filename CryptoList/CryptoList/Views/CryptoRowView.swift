//
//  CryptoRowView.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//

import SwiftUI

struct CryptoRowView: View {
    let crypto: Crypto
    
    var body: some View {
        HStack {
            //загружаем картинку по адресу
            AsyncImage(url: URL(string: crypto.image)) { image in //когда загрузилась
                image //для этой картинки
                    .resizable() //изменяемый размер
                    .aspectRatio(contentMode: .fit) //сохраняем пропорции
            } placeholder: {
                ProgressView() //показывается во время загрузки
            }
            .frame(width: 50, height: 50) //рамка
            
            VStack(alignment: .leading, spacing: 4) { //выравнивание по левому краю с интервалом
                Text(crypto.name)
                    .font(.headline)
                Text(crypto.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer() //разделитель
            
            Text(formatPrice(crypto.currentPrice)) //форматируем в цену
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
    
    private func formatPrice(_ price: Double) -> String { //функция форматирования возврщает строку
        let formatter = NumberFormatter() //создаем форматтер
        formatter.numberStyle = .currency //формат валюты
        formatter.currencyCode = "USD" //доллары
        formatter.minimumFractionDigits = 2 //минимум 2 знака после запятой
        formatter.maximumFractionDigits = 2 //максимум 2 знака
        return formatter.string(from: NSNumber(value: price)) ?? "$0.00" //из double в класс любого типа числа  и превращает в строку ?? если не удалось то $0.00
    }
}
