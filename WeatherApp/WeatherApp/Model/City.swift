//
//  City.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

struct City {
    let name: String
    let latitude: Double
    let longitude: Double
    
    static let cities: [City] = [
            City(name: "Kazan", latitude: 55.7964, longitude: 49.1089),
            City(name: "London", latitude: 51.5074, longitude: -0.1278),
            City(name: "Paris", latitude: 48.8566, longitude: 2.3522),
            City(name: "Tokyo", latitude: 35.6895, longitude: 139.6917),
            City(name: "New York", latitude: 40.7128, longitude: -74.0060),
            City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
            City(name: "Sydney", latitude: -33.8688, longitude: 151.2093),
            City(name: "Berlin", latitude: 52.5200, longitude: 13.4050),
            City(name: "Rome", latitude: 41.9028, longitude: 12.4964),
            City(name: "Madrid", latitude: 40.4168, longitude: -3.7038),
            City(name: "Singapore", latitude: 1.3521, longitude: 103.8198),
            City(name: "Toronto", latitude: 43.6532, longitude: -79.3832),
            City(name: "Seoul", latitude: 37.5665, longitude: 126.9780),
            City(name: "Cairo", latitude: 30.0444, longitude: 31.2357),
            City(name: "Mumbai", latitude: 19.0760, longitude: 72.8777),
            City(name: "São Paulo", latitude: -23.5505, longitude: -46.6333),
            City(name: "Istanbul", latitude: 41.0082, longitude: 28.9784),
            City(name: "Dubai", latitude: 25.2048, longitude: 55.2708),
            City(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041),
            City(name: "Stockholm", latitude: 59.3293, longitude: 18.0686)
    ]
}
