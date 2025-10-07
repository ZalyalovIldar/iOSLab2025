//
//  ContentView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 05.10.2025.
//

import SwiftUI

struct MainScreenView: View {
    
    @State var viewModel = NoteViewModel()
    @State var showAddSheet = false
    @State private var noteToEdit: Note? = nil
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                TitleView()
                
                FormButtonView(showAddSheet: $showAddSheet)
                
                SortPickerView(viewModel: viewModel)
                
                NoteListView(viewModel: viewModel, noteToEdit: $noteToEdit)
                
            }
            .padding()
            .sheet(isPresented: $showAddSheet) {
                AddOrEditNoteView(viewModel: viewModel, isPresented: $showAddSheet)
            }
            .sheet(item: $noteToEdit) { note in
                AddOrEditNoteView(
                    viewModel: viewModel,
                    isPresented: Binding(
                        get: { noteToEdit != nil },
                        set: { if !$0 { noteToEdit = nil } }
                    ),
                    noteToEdit: note
                )
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search by title"
            )
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    MainScreenView()
}
