//
//  QRCodeTabItemButtonView.swift
//  
//
//  Created by Daniil Shmoylove on 17.06.2022.
//

import SwiftUI

public struct QRCodeTabItemButtonView: View {
    public init() { }
    
    public var body: some View {
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
