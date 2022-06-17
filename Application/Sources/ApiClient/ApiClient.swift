//
//  ApiClient.swift
//  
//
//  Created by Daniil Shmoylove on 17.06.2022.
//

import Foundation
import Alamofire
import Combine

//MARK: - ApiClient protocol

public protocol ApiClientProtocol {
    func perform(_ urlRequest: URLRequest) -> AnyPublisher<Data, Error>
    @discardableResult
    func perform(_ urlRequest: URLRequest) async throws -> Data
    var interceptor: RequestInterceptor? { get set }
}

//MARK: - ApiClient

public class ApiClient: ApiClientProtocol {
    public init() { }
    
    public var interceptor: RequestInterceptor?
    
    public func perform(_ urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        AF.request(urlRequest, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .publishData(emptyResponseCodes: [200, 204, 205])
            .value()
            .mapError({$0 as Error})
            .eraseToAnyPublisher()
    }
    
    public func perform(_ urlRequest: URLRequest) async throws -> Data {
        let data = try await AF.request(urlRequest, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .serializingData(emptyResponseCodes: [200, 204, 205])
            .value
        return data
    }
}
