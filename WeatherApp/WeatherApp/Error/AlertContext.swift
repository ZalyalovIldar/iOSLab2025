//
//  AlertContext.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

struct AlertContext {
    static let invalidURL = AlertItem(title: "Server Error", message: "There was an issue connecting to the server. If this persists, please contact support.")
    
    static let invalidResponse = AlertItem(title: "Server Error", message: "Invalid Response from the server. Please try again later or contact support.")
    
    static func badStatusCode(_ statusCode: Int) -> AlertItem {
        AlertItem(title: "Server Error", message: "The server responded with status code: \(statusCode).")
    }
    
    static let invalidData = AlertItem(title: "Server Error", message: "The data received from the eserver was invalid. Please contact support.")
}
