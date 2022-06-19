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
import SharedModel

public struct WalletView: View {
    public init() { }
    
    @StateObject private var walletViewModel = WalletViewModel()
    @StateObject private var networkService = NetworkService.shared
    
    @State private var selectedCoin: Coin? = nil
    
    public var body: some View {
        List {
            
            //MARK: - Balance title
            
            self.balanceHeader
                .listSectionSeparator(.hidden, edges: .all)
            
            //MARK: - User coins inventory
            
            if let data = self.walletViewModel.allCurrentMetaData {
                ForEach(data, id: \.id) { item in
                    Button {
                        self.selectedCoin = item
                    } label: {
                        CoinRowView(data: item)
                            .padding(.vertical, 6)
                    }
                    .listSectionSeparator(.hidden, edges: .top)
                    
                    //MARK: - Coin context menu actions
                    
                    .contextMenu {
                        CoinMenuView()
                    }
                }
            } else if self.networkService.status == .notReachable {
                Text("wallet_not_reachable_status")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .animation(.easeOut, value: self.walletViewModel.allCurrentMetaData)
        .listStyle(.inset)
        
        //MARK: - Check network reachability status
        
        .onChange(of: self.networkService.status) {
            self.walletViewModel.reachable(for: $0)
        }
        
        //MARK: - Fetch inventory data
        
        .task {
            do {
                try await self.walletViewModel.fetchAllCurrentMetaData()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //MARK: - Coin detail
        
        .sheet(item: self.$selectedCoin) { data in
            CoinDetailView(
                data: data,
                walletViewModel: self.walletViewModel
            )
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
    
    //MARK: - Inventory picker
    
    private var inventoryPicker: some View {
        SegmentPicker(
            content: ["wallet_portfolio_title", "wallet_favorite_title"],
            selection: .constant(1),
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
