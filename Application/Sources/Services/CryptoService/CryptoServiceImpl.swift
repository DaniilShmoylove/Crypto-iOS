//
//  ApiServices.swift
//  
//
//  Created by Daniil Shmoylove on 25.05.2022.
//

import SharedModel
import Resolver

//MARK: - CryptoService protocol

public protocol CryptoService {
    func fetchAllCurrentMetaData() async throws -> [Coin]?
    func fetchCoinData(for uuid: String) async throws -> CoinDetail?
}

//MARK: - CryptoServiceImpl

final public class CryptoServiceImpl: CryptoService {
    public init() { }
    
    @Injected private var cryptoRepository: CryptoRepository
    
    //MARK: - Fetch all current coin data
    
    public func fetchAllCurrentMetaData() async throws -> [Coin]? {
        let data = try await self.cryptoRepository.fetchAllCurrentMetaData()
        return data.data?.coins
    }
    
    //MARK: - Fetch coin detail data
    
    public func fetchCoinData(for uuid: String) async throws -> CoinDetail? {
        let data = try await self.cryptoRepository.fetchCoinData(for: uuid)
        return data?.data?.coin
    }
}
