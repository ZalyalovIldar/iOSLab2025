//
//  ContentUnavailableView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct ContentUnavailableView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("oops, no added expenses yet")
                .foregroundStyle(.white.opacity(0.8))
                .font(.subheadline)
            Spacer()
        }
    }
}

#Preview {
    ContentUnavailableView()
}
