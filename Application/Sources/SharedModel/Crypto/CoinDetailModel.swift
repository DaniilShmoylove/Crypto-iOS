//
//  CoinDetailModel.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import Foundation

// MARK: - CoinModel

public struct CoinDetailModel: Codable {
    public let status: String?
    public let data: DataDetailClass?
}

// MARK: - DataClass

public struct DataDetailClass: Codable {
    public let coin: CoinDetail?
}

// MARK: - Coin

public struct CoinDetail: Codable {
    public let uuid, symbol, name, coinDescription: String?
    public let color: String?
    public let iconURL: String?
    public let websiteURL: String?
    public let links: [Link]?
    public let supply: Supply?
    public let the24HVolume, marketCap, price, btcPrice: String?
    public let priceAt: Int?
    public let change: String?
    public let rank, numberOfMarkets, numberOfExchanges, listedAt: Int?
    public let sparkline: [String]?
    public let allTimeHigh: AllTimeHigh?
    public let coinrankingURL: String?
    
    public var doubleSparkLine: [Double] {
        guard let data = self.sparkline else { return [0] }
        return data.map { ($0 as NSString).doubleValue }
    }

    public enum CodingKeys: String, CodingKey {
        case uuid, symbol, name
        case coinDescription = "description"
        case color
        case iconURL = "iconUrl"
        case websiteURL = "websiteUrl"
        case links, supply
        case the24HVolume = "24hVolume"
        case marketCap, price, btcPrice, priceAt, change, rank, numberOfMarkets, numberOfExchanges, listedAt, sparkline, allTimeHigh
        case coinrankingURL = "coinrankingUrl"
    }
}

// MARK: - AllTimeHigh

public struct AllTimeHigh: Codable {
    public let price: String?
    public let timestamp: Int?
}

// MARK: - Link

public struct Link: Codable {
    public let name: String?
    public let url: String?
    public let type: String?
}

// MARK: - Supply

public struct Supply: Codable {
    public let confirmed: Bool?
    public let circulating, total: String?
}
