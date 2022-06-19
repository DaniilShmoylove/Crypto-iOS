//
//  CryptoRouter.swift
//  
//
//  Created by Daniil Shmoylove on 02.06.2022.
//

import Foundation
import Alamofire
import Core

internal enum CryptoRouter {
    
    //MARK: - Router cases
    
    case getAllCurrentMetaData
    case getBestCoins
    case getCoinData(for: String)
    case getHistoricalData(for: String)
    
    //MARK: - Base request URL
    
    private var baseURL: URL { URL(string: "https://api.coinranking.com")! }
    
    //MARK: - Headers
    
    private var headers: HTTPHeaders { [
        "x-access-token": AppKeys.API.key   
    ] }
    
    //MARK: - Get path
    
    private var path: String {
        switch self {
        case let .getCoinData(for: uuid):
            return "/v2/coin/\(uuid)"
        case .getAllCurrentMetaData:
            return "/v2/coins"
        case .getBestCoins:
            return "/v2//stats"
        case let .getHistoricalData(for: uuid):
            return "/v2/coin/\(uuid)/history"
        }
    }
    
    //MARK: - Get HTTP method
    
    private var method: HTTPMethod {
        switch self {
        case .getCoinData:
            return .get
        case .getAllCurrentMetaData:
            return .get
        case .getBestCoins:
            return .get
        case .getHistoricalData:
            return .get
        }
    }
    
    //MARK: - Get parameters
    
    private var parameters: Parameters {
        switch self {
        case .getCoinData:
            return [
                "timePeriod": ["5y"]
            ]
        case .getAllCurrentMetaData:
            return [
                "uuids": [
                    "Qwsogvtv82FCd",
                    "razxDUgYGNAdQ",
                    "aKzUVe4Hh_CON",
                    "WcwrkfNI4FUAe",
                    "qzawljRxB5bYu",
                    "vSo2fu9iE1s0Y"
                ]
            ]
        case .getBestCoins:
            return [:]
        case .getHistoricalData:
            return [
                "timePeriod": [
                    "5y"
                ]
            ]
        }
    }
}

// MARK: - URLRequestConvertible

extension CryptoRouter: URLRequestConvertible {
    internal func asURLRequest() throws -> URLRequest {
        let url = self.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = self.method
        request.headers = self.headers
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(self.parameters as? [String: [String]], into: request)
        return request
    }
}
