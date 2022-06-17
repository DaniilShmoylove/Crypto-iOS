//
//  Application.swift
//  Crypto-iOS
//
//  Created by Daniil Shmoylove on 25.04.2022.
//

import SwiftUI
import Authentication
import CoreUI
import Wallet
import Core
import UserProfile

public struct Application: View {
    public init() { }
    
    @AppStorage(AppKeys.Application.tabviewSelection) private var currentTab: CurrentScreen = .wallet
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    
    public var body: some View {
        ZStack {
            if self.authenticationViewModel.isUnlocked {
                NavigationView {
                    VStack {
                        
                        //MARK: - TabView with page style
                        
                        TabView(selection: self.$currentTab) {
                            
                            //Wallet
                            
                            WalletView().tag(CurrentScreen.wallet)
                            
                            //Summary
                            
                            Text("View - \(1)").tag(CurrentScreen.summary)
                            
                            //User profile
                            
                            UserProfileView().tag(CurrentScreen.profile)
                                .environmentObject(self.authenticationViewModel)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                        //MARK: - TabView with buttons
                        
                        BarView(
                            currentTab: self.$currentTab,
                            tabBarContent: [
                                "bag",
                                "circle.grid.2x2.fill",
                                "person.fill"
                            ]
                        )
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        
                        //MARK: - Navigation bar leading tab item
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            NotificationTabItemButtonView()
                        }
                        
                        //MARK: - Navigation bar leading tab item
                        
                        ToolbarItem(placement: .principal) {
                            PrincipalTabItemView(for: self.currentTab)
                        }
                        
                        //MARK: - Navigation bar leading tab item
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            QRCodeTabItemButtonView()
                        }
                    }
                }
            } else {
                
                //MARK: - Auth and SignIn
                
                AuthenticationView(viewModel: self.authenticationViewModel)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.default, value: self.authenticationViewModel.isUnlocked)
    }
}
