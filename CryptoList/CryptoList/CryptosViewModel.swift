//
//  CryptosViewModel.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 23.12.2025.
//

import Foundation

@Observable
final class CryptosViewModel {
    
    enum State: Equatable {
        case loading
        case empty
        case content
        case error(String)
    }
    
    var cryptos: [Crypto] = []
    var state: State = .loading
    
    private let service: CryptoService
    
    init(cryptos: [Crypto] = [], service: CryptoService) {
        self.cryptos = cryptos
        self.service = service
    }
    
    func load() async {
        do {
            cryptos = try await service.obtainCryptos()
            state = cryptos.isEmpty ? .empty : .content
        }
        catch NetworkError.decodingFailed {
            cryptos = []
            state = .error("Failed to decode data")
        }
        catch let NetworkError.badStatusCode(code) {
            cryptos = []
            state = .error("Bad status code: \(code)")
        }
        catch {
            cryptos = []
            state = .error("Unexpected error")
        }
                
    }
    
}
