//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

protocol NetworkService {
    func fetchData(from url: String) async throws -> Data
}
