//
//  WalletViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 17.06.2022.
//

import Foundation
import Resolver
import Services
import SharedModel

final class WalletViewModel: ObservableObject {
    init() { }
    
    //MARK: - Crypto Service
    
    @Injected private var cryptoService: CryptoService
    
    //MARK: - All crypto data
    
    @Published private(set) var allCurrentMetaData: [Coin]? = nil
    
    //MARK: - Coin detail data
    
    @Published private(set) var coinDetailData: CoinDetail? = nil
}

extension WalletViewModel {
    
    //MARK: - Fetch all current coin data
    
    @MainActor
    func fetchAllCurrentMetaData() async throws {
        guard self.allCurrentMetaData == nil else { return }
        self.allCurrentMetaData = try await self.cryptoService.fetchAllCurrentMetaData()
    }
    
    //MARK: - Fetch coin detail data
    
    @MainActor
    func fetchCoinData(for uuid: String) async throws {
        guard self.coinDetailData?.uuid != uuid else { return }
        self.coinDetailData = try await self.cryptoService.fetchCoinData(for: uuid)
    }
    
    //MARK: - Clear coin detail data
    
    func clearCoinDetailData() { self.coinDetailData = nil }
}

import Alamofire

//MARK: - Reachable actions

extension WalletViewModel {
    func reachable(
        for networkReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus
    ) {
        Task {
            switch networkReachabilityStatus {
            case .unknown:
                print("unknown")
            case .notReachable:
                print("notReachable")
            case .reachable:
                do {
                    try await self.fetchAllCurrentMetaData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
