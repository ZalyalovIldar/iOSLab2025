import SwiftUI

struct AddNoteView: View {
    @State private var title = ""
    @State private var text = ""
    let onSave: (String, String) -> Void
    
    var body: some View {
        VStack {
            TextField("Заголовок", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Текст заметки", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Добавить заметку") {
                if !title.isEmpty {
                    onSave(title, text)
                    title = ""
                    text = ""
                }
            }
            .padding()
            .disabled(title.isEmpty)
        }
        .padding(.vertical)
    }
}
