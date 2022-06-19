//
//  CoinStatsView.swift
//  
//
//  Created by Daniil Shmoylove on 09.06.2022.
//

import SwiftUI
import Resources
import CoreUI
import SharedModel
import Services

public struct CoinDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject private var walletViewModel: WalletViewModel
    
    @State private var selected: Int = 0
    
    private let data: Coin
    
    init(
        data: Coin,
        walletViewModel: WalletViewModel
    ) {
        self.data = data
        self.walletViewModel = walletViewModel
    }
    
    public var body: some View {
        NavigationView {
            List {
                
                //MARK: - Coin summary
                
                self.coinSummary
                
                //MARK: - Coin actions
                
                self.coinActions
                
                //MARK: - Coin news
                
                self.coinNews
            }
            .navigationBarTitleDisplayMode(.inline)
            
            //MARK: - Appear fetch current meta data
            
            .task {
                do {
                    guard let uuid = self.data.uuid else { return }
                    try await self.walletViewModel.fetchCoinData(for: uuid)
                } catch {
                    print(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    self.navigationPrincipal
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    self.navigationTrailing
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    self.navigationLeading
                }
            }
        }
    }
}

extension CoinDetailView {
    
    //MARK: - Coin summary
    
    private var coinSummary: some View {
        Section {
            VStack(spacing: 8) {
                self.priceStats
                self.priceCharts
                SegmentPicker(
                    content: [
                        "1d", "1w", "1m", "1y", "5y"
                    ],
                    selection: self.$selected
                )
                .padding(.vertical)
                self.coinStats
            }
        }
    }
    
    //MARK: - Coin Stats
    
    private var coinStats: some View {
        ZStack {
            HStack {
                self.getStatsColums(
                    for: [
                        "24H": self.walletViewModel.coinDetailData?.the24HVolume ?? "",
                        "Max": String(self.walletViewModel.coinDetailData?.doubleSparkLine.max() ?? 0),
                        "Min": String(self.walletViewModel.coinDetailData?.doubleSparkLine.min() ?? 0)
                    ]
                )
                
                Divider()
                    .padding(2)
                
                self.getStatsColums(
                    for: [
                        "Cap": self.walletViewModel.coinDetailData?.marketCap ?? "",
                        "All Time": self.walletViewModel.coinDetailData?.allTimeHigh?.price ?? "",
                        "Rank": self.walletViewModel.coinDetailData?.rank?.description ?? ""
                    ]
                )
            }
            .padding(.vertical, 4)
        }
        .animation(.default, value: self.walletViewModel.coinDetailData == nil)
    }
    
    //MARK: - Coin stats colums
    
    private func getStatsColums(
        for content: [String: String]
    ) -> some View {
        VStack {
            ForEach(content.sorted(by: >), id: \.key) { title, value in
                HStack {
                    Text(LocalizedStringKey(title))
                    Spacer()
                    Text(String(format: "%.2f", Double(value) ?? 0))
                        .foregroundColor(.secondary)
                }
                .font(.system(size: 12, weight: .semibold))
                .padding(.vertical, 4)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    //MARK: - Coin actions
    
    private var coinActions: some View {
        Section {
            HStack {
                Label {
                    Text("wallet_action_send")
                } icon: {
                    Image(systemName: "arrow.uturn.right")
                }
                .foregroundColor(.primaryBlue)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Color.primaryBlue.opacity(0.125))
                .cornerRadius(12)
                
                Text("wallet_action_buy_\(self.data.symbol ?? "")")
                    .foregroundColor(.primaryBlue)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color.primaryBlue.opacity(0.125))
                    .cornerRadius(12)
            }
            .padding(.vertical, 4)
        }
    }
    
    //MARK: - Price stats
    
    private var priceStats: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("wallet_current_price_title")
                .font(.system(size: 12, weight: .medium))
            
            if let price = self.data.price {
                Text(Double(price) ?? 0, format: .currency(code: "USD"))
                    .font(.system(size: 32, weight: .bold))
            }
            
            HStack(spacing: 6) {
                if let change = self.data.change {
                    Text(change + "%")
                        .foregroundColor(Double(change) ?? 0 > 0 ? .primaryGreen2 : .primaryRed)
                }
                
                Text("1 day")
                    .foregroundColor(.secondary)
            }
            .font(.system(size: 14, weight: .semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)
    }
    
    //MARK: - Price charts
    
    private var priceCharts: some View {
        ZStack {
            if let sparkline = self.walletViewModel.coinDetailData?.sparkline {
                let sparklineData = sparkline.map { Double($0) ?? 0 }
                ChartView(
                    for: sparklineData,
                    isShowingPrice: false
                )
                .padding(.top, 24)
            } else {
                ProgressView()
            }
        }
        .frame(height: 164)
    }
    
    //MARK: - Principal tab item
    
    private var navigationPrincipal: some View {
        Text(self.data.name ?? "")
            .font(.system(size: 16, weight: .semibold))
    }
    
    //MARK: - Trailing tab item
    
    private var navigationTrailing: some View {
        Button("") {
            self.presentationMode.wrappedValue.dismiss()
        }
        .buttonStyle(.dismiss)
    }
    
    //MARK: - Leading tab item
    
    private var navigationLeading: some View {
        Image(self.data.symbol ?? "")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.black)
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .padding(6)
            .background(Color.getCoinBackgroundColor(for: self.data.symbol ?? ""))
            .clipShape(Circle())
    }
    
    //MARK: - Coin news
    
    private var coinNews: some View {
        Section {
            Toggle(isOn: .constant(true)) {
                Text("wallet_coin_news_title")
                    .font(.system(size: 14, weight: .bold))
            }
            .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("cryptonews.net")
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .font(.system(size: 10))
                
                Text("Coin Center Sues US Treasury Over Tax Reporting Rule")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("cryptonews.net")
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .font(.system(size: 10))
                
                Text("Bitcoin's Hashrate Hits an All-Time High Nearing 300 Exahash per Second")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 4)
        }
    }
}
