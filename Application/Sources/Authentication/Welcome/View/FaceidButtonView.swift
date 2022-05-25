//
//  FaceidButtonView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 09.02.2022.
//

import SwiftUI

struct FaceidButtonView: View {
    var body: some View {
        Button {
            //tap code
        } label: {
            Image(systemName: "faceid")
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

struct FaceidButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FaceidButtonView()
            .previewLayout(.sizeThatFits)
    }
}
