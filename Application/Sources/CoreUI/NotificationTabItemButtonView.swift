//
//  NotificationTabItemButtonView.swift
//  
//
//  Created by Daniil Shmoylove on 17.06.2022.
//

import SwiftUI
import Resources

public struct NotificationTabItemButtonView: View {
    public init() { }
    
    public var body: some View {
        Button {
            
        } label: {
            
            //MARK: - Button label
            
            VStack {
                Image(systemName: "bell.badge")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.primaryRed, .gray)
                    .font(.system(size: 14, weight: .heavy))
                    .frame(maxWidth: .infinity)
            }
            .padding(6)
        }
        .buttonStyle(.tabView)
    }
}
