//
//  NotesView.swift
//  NoteKeeper
//
//  Created by Ляйсан on 01.10.2025.
//

import SwiftUI

struct NotesView: View {
    @State var notesViewModel: NotesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if !notesViewModel.filteredNotes.isEmpty {
                    VStack {
                        title
                        notesList
                        Spacer()
                    }
                } else if notesViewModel.notes.isEmpty {
                    emptyNotesCaseView
                } else {
                    ContentUnavailableView.search
                }
            }
            .background {
                Color(.lBlue).ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Menu {
                            Section {
                                Button {
                                    notesViewModel.sortByNewestFirst()
                                } label: {
                                    HStack {
                                        Image(systemName: notesViewModel.sortedByNewest ? "checkmark" : "")
                                        Text("Newest First")
                                    }
                                }
                                Button {
                                    notesViewModel.sortByOldestFirst()
                                } label: {
                                    HStack {
                                        Image(systemName: notesViewModel.sortedByNewest ? "" : "checkmark")
                                        Text("Oldest First")
                                    }
                                }
                            }
                            Section {
                                Button {
                                    notesViewModel.sortedByTitle.toggle()
                                } label: {
                                    HStack {
                                        if notesViewModel.sortedByTitle {
                                            Image(systemName: "checkmark" )
                                            Text("Title")
                                        } else {
                                            Text("        Title")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sort By")
                            }
                        }
                        Button("Delete All", systemImage: "trash", role: .destructive) {
                            notesViewModel.deleteAllNotes()
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                if !notesViewModel.notes.isEmpty {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 13))
                                .foregroundStyle(.tertiary)
                                .padding(.leading, 10)
                            TextField("Search", text: $notesViewModel.searchText)
                                
                        }
                    }
                }
                
                ToolbarSpacer(.flexible, placement: .bottomBar)

                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        CreateNoteView(notesViewModel: notesViewModel)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var title: some View {
        Text("Notes")
            .font(.largeTitle)
            .bold()
            .padding(.horizontal, 20)
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
        Text("Total: \(notesViewModel.notesCount)")
            .foregroundStyle(.secondary)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var notesList: some View {
        List {
            ForEach(notesViewModel.filteredNotes) { note in
                NavigationLink {
                    NoteView(noteViewModel: notesViewModel, note: note)
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                        Text(note.text)
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        notesViewModel.deleteNote(note)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private var emptyNotesCaseView: some View {
        ContentUnavailableView {
            Label("No notes", systemImage: "text.page.badge.magnifyingglass")
        } description: {
            Text("Tap the + button to create your first note.")
        } actions: {
            NavigationLink {
                CreateNoteView(notesViewModel: notesViewModel)
            } label: {
                Text("New Note+")
                    .foregroundStyle(.white)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.blue)
                            .glassEffect()
                    }
            }
        }
    }
}

#Preview {
    NotesView(notesViewModel: NotesViewModel())
}
