import SwiftUI

struct EmptyPlaceholderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.title3)
                .bold()
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding()
    }
}

#Preview {
    EmptyPlaceholderView(
        title: "Список пуст",
        subtitle: "Нажмите на кнопку «+», чтобы добавить первый рецепт."
    )
}
