//
//  CoinModel.swift
//  
//
//  Created by Daniil Shmoylove on 02.06.2022.
//

import Foundation

//MARK: - Typealias for CoinModelElement

//public typealias CoinsModel = [Coin]

// MARK: - CoinModelElement
//
//public struct Coin: Codable, Hashable {
//    public let assetID: String?
//    public let name: String?
//    public let typeIsCrypto: Int?
//    public let dataQuoteStart: String?
//    public let dataQuoteEnd: String?
//    public let dataOrderbookStart: String?
//    public let dataOrderbookEnd: String?
//    public let dataTradeStart: String?
//    public let dataTradeEnd: String?
//    public let dataSymbolsCount: Int?
//    public let volume1HrsUsd: Double?
//    public let volume1DayUsd: Double?
//    public let volume1MthUsd: Double?
//    public let priceUsd: Double?
//    public let idIcon: String?
//    public let dataStart: String?
//    public let dataEnd: String?
//
//    enum CodingKeys: String, CodingKey {
//        case assetID = "asset_id"
//        case name = "name"
//        case typeIsCrypto = "type_is_crypto"
//        case dataStart = "data_start"
//        case dataEnd = "data_end"
//        case dataQuoteStart = "data_quote_start"
//        case dataQuoteEnd = "data_quote_end"
//        case dataOrderbookStart = "data_orderbook_start"
//        case dataOrderbookEnd = "data_orderbook_end"
//        case dataTradeStart = "data_trade_start"
//        case dataTradeEnd = "data_trade_end"
//        case dataSymbolsCount = "data_symbols_count"
//        case volume1HrsUsd = "volume_1hrs_usd"
//        case volume1DayUsd = "volume_1day_usd"
//        case volume1MthUsd = "volume_1mth_usd"
//        case priceUsd = "price_usd"
//        case idIcon = "id_icon"
//    }
//}

//import Foundation

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




//MARK: - Coin

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




//MARK: - BEST COINS

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


public typealias BestCoins = [EstCoin]

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
