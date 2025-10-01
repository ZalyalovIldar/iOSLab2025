//
//  TitleView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct TitleView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


