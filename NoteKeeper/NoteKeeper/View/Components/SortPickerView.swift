//
//  SortPickerView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct SortPickerView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        
        HStack {
            
            Text("Sort:")
                .font(.subheadline)
            
            Picker("Sort by:", selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(.menu)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.gray.opacity(0.2))
                    
            )
        }
    }
}

#Preview {
    SortPickerView(viewModel: NoteViewModel())
}
