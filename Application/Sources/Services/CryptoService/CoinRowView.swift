//
//  CoinRowView.swift
//  
//
//  Created by Daniil Shmoylove on 09.06.2022.
//

import SwiftUI
import Resources

public struct CoinRowView: View {
    
    private let data: Coin
    
    //MARK: - isSymbol shows coin icon
    
    let isSymbol: Bool
    
    public init(data: Coin, isSymbol: Bool = true) {
        self.data = data
        self.isSymbol = isSymbol
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            if self.isSymbol {
                Image(self.data.symbol ?? "")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26)
                    .padding(10)
                    .background(Color.getCoinBackgroundColor(for: self.data.symbol ?? ""))
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(self.data.name ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                Text(self.data.symbol ?? "")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .trailing, spacing: 2) {
                Text(Double(self.data.price!)!, format: .currency(code: "USD"))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                if let change = self.data.change {
                Text(change + "%")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Double(change) ?? 0 > 0 ? .primaryGreen2 : .primaryRed)
                }
            }
        }
    }
}
