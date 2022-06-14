//
//  CoinRowView.swift
//  
//
//  Created by Daniil Shmoylove on 09.06.2022.
//

import SwiftUI
import Resources
import SharedModel

public struct CoinRowView: View {
    
    private let data: Coin
    
    let isSymbol: Bool
    
    public init(data: Coin, isSymbol: Bool = true) {
        self.data = data
        self.isSymbol = isSymbol
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            self.coinSymbol
            self.coinTitle
            self.coinStats
        }
        .font(.system(size: 14))
    }
}

extension CoinRowView {
    
    //MARK: - Coin symbol
    
    @ViewBuilder
    private var coinSymbol: some View {
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
    }
    
    //MARK: - Name & Symbol
    
    private var coinTitle: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.data.name ?? "")
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(self.data.symbol ?? "")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    //MARK: - Price & Change
    
    private var coinStats: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(Double(self.data.price!)!, format: .currency(code: "USD"))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            if let change = self.data.change {
                Text(change + "%")
                    .fontWeight(.semibold)
                    .foregroundColor(Double(change) ?? 0 > 0 ? .primaryGreen2 : .primaryRed)
            }
        }
    }
}
