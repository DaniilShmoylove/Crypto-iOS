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

public struct Application: View {
    
    @AppStorage("current_tab") private var currentTab = 0
    
    public init() { }
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
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
                        "circle.grid.2x2.fill",
                        "magnifyingglass",
                        "person.2.fill"
                    ]
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        
                        //MARK: - Button label
                        
                        VStack {
                            Image(systemName: "bell.badge")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.primaryRed, .primary)
                                .font(.system(size: 16, weight: .heavy))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(6)
                    }
                    .buttonStyle(.tabView)
                }
            }
        }
    }
}
