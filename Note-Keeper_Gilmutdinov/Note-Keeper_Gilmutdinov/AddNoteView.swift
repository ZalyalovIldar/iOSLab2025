import SwiftUI
import Observation

struct AddNoteView: View {
    @Bindable var viewModel: NotesViewModel
    @Binding var isPresented: Bool
    
    @State private var title: String = ""
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Заголовок", text:$title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextEditor(text: $text)
                .frame(height: 120)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
            
            HStack {
                Button("Отмена") {
                    isPresented = false
                }
                .font(.headline)
                .foregroundStyle(.secondary)
                
                Spacer()
                
                Button("Добавить") {
                    viewModel.addNote(title: title, text: text)
                    isPresented = false
                }
                .font(.headline)
                .foregroundStyle(.blue)
                .disabled(title.isEmpty || text.isEmpty)
            }
            .padding(.horizontal)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
