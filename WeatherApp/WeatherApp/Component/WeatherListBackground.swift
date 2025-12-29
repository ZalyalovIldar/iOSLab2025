//
//  WeatherListBackground.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct WeatherListBackground: View {
    let colors: [Color]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    WeatherListBackground(colors: [.dBackground, .lBackground])
}
