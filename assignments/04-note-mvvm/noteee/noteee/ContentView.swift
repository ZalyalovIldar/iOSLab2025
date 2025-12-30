//
//  ContentView.swift
//  notee
//


import SwiftUI
import Observation

struct Note: Identifiable {
    let id: UUID = UUID()
    var text: String
    var title: String
    let create_date: Date = Date()
}

@Observable
final class NewNote{
    var notes:[Note] = []
    var text_in: String = ""
    var title_in: String = ""
    
    func add(){
        guard !title_in.isEmpty, !text_in.isEmpty else { return }
        notes.insert(Note(text: text_in, title: title_in), at: 0)
        text_in = ""
        title_in = ""
    }
    

    func delete(at offsets: IndexSet){
        notes.remove(atOffsets: offsets)
    }
}



struct ContentView: View {
    @State private var new_note = NewNote()
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.green.opacity(0.35),
                        Color.yellow.opacity(0.35),
                        Color.orange.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack(spacing: 16) {
                    AddNote(new_note: new_note)
                    NotesList(new_note: new_note)
                }
                .font(.system(.body, design: .serif))
                .padding()
            }
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Заметки")
                        .font(.system(.headline, design: .serif))
                }
            }
            
            //.navigationTitle("Заметки")
            .tint(.orange)
        }
    }
}

struct NotesList: View {
    @Bindable var new_note: NewNote

    var body: some View {
        if new_note.notes.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "note.text")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)

                Text("Заметок пока нет")
                    .font(.headline)

                Text("Добавьте первую заметку выше.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 16)
        } else {
            List {
                ForEach(new_note.notes) { note in
                    NoteRow(note: note)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: new_note.delete)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
}



struct NoteRow: View {
    let note: Note
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.system(.headline, design: .serif))

            if !note.text.isEmpty {
                Text(note.text)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.vertical, 6)
    }
}


struct AddNote: View {
    @Bindable var new_note: NewNote
    var body: some View{
        VStack(spacing:12){
            TextField("Заголовок", text: $new_note.title_in)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Текст", text: $new_note.text_in)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Добавить"){
                new_note.add()
            }
            //.buttonStyle(PlainButtonStyle())
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(25)
        .background(Color.white.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        //.padding(.vertical, 6)
        .padding(12)
        //.background(.ultraThinMaterial)
        //.frame(maxWidth: .infinity)
        //.clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
}




#Preview {
    ContentView()
}

