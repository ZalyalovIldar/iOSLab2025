//
//  AddOrEditNoteView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct AddOrEditNoteView: View {
    
    @Bindable var viewModel: NoteViewModel
    @Binding var isPresented: Bool
    
    var noteToEdit: Note? = nil
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            HStack {
                Text(noteToEdit == nil ? "New Note" : "Edit Note")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(colors: [.blue, .purple],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.8))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(spacing: 14) {
                TextField("Title", text: $viewModel.newNoteName)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                
                TextField("Content", text: $viewModel.newNoteText, axis: .vertical)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            }
            .padding(.horizontal)
            
            if let error = viewModel.formErrorMessage {
                Text(error)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.1)))
                    .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                viewModel.saveNote(editing: noteToEdit)
                if viewModel.formErrorMessage == nil {
                    isPresented = false
                }
            } label: {
                Text(noteToEdit == nil ? "Add Note" : "Save Changes")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [.blue, .purple],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                            .cornerRadius(14)
                    )
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.top)
        .onAppear {
            if let note = noteToEdit {
                viewModel.newNoteName = note.title
                viewModel.newNoteText = note.text
            } else {
                viewModel.newNoteName = ""
                viewModel.newNoteText = ""
            }
            viewModel.hasAttemptedSubbmit = false
        }
    }
}

#Preview {
    AddOrEditNoteView(viewModel: NoteViewModel(), isPresented: .constant(true))
}
