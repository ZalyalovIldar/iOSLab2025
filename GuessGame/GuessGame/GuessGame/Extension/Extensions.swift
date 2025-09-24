//
//  Extensions.swift
//  GuessGame
//
//  Created by Ляйсан on 21.09.2025.
//

import Foundation
import SwiftUI

extension Color {
    static var reddish = Color(red: 0.8078, green: 0.1255, blue: 0.1608)
    static var greenish = Color(red: 0.2980, green: 0.7333, blue: 0.0902)
}

extension View {
    func hideKeyboardOnTap() -> some View {
        onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
