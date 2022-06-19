//
//  CoinMenuView.swift
//  
//
//  Created by Daniil Shmoylove on 19.06.2022.
//

import Foundation
import SwiftUI

struct CoinMenuView: View {
    var body: some View {
        Section {
            Label("Order", image: "bag.badge.plus")
            Label("Swap", image: "rectangle.2.swap")
            Label("Send", image: "arrow.uturn.right")
            Label("To sell", image: "bag.badge.minus")
        }
    }
}
