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
import Resources
import Services

public struct Application: View {
    
    @AppStorage("current_tab") private var currentTab = 0
    @StateObject private var networkService = NetworkService.shared
    
    public init() { }
    
    public var body: some View {
        ZStack {
//            if true {
                self.authentication
//            } else {
//                self.application
//            }
        }
    }
}

extension Application {
    
    //MARK: - Application View
    
    private var application: some View {
        NavigationView {
            VStack {
                
                //MARK: - TabView with page style
                
                TabView(selection: self.$currentTab) {
                    WalletView().tag(0)
                    Text("View - \(1)").tag(1)
                    Text("View - \(2)").tag(2)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        
                        //MARK: - Button label
                        
                        VStack {
                            Image(systemName: "bell.badge")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    self.networkService.status == .notReachable ? .gray : Color.primaryRed,
                                    .gray
                                )
                                .font(.system(size: 14, weight: .heavy))
                                .frame(maxWidth: .infinity)
                                .scaleEffect(self.networkService.status == .notReachable ? 0.85 : 1)
                                .animation(.default, value: self.networkService.status)
                        }
                        .padding(6)
                    }
                    .buttonStyle(.tabView)
                    .disabled(self.networkService.status == .notReachable)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .font(.system(size: 18, weight: .bold))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        
                        //MARK: - Button label
                        
                        VStack {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.gray)
                                .font(.system(size: 14, weight: .heavy))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(6)
                    }
                    .buttonStyle(.tabView)
                }
            }
        }
    }
    
    //MARK: - Authentication View
    
    private var authentication: some View {
        WelcomeView { }
            .transition(.move(edge: .bottom))
    }
}
