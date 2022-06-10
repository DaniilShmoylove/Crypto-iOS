//
//  ApiServices.swift
//  
//
//  Created by Daniil Shmoylove on 25.05.2022.
//

import SwiftUI
import Alamofire

final public class CryptoService: ObservableObject {
    public init() { }
    
    //MARK: - All crypto data
    
    @Published public var allCurrentMetaData: [Coin]? = nil
    
    //MARK: - Coin detail data
    
    @Published public var coinDetailData: CoinDetail? = nil
    
    //MARK: - Fetch crypto data
    
    //TODO: - Обработать ошибки throws
    
    public func fetchAllCurrentMetaData() throws {
        guard self.allCurrentMetaData == nil else { return }
        AF.request(CryptoRouter.getAllCurrentMetaData)
            .validate()
            .responseDecodable(of: CoinsModel.self) { (response) in
                guard let data = response.value else { return }
                self.allCurrentMetaData = data.data?.coins
            }
    }
    
    public func fetchAllCoinsList(for uuid: String) throws {
        guard self.allCurrentMetaData == nil else { return }
        AF.request(CryptoRouter.getCoinData(for: uuid))
            .validate()
            .responseDecodable(of: CoinsModel.self) { (response) in
//                guard let data = response.value else { return }
//                self.allCurrentMetaData = data.data?.coins
            }
    }
    
    //MARK: - Fetch detail coin data
    
    public func fetchCoinData(
        for item: String
    ) throws {
        guard self.coinDetailData == nil else { return }
        AF.request(CryptoRouter.getCoinData(for: item))
            .validate()
            .responseDecodable(of: CoinDetailModel.self) { (response) in
                guard let data = response.value else { return }
                self.coinDetailData = data.data?.coin
            }
    }
    
    //MARK: - Reachable actions
    
    public func reachable(
        for networkReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus
    ) {
        switch networkReachabilityStatus {
        case .unknown:
            print("")
        case .notReachable:
            print("")
        case .reachable:
            do {
                try self.fetchAllCurrentMetaData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
