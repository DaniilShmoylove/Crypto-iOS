//
//  NumberButtonView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 09.02.2022.
//

import SwiftUI

struct NumberButtonView: View {
    
    var number: String
    
    var body: some View {
        Button {
            
        } label: {
            Text(self.number)
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

struct NumberButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NumberButtonView(number: "0")
            .previewLayout(.sizeThatFits)
    }
}
