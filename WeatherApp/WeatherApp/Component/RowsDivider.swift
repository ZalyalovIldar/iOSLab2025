//
//  RowsDivider.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct RowsDivider: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.white.opacity(0.65))
            .frame(width: 334, height: 0.3)
    }
}

#Preview {
    RowsDivider()
}
