//
//  Double.swift
//  CryptoList
//
//  Created by Ляйсан
//

import Foundation

extension Double {
    func formattToDollar() -> String {
        let number = NSNumber(value: self)
        return currencyFormatterSixDecimals.string(for: number) ?? "$0.00"
    }
    
    func formattToPercent() -> String {
        String(format: "%.2f", self) + "%"
    }
    
    private var currencyFormatterSixDecimals: Formatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
}
