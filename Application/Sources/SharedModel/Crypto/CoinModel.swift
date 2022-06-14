//
//  CoinModel.swift
//  
//
//  Created by Daniil Shmoylove on 02.06.2022.
//

import Foundation

// MARK: - CoinModel

public struct CoinsModel: Codable {
    public let status: String?
    public let data: DataClass?
}

// MARK: - DataClass

public struct DataClass: Codable {
    public let stats: Stats?
    public let coins: [Coin]?
}

// MARK: - Coin

public struct Coin: Codable, Hashable {
    public let uuid, symbol, name, color: String?
    public let iconURL: String?
    public let marketCap, price, btcPrice: String?
    public let listedAt: Int?
    public let change: String?
    public let rank: Int?
    public let sparkline: [String]?
    public let coinrankingURL: String?
    public let the24HVolume: String?

    public enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color
        case iconURL = "iconUrl"
        case marketCap, price, btcPrice, listedAt, change, rank, sparkline
        case coinrankingURL = "coinrankingUrl"
        case the24HVolume = "24hVolume"
    }
}

// MARK: - Stats

public struct Stats: Codable {
    public let total, totalCoins, totalMarkets, totalExchanges: Int?
    public let totalMarketCap, total24HVolume: String?

    public enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}
