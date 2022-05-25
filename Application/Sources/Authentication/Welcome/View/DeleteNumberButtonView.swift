//
//  DeleteNumberView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 09.02.2022.
//

import SwiftUI

struct DeleteNumberButtonView: View {
    var body: some View {
        Button {

        } label: {
            Image(systemName: "delete.left")
                .font(.system(
                    size: 32,
                    weight: .bold,
                    design: .default)
                )
                .frame(
                    width: 96,
                    height: 64
                )
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .tint(.primary)
    }
}

struct DeleteNumberView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteNumberButtonView()
            .previewLayout(.sizeThatFits)
    }
}
