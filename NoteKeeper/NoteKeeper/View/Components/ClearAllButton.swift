//
//  ClearAllButton.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct ClearAllButton: View {
    
    @Bindable var viewModel: NoteViewModel
    
    @State var showConfirmation: Bool = false
    
    var body: some View {
        
        Button {
            showConfirmation = true
        } label: {
            HStack {
                
                Image(systemName: "trash")
                Text("Clear All")
                
            }
            .foregroundStyle(.red)
            .font(.system(size: 16))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray5))
                    .frame(width: 115, height: 27)
            )
        }
        .alert("Delete All notes?", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All") {
                viewModel.deleteAllNotes()
            }
        } message: {
            Text("This will permanently delete all \(viewModel.totalNotesCount) notes. This action cannot be undone.")
        }
    }
}

#Preview {
    ClearAllButton(viewModel: NoteViewModel(), showConfirmation: false)
}
