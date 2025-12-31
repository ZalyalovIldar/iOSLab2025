import Foundation
import Observation

@MainActor
@Observable
final class CryptoListViewModel {
    
    var items: [Crypto] = []
    
    var isLoading: Bool = false
    
    var error: String? = nil
    
    private let service: CryptoService
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func load() async {
        if isLoading { return }
        
        isLoading = true
        error = nil
        
        do {
            let cryptos = try await service.fetchCryptos()
            self.items = cryptos
        } catch {
            self.error = error.localizedDescription
            self.items = []
        }
        
        isLoading = false
    }
    
    func retry() async {
        await load()
    }
}
