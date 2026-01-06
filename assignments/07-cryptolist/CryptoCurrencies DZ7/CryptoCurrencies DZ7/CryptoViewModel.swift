//
//  CryptoViewModel.swift
//  CryptoCurrencies DZ7
//
//  Created by Иван Метальников on 06.01.2026.
//

import Foundation


@Observable
final class CryptoViewModel{
    private let service: CrytpoService
    
    var cryptos: [Crypto] = []
    var state: State = .loading
    
    enum State {
        case loading
        case content
        case error(String)
    }
    
    init(service: CrytpoService) {
        self.service = service
    }
    
    func load() async {
        do {
            self.cryptos = try await service.fetchCryptos()
            self.state = .content
        }
        catch {
            self.cryptos = []
            self.state = .error("Ошибка при загрузке")
        }
    }
}
