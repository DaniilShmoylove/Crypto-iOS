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
import Core

public struct WalletView: View {
    
    @StateObject private var cryptoService = CryptoService()
    @StateObject private var networkService = NetworkService.shared
    
    @State private var isShowingStats: Bool = false
    public init() { }
    
    public var body: some View {
        VStack(spacing: 16) {
            
            //MARK: - User balance
            
            self.balanceHeader

            //MARK: - User coins inventory
            
            self.inventory
        }
        .onChange(of: self.networkService.status) { newValue in
            self.cryptoService.reachable(for: newValue)
        }
    }
}

extension WalletView {
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
        }
    }

    private var inventory: some View {
        List {
            if let data = self.cryptoService.allCurrentMetaData {
                ForEach(data, id: \.self) { item in
                    Button {
                        self.isShowingStats.toggle()
                    } label: {
                        CoinRowView(data: item)
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
                            cryptoService: self.cryptoService
                        )
                    }
                    .padding(.vertical, 2)
                }
            }
            Spacer(minLength: 48)
                .listSectionSeparator(.hidden)
        }
        .animation(.default, value: self.cryptoService.allCurrentMetaData?.count)
        .listStyle(.inset)
        .padding(.top)
    }
}

#if DEBUG
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
#endif
