//
//  SortButton.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct SortButton: View {
    let image: String
    let text: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                Text(text)
            }
        }
    }
}
