//
//  NotesCountView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct NotesCountView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        
        Text("Notes count: \(viewModel.filteredNotes.count)")
            .font(.system(size: 16))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray5))
                    .frame(width: 120, height: 27)
            )
    }
}

#Preview {
    NotesCountView(viewModel: NoteViewModel())
}
