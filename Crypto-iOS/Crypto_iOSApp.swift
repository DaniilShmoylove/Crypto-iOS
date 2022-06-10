//
//  Crypto_iOSApp.swift
//  Crypto-iOS
//
//  Created by Daniil Shmoylove on 25.04.2022.
//

import SwiftUI
import Application
import Services

@main
struct Crypto_iOSApp: App {
    
    //MARK: - AppDelegate
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Application()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //MARK: - Network manager
    
    @ObservedObject private var networkService = NetworkService.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        //MARK: - Listen to reachability
        
        self.networkService.listenToReachability()
        return true
    }
}
