//
//  WeatherDegreesView.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct WeatherDegreesView: View {
    let temprature: Double
    let fontSize: CGFloat
    let fontWeight: Font.Weight?
    
    init(temprature: Double, fontSize: CGFloat, fontWeight: Font.Weight? = nil) {
        self.temprature = temprature
        self.fontSize = fontSize
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        HStack(spacing: 1) {
            Text(String(format: "%.0f", temprature))
            Text("°")
        }
        .font(.system(size: fontSize, weight: fontWeight ?? .medium, design: .default))
    }
}

#Preview {
    WeatherDegreesView(temprature: 10, fontSize: 17)
}
