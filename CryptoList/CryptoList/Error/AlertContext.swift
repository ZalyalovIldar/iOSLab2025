//
//  AlertContext.swift
//  CryptoList
//
//  Created by Ляйсан
//

import Foundation

struct AlertContext {
    static let invalidURL = AlertItem(title: "Server Error", message: "There was an issue connecting to the server. If this persists, please contact support@igrco.com")
    
    static let invalidResponse = AlertItem(title: "Server Error", message: "Invalid Response from the server. Please try again later or contact support.")
    
    static func badStatusCode(_ code: Int) -> AlertItem {
        AlertItem(title: "Server Error", message: "The server responded with status code: \(code).")
    }
    
    static let invalidData = AlertItem(title: "Server Error", message: "The data received from the eserver was invalid. Please contact support.")
    
    static let decodingError = AlertItem(title: "Data Error", message: "Failed to decode the received data. Please try again or contact support.")
    
    static let unableToComplete = AlertItem(title: "Server Error", message: "Unable to complete your request at this time. Please check your internet connection and try again.")
}
