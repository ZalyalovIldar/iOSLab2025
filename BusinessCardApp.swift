//
//  BusinessCardApp.swift
//  
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI


@main
struct BusinessCardApp: App {
    var body: some Scene {
        WindowGroup {
            BusinessCardView()
        }
    }
}

struct BusinessCardViewApp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BusinessCardView()
                .preferredColorScheme(.light) // светлая тема
            BusinessCardView()
                .preferredColorScheme(.dark)  // тёмная тема
        }
    }
}

