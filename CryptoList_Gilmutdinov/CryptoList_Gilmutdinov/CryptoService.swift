import Foundation

protocol CryptoService {
    func fetchCryptos() async throws -> [Crypto]
}

struct RealCryptoService: CryptoService {
    
    func fetchCryptos() async throws -> [Crypto] {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let cryptos = try decoder.decode([Crypto].self, from: data)
        return cryptos
    }
}
