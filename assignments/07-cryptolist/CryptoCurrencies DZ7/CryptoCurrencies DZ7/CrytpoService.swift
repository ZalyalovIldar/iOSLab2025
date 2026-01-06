//
//  CrytpoService.swift
//  CryptoCurrencies DZ7
//
//  Created by Иван Метальников on 06.01.2026.
//

import Foundation


protocol CrytpoService {
    func fetchCryptos() async throws -> [Crypto]
}

enum CryptoServiceError: Error, Equatable{
    case invalidError
}


class RealCryptoService: CrytpoService{
    private let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    private lazy var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCryptos() async throws -> [Crypto] {
        guard let url = URL(string: url) else {
            throw CryptoServiceError.invalidError
        }
        
        do {
            let urlRequest = URLRequest(url: url)
            
            let (data, _) = try await session.data(for: urlRequest)
            
            return try jsonDecoder.decode([Crypto].self, from: data)
        }
        catch {
            throw CryptoServiceError.invalidError
        }
    }
}
