//
//  CustomTabView.swift
//  
//
//  Created by Daniil Shmoylove on 25.04.2022.
//

import SwiftUI
import Resources

public struct BarView: View {
    
    @Binding public var currentTab: Int
    
    public var tabBarContent: [String]
    
    public init(
        currentTab: Binding<Int>,
        tabBarContent: [String]
    ) {
        self._currentTab = currentTab
        self.tabBarContent = tabBarContent
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(
                Array(
                    zip(
                        self.tabBarContent.indices,
                        self.tabBarContent
                    )
                ),
                id: \.0
            ) { index, name in
                BarItemView(
                    currentTab: self.$currentTab,
                    barItemName: name,
                    tab: index
                )
                .background(Color(UIColor.systemBackground))
                .animation(.default, value: self.currentTab)
            }
        }
    }
}

fileprivate struct BarItemView: View {
    
    //MARK: - State
    
    @Binding var currentTab: Int
    
    let barItemName: String
    let tab: Int
    
    var body: some View {
        Button {
            
            //MARK: - Move to current tab
            
            withAnimation {
                self.currentTab = tab
            }
            
        } label: {
            
            //MARK: - Button label
            
            VStack {
                Image(systemName: self.barItemName)
                    .foregroundColor(
                        self.currentTab == tab ?
                        Color.primary : Color.secondary
                    )
                    .font(.system(size: 22, weight: .heavy))
            }
            .padding(10)
            .frame(height: 36)
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color(UIColor.systemBackground))
        }
        .buttonStyle(.tabView)
    }
}
