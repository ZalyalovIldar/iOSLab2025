//
//  StarSkyView.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct StarSkyView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.dark, .middle, .light], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            ForEach(0..<60) { _ in
                let x = CGFloat.random(in: 0..<400)
                let y = CGFloat.random(in: 0..<400)
                Circle()
                    .fill(LinearGradient(colors: [.white, .white.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: CGFloat.random(in: 1...2), height: CGFloat.random(in: 1...2))
                    .position(x: x, y: y)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StarSkyView()
}
