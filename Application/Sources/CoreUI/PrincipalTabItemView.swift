//
//  PrincipalTabItemView.swift
//  
//
//  Created by Daniil Shmoylove on 17.06.2022.
//

import SwiftUI

public struct PrincipalTabItemView: View {
    public init(
        for currentScreen: CurrentScreen
    ) {
        self.currentScreen = currentScreen
    }
    
    //MARK: - Current screen
    
    private var currentScreen: CurrentScreen
    
    //MARK: - Body title
    
    public var body: some View {
        self.getTitle
            .textCase(.uppercase)
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity)
    }
    
    //MARK: - Get title
    
    @ViewBuilder
    private var getTitle: some View {
        switch self.currentScreen {
        case .wallet:
            Text("coreui_home_title")
        case .summary:
            Text("coreui_summary_title")
        case .profile:
            Text("coreui_profile_title")
        }
    }
}
