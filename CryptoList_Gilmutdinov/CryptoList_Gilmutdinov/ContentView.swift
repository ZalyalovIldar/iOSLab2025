import SwiftUI
import Observation


struct ContentView: View {
    @State private var viewModel = CryptoListViewModel(service: RealCryptoService())
    
    var body: some View {
        NavigationStack {
            CryptoListScreen(viewModel: viewModel)
                .navigationTitle("CryptoList")
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
struct CryptoListScreen: View {
    
    @Bindable var viewModel: CryptoListViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.error {
                errorView(message: errorMessage)
            } else if viewModel.items.isEmpty {
                emptyView
            } else {
                CryptoListView(cryptos: viewModel.items)
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Загрузка...")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text("Произошла ошибка")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                Task {
                    await viewModel.retry()
                }
            } label: {
                Text("Повторить")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack(spacing: 8) {
            Text("Нет данных")
                .font(.headline)
            Text("Попробуйте перезапустить приложение или проверить интернет.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct CryptoListView: View {
    
    let cryptos: [Crypto]
    
    var body: some View {
        List(cryptos) { crypto in
            CryptoRowView(crypto: crypto)
        }
    }
}

struct CryptoRowView: View {
    
    let crypto: Crypto
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: crypto.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 40, height: 40)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crypto.name)
                    .font(.headline)
                
                Text(crypto.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            Text(String(format: "$%.2f", crypto.currentPrice))
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}
