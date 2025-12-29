//
//  AlertItem.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
