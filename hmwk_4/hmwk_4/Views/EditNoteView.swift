//
//  EditNoteView.swift
//  hmwk_4
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI

struct EditNoteView: View {
    @Bindable var viewModel: NotesViewModel
    let note: Note
    
    @State private var titleText: String
    @State private var contentText: String
    @Environment(\.dismiss)
    private var dismiss

    init(viewModel: NotesViewModel, note: Note) {
        self._viewModel = Bindable(wrappedValue: viewModel)
        self.note = note
        _titleText = State(initialValue: note.title)
        _contentText = State(initialValue: note.content)
    }
    
    var body: some View {
        Form {
            Section("Заголовок") {
                TextField("Заголовок", text: $titleText)
            }
            Section("Содержание") {
                TextEditor(text: $contentText)
                    .frame(minHeight: 180)
            }
        }
        .navigationTitle("Редактировать")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить") {
                    let trimmedTitle = titleText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedTitle.isEmpty else { return }
                    viewModel.update(note: note, newTitle: trimmedTitle, newContent: contentText)
                    dismiss()
                }
                .disabled(titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}
