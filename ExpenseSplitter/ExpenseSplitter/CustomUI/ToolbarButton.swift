//
//  ToolbarButton.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct ToolbarButton: View {
    var image: String
    var disabledCondition: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
           action()
        } label: {
            Image(systemName: image)
        }
        .disabled(disabledCondition)
    }
}
