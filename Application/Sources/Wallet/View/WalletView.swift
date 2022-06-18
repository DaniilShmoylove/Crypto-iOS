//
//  WalletView.swift
//  
//
//  Created by Daniil Shmoylove on 02.05.2022.
//

import SwiftUI
import CoreUI
import Resources
import Services

public struct WalletView: View {
    public init() { }
    
    @StateObject private var walletViewModel = WalletViewModel()
    @StateObject private var networkService = NetworkService.shared
    
    @State private var isShowingStats: Bool = false
    @State private var selectedInventory: Int = 1
    
    public var body: some View {
        
        //MARK: - User coins inventory
        
        self.content
        
            .onChange(of: self.networkService.status) {
                self.walletViewModel.reachable(for: $0)
            }
        
            .task {
                do {
                    try await self.walletViewModel.fetchAllCurrentMetaData()
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

extension WalletView {
    
    //MARK: - Balance header
    
    private var balanceHeader: some View {
        VStack(spacing: 2) {
            Text(20837.05, format: .currency(code: "USD"))
                .font(.system(size: 32, weight: .bold))
                .padding(.top)
            HStack(spacing: 4) {
                Text("+2.48%")
                Text(117, format: .currency(code: "USD"))
            }
            .foregroundColor(.primaryGreen2)
            .font(.system(size: 14, weight: .bold))
            
            self.inventoryPicker
        }
        .frame(maxWidth: .infinity)
    }
    
    //MARK: - Content
    
    private var content: some View {
        List {
            
            //MARK: - User balance
            
            self.balanceHeader
                .listSectionSeparator(.hidden, edges: .all)
            
            if let data = self.walletViewModel.allCurrentMetaData {
                ForEach(data, id: \.self) { item in
                    Button {
                        self.isShowingStats.toggle()
                    } label: {
                        CoinRowView(data: item)
                            .padding(.vertical, 6)
                    }
                    .listSectionSeparator(.hidden, edges: .top)
                    .contextMenu {
                        Label {
                            Text("Order")
                        } icon: {
                            Image(systemName: "bag.badge.plus")
                        }
                        Label {
                            Text("Swap")
                        } icon: {
                            Image(systemName: "rectangle.2.swap")
                        }
                        Label {
                            Text("Send")
                        } icon: {
                            Image(systemName: "arrow.uturn.right")
                        }
                        Label {
                            Text("To sell")
                        } icon: {
                            Image(systemName: "bag.badge.minus")
                        }
                    }
                    .sheet(isPresented: self.$isShowingStats) {
                        CoinDetailView(
                            data: item,
                            walletViewModel: self.walletViewModel 
                        )
                    }
                }
            }
        }
        .animation(.default, value: self.walletViewModel.allCurrentMetaData?.count)
        .listStyle(.inset)
    }
    
    //MARK: - Inventory picker 
    
    private var inventoryPicker: some View {
        SegmentPicker(
            content: ["wallet_portfolio_title", "wallet_favorite_title"],
            selection: self.$selectedInventory,
            segmentColor: Color(uiColor: .systemGray6)
        )
        .padding(.vertical, 22)
    }
}

#if DEBUG
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
#endif
