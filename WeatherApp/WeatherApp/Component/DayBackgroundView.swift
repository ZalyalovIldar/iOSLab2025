//
//  DayBackgroundView.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct DayBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.dayDark, .dayMiddle, .dayLight], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Circle()
                .fill(.cloudDark)
                .frame(width: 360, height: 100)
                .blur(radius: 40)
                .position(x: 60, y: 170)
            Circle()
                .fill(.cloudLight)
                .frame(width: 360, height: 100)
                .blur(radius: 35)
                .position(x: 150, y: 120)
            Circle()
                .fill(.cloudExtraLight.opacity(0.7))
                .frame(width: 360, height: 100)
                .blur(radius: 40)
                .position(x: 220, y: 180)
            Circle()
                .fill(.cloudDark)
                .frame(width: 360, height: 100)
                .blur(radius: 40)
                .position(x: 320, y: 230)
            Circle()
                .fill(.cloudDark)
                .frame(width: 360, height: 100)
                .blur(radius: 40)
                .position(x: 370, y: 30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    DayBackgroundView()
}
