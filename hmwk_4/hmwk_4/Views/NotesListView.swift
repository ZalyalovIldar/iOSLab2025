//
//  NotesListView.swift
//  hmwk_4
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI

struct NotesListView: View {
    @Bindable var viewModel: NotesViewModel

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Поиск по заголовку", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Text("Найдено заметок: \(viewModel.filterNotes.count)")
                    .padding(.bottom, 5)

                Picker("Сортировка", selection: $viewModel.sortOrder) {
                    Text("Без сортировки").tag(NotesViewModel.SortOrder.none)
                    Text("По названию ↑").tag(NotesViewModel.SortOrder.titleAsc)
                    Text("По дате ↓").tag(NotesViewModel.SortOrder.dateDesc)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(viewModel.filterNotes) { note in
                        NavigationLink(destination: EditNoteView(viewModel: viewModel, note: note)) {
                            NoteRowView(note: note)
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }

                AddNoteView(viewModel: viewModel)
            }
            .navigationTitle("Заметочки")
            .onAppear { viewModel.loadNotes() }
        }
    }
}
