import SwiftUI

struct RecipeTileView: View {
    let recipe: Recipe
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                    
                    Image(systemName: recipe.imageName.isEmpty ? "photo" : recipe.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(18)
                }
                .frame(height: 90)
                
                Text(recipe.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                Spacer(minLength: 0)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(.red.opacity(0.8))
                    .padding(6)
            }
        }
    }
}

#Preview {
    RecipeTileView(
        recipe: Recipe.demo.first!,
        onRemove: {}
    )
    .padding()
    .previewLayout(.sizeThatFits)
}
