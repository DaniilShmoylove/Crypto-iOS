//
//  AppResolver.swift
//  Crypto-iOS
//
//  Created by Daniil Shmoylove on 15.06.2022.
//

import Resolver
import Services
import ApiClient

extension Resolver: ResolverRegistering {
    
    //MARK: - Register all services
    
    public static func registerAllServices() {
        self.registerAllRepositories()
        
        //MARK: - AuthenticationService
        
        register { AuthenticationServiceImpl() }
            .implements(AuthenticationService.self)
        
        //MARK: - CryptoService
        
        register { CryptoServiceImpl() }
            .implements(CryptoService.self)
        
        //MARK: - ApiClient
        
        register { ApiClient() }
            .implements(ApiClientProtocol.self)
        
        //MARK: - CryptoRepository
        
        register { CryptoRepositoryImpl() }
            .implements(CryptoRepository.self)
    }
    
    //MARK: - Register all repositories
    
    public static func registerAllRepositories() { }
}
