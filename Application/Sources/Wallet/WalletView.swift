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
    
    @State private var isHiddenBalance: Bool = false
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 32) {
            self.balanceHeader
            self.info
            self.inventory
        }
    }
}

extension WalletView {
    private var balanceHeader: some View {
        VStack(spacing: 4) {
            Text(self.isHiddenBalance ? "Balance" : "$20.837,05")
                .font(.system(size: 40, weight: .heavy))
                .padding(.top)
                .onTapGesture(count: 5) {
                    HapticService.impact(style: .soft)
                    withAnimation {
                        self.isHiddenBalance.toggle()
                    }
                }
            HStack(spacing: 4) {
                Text(self.isHiddenBalance ? "" : "+$117")
                Text("+2.48%")
            }
            .foregroundColor(.primaryGreen2)
            .font(.system(size: 16, weight: .heavy))
        }
    }
    
    private var info: some View {
        ChartView(
            for: Array((0...75).map { CGFloat($0 + Int.random(in: 1...30)) })
        )
    }
    
    private var inventory: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Menu {
                    Text("All")
                    Text("Coins")
                    Text("NFT")
                } label: {
                    Text("All Items")
                }
                .tint(.primary)
                
                Spacer()
                
                Menu {
                    Text("Min")
                    Text("Max")
                    Text("Recently")
                    Text("Impact")
                } label: {
                    Text("Sorted by")
                }
                .tint(.secondary)
            }
            .font(.system(size: 14, weight: .bold))
            List { }
                .listStyle(.inset)
        }
        .padding()
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
