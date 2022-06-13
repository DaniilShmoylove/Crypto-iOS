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
    
    @ObservedObject private var cryptoService: CryptoService
    
    @State private var selected: Int = 0
    
    private let data: Coin
    
    public init(
        data: Coin,
        cryptoService: CryptoService
    ) {
        self.data = data
        self.cryptoService = cryptoService
    }
    
    public var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(spacing: 8) {
                        self.priceStats
                        
                        ZStack {
                            if let sparkline = self.cryptoService.coinDetailData?.sparkline {
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
                        
                        SegmentPicker(
                            content: [
                                "1d", "1w", "1m", "1y", "5y"
                            ],
                            selection: self.$selected
                        )
                        .padding(.vertical)
                    }
                }
                
                Section {
                    HStack {
                        Label {
                            Text("Send")
                        } icon: {
                            Image(systemName: "arrow.uturn.right")
                        }
                            .foregroundColor(.primaryBlue)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color.primaryBlue.opacity(0.125))
                            .cornerRadius(12)
                        
                        Text("Buy \(self.data.symbol ?? "")")
                            .foregroundColor(.primaryBlue)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color.primaryBlue.opacity(0.125))
                            .cornerRadius(12)
                    }
                    .padding(.vertical, 4)
                }
                
//                if let data = self.cryptoService.coinDetailData {
//
//                    //TODO: - onAppear animation
//
//                    Section {
//                        HStack {
//                            Text("All time high")
//                            Spacer()
//                            Text(data.allTimeHigh?.price ?? "")
//                                .foregroundColor(.secondary)
//                        }
//                        .padding(.vertical, 4)
//
//                        HStack {
//                            Text("Market cap")
//                            Spacer()
//                            Text(data.marketCap ?? "")
//                                .foregroundColor(.secondary)
//                        }
//                        .padding(.vertical, 4)
//
//                        HStack {
//                            Text("24h Value")
//                            Spacer()
//                            Text(data.the24HVolume ?? "")
//                                .foregroundColor(.secondary)
//                        }
//                        .padding(.vertical, 4)
//                    }
//                    .font(.system(size: 14, weight: .bold))
//                }
                
                Section {
                    Toggle(isOn: .constant(true)) {
                        Text("News")
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
            .task {
                do {
                    
                    //MARK: - Appear fetch current meta data
                    
                    guard let uuid = self.data.uuid else { return }
                    try self.cryptoService.fetchCoinData(for: uuid)
                } catch {
                    print(error.localizedDescription)
                }
            }
            .onDisappear { self.cryptoService.coinDetailData = nil }
            .navigationBarTitleDisplayMode(.inline)
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
    private var priceStats: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current price")
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
    
    //TODO: CoreUI
    
    //    @ViewBuilder
    //    private var currentStats: some View {
    //        if let data = self.cryptoService.coinDetailData {
    //            HStack(spacing: 0) {
    //                VStack(alignment: .leading, spacing: 2) {
    //                    self.currentStatsPosition(name: "Open", value: data.allTimeHigh?.price ?? "")
    //                    self.currentStatsPosition(name: "Max", value: data.sparkline?.max() ?? "")
    //                    self.currentStatsPosition(name: "Min", value: data.sparkline?.min() ?? "")
    //                }
    //                Spacer()
    //                Divider()
    //                Spacer()
    //                VStack(alignment: .leading, spacing: 2) {
    //                    self.currentStatsPosition(name: "Cap", value: data.marketCap ?? "")
    //                    self.currentStatsPosition(name: "24h", value: data.the24HVolume ?? "")
    //                    self.currentStatsPosition(name: "Rank", value: data.rank?.description ?? "")
    //                }
    //            }
    //            .padding(.horizontal)
    //        }
    //    }
    //
    //    private func currentStatsPosition(
    //        name: String,
    //        value: String
    //    ) -> some View {
    //        HStack(spacing: 4) {
    //            Text(LocalizedStringKey(name))
    //                .foregroundColor(.secondary)
    //            Text(Double(value) ?? 0, format: .currency(code: "USD"))
    //        }
    //        .font(.system(size: 14, weight: .medium))
    //    }
    
    private var navigationPrincipal: some View {
        Text(self.data.name ?? "")
            .font(.system(size: 16, weight: .semibold))
    }
    
    private var navigationTrailing: some View {
        Button("") {
            self.presentationMode.wrappedValue.dismiss()
        }
        .buttonStyle(.dismiss)
    }
    
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
}
