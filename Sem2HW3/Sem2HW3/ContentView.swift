import SwiftUI
import Kingfisher
import UIComponents

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Работа с библиотеками")
                    .font(.title2)

                UserCardView(
                    name: "Tom Hardy",
                    imageURL: "https://picsum.photos/200"
                )

                LoadingView()

                KFImage(URL(string: "https://picsum.photos/300"))
                    .placeholder { ProgressView() }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(12)

                AsyncImg(imageURL: "https://picsum.photos/250")
                    .frame(width: 150, height: 150)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
