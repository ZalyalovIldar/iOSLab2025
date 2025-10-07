import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.headline)
            Text(note.text)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}
