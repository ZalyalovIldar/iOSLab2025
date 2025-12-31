import SwiftUI
import Observation

struct BooksRootView: View {
    @State private var viewModel = BooksViewModel(
        storage: UserDefaultsBookStorage()
    )
    
    var body: some View {
        NavigationStack {
            BooksScreen(viewModel: viewModel)
                .navigationTitle("Избранные книги")
        }
    }
}

#Preview {
    BooksRootView()
}

struct BooksScreen: View {
    
    @Bindable var viewModel: BooksViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            AddBookForm(
                title: $viewModel.newTitle,
                author: $viewModel.newAuthor,
                note: $viewModel.newNote,
                onAdd: viewModel.addBook
            )
            .padding()
            
            Divider()
            
            BooksList(
                items: viewModel.books,
                onDelete: viewModel.deleteBooks(at:)
            )
        }
    }
}

struct AddBookForm: View {
    
    @Binding var title: String
    @Binding var author: String
    @Binding var note: String
    let onAdd: () -> Void
    
    private var isAddButtonDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Новая книга")
                .font(.headline)
            
            TextField("Название", text: $title)
                .textFieldStyle(.roundedBorder)
            
            TextField("Автор (по желанию)", text: $author)
                .textFieldStyle(.roundedBorder)
            
            TextField("Заметка (необязательно)", text: $note)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Spacer()
                Button {
                    onAdd()
                } label: {
                    Text("Добавить")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isAddButtonDisabled ? Color.gray : Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .disabled(isAddButtonDisabled)
            }
        }
    }
}

struct BooksList: View {
    
    let items: [Book]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        if items.isEmpty {
            VStack(spacing: 8) {
                Text("Список пуст")
                    .font(.headline)
                Text("Добавьте первую книгу через форму выше.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(items) { book in
                    BookRowView(book: book)
                }
                .onDelete(perform: onDelete)
            }
            .listStyle(.plain)
        }
    }
}

struct BookRowView: View {
    
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
            
            if !book.author.isEmpty {
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if !book.note.isEmpty {
                Text(book.note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
