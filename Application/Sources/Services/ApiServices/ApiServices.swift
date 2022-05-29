//
//  ApiServices.swift
//  
//
//  Created by Daniil Shmoylove on 25.05.2022.
//

import Combine
import Alamofire
import Foundation

//MARK: - ApiServicesProtocol

public protocol ApiServicesProtocol {
    func perform(
        _ urlRequest: URLRequest
    ) -> AnyPublisher<Data, Error>
    
    @discardableResult
    func perform(
        _ urlRequest: URLRequest
    ) async throws -> Data
    
    var interceptor: RequestInterceptor? { get set }
}

//MARK: - ApiServices

public class ApiServices: ApiServicesProtocol {
    public init() { }
    
    public func perform(
        _ urlRequest: URLRequest
    ) -> AnyPublisher<Data, Error> {
        AF.request(urlRequest, interceptor: self.interceptor)
            .validate(statusCode: 200..<300)
            .publishData(emptyResponseCodes: [200, 204, 205])
            .value()
            .mapError({$0 as Error})
            .eraseToAnyPublisher()
    }
    
    public func perform(
        _ urlRequest: URLRequest
    ) async throws -> Data {
        let data = try await AF.request(urlRequest, interceptor: self.interceptor)
            .validate(statusCode: 200..<300)
            .response(completionHandler: { value in
                print(value.response as Any)
                print(value.request?.headers as Any)
                print(String(data: value.data ?? Data(), encoding: .utf8) as Any)
            }).serializingData(emptyResponseCodes: [200, 204, 205]).value
        return data
    }
    
    public var interceptor: RequestInterceptor?
}
