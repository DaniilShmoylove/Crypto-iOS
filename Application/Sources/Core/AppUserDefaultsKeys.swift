//
//  AppUserDefaultsKeys.swift
//  
//
//  Created by Daniil Shmoylove on 16.06.2022.
//

import Foundation

//MARK: - Typealias

public typealias AppKeys = AppUserDefaultsKeys

//MARK: - UserDefaults string keys

public enum AppUserDefaultsKeys {
    
    //MARK: - Base key
    
    private static func settingsKey(_ key: String) -> String { "Crypto-iOS.appSettings.\(key)" }
    
    //MARK: - Application keys
    
    public enum Application {
        public static let tabviewSelection = settingsKey("application.tabview.selection")
    }
    
    //MARK: - Authentication keys
    
    public enum Authentication {
        public static let isAuthenticated = settingsKey("authentication.authenticated.status")
        public static let PIN = settingsKey("authentication.PIN.code")
    }
    
    //MARK: - API
    
    public enum API {
        public static var key: String {
            guard let path = Bundle.main.path(forResource: "AppKeys", ofType: "plist") else { return "" }
            guard let dictionary = NSDictionary(contentsOfFile: path) else { return "" }
            guard let data = dictionary.object(forKey: "apiKey") as? String else { return "" }
            return data
        }
    }
}
