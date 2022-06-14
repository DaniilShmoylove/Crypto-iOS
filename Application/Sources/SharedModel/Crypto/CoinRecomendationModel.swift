//
//  CoinRecomendationModel.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import Foundation

//MARK: - Typealias

public typealias BestCoins = [EstCoin]

// MARK: - BestCoin

public struct BestCoin: Codable {
    public let status: String?
    public let data: DataBestClass?
}

// MARK: - DataClass

public struct DataBestClass: Codable {
    public let totalCoins, totalMarkets, totalExchanges: Int?
    public let totalMarketCap, total24HVolume: String?
    public let btcDominance: Double?
    public let bestCoins, newestCoins: [EstCoin]?

    public enum CodingKeys: String, CodingKey {
        case totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
        case btcDominance, bestCoins, newestCoins
    }
}

// MARK: - EstCoin

public struct EstCoin: Codable, Hashable {
    public let uuid, symbol, name: String?
    public let iconURL: String?
    public let coinrankingURL: String?

    public enum CodingKeys: String, CodingKey {
        case uuid, symbol, name
        case iconURL = "iconUrl"
        case coinrankingURL = "coinrankingUrl"
    }
}
