//
//  CryptoRepository.swift
//  
//
//  Created by Daniil Shmoylove on 17.06.2022.
//

import Foundation
import SharedModel
import ApiClient
import Resolver

//MARK: - CryptoRepository protocol

public protocol CryptoRepository {
    func fetchAllCurrentMetaData() async throws -> CoinsModel
    func fetchCoinData(for uuid: String) async throws -> CoinDetailModel?
}

//MARK: - CryptoRepository

final public class CryptoRepositoryImpl: CryptoRepository {
    public init() { decoder = JSONDecoder() }
    
    //MARK: - ApiClient
    
    @Injected private var apiClient: ApiClientProtocol
    
    //MARK: - JSONDecoder
    
    private var decoder: JSONDecoder
    
    //MARK: - Fetch all current coin data
    
    public func fetchAllCurrentMetaData() async throws -> CoinsModel {
        let urlRequest = try CryptoRouter.getAllCurrentMetaData.asURLRequest()
        let data = try await apiClient.perform(urlRequest)
        let response = try decoder.decode(CoinsModel.self, from: data)
        return response
    }
    
    //MARK: - Fetch coin detail data
    
    public func fetchCoinData(for uuid: String) async throws -> CoinDetailModel? {
        let urlRequest = try CryptoRouter.getCoinData(for: uuid).asURLRequest()
        let data = try await self.apiClient.perform(urlRequest)
        let response = try self.decoder.decode(CoinDetailModel.self, from: data)
        return response
    }
}
