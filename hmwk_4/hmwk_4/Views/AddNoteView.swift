//
//  AddNoteView.swift
//  hmwk_4
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI

struct AddNoteView: View {
    @Bindable var viewModel: NotesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Заголовок", text: $viewModel.newTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextEditor(text: $viewModel.newContent)
                .frame(height: 80)
                .border(.gray)
            Button("Добавить заметочку") {
                viewModel.addNote()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.newTitle.isEmpty)
        }
        .padding()
    }
}

#Preview {
    AddNoteView(viewModel: NotesViewModel())
}

