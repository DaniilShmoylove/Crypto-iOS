//
//  NetworkClient.swift
//  
//
//  Created by Daniil Shmoylove on 04.06.2022.
//

import Foundation
import Alamofire
import SwiftUI

//MARK: - Typealias for reachability status

public typealias NetworkStatus = NetworkReachabilityManager.NetworkReachabilityStatus

@MainActor
final public class NetworkService: ObservableObject {
    private init() { }
    
    //MARK: - Singleton
    
    public static let shared = NetworkService()
    
    //MARK: - Network connection status
    
    @Published public var status: NetworkStatus = .notReachable
    
    //MARK: - Reachability manager
    
    private var reachabilityManager = NetworkReachabilityManager()
}

extension NetworkService {
    
    //MARK: - Listen to reachability
    
    public func listenToReachability() {
        reachabilityManager?.startListening { [weak self] status in
            guard let self = self else { return }
            print(status)
            switch status {
            case let .reachable(connectionType):
                self.status = .reachable(connectionType)
                print(connectionType)
            case .notReachable:
                self.status = .notReachable
                print("notReachable")
            case .unknown:
                self.status = .unknown
            }
        }
    }
}
