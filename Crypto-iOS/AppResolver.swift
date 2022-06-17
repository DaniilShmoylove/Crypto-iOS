//
//  AppResolver.swift
//  Crypto-iOS
//
//  Created by Daniil Shmoylove on 15.06.2022.
//

import Resolver
import Services

extension Resolver: ResolverRegistering {
    
    //MARK: - Register all services
    
    public static func registerAllServices() {
        self.registerAllRepositories()
        
        //MARK: - AuthenticationService
        
        register { AuthenticationServiceImpl() }
            .implements(AuthenticationService.self)
    }
    
    //MARK: - Register all repositories
    
    public static func registerAllRepositories() { }
}
