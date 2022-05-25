//
//  PasswordNumberPad.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 08.02.2022.
//

import SwiftUI

struct PasswordNumberPadView: View {
    
    @State private var isShowingNumberPad: Bool = false
    
    var body: some View {
        
        //Values for number pad
        
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible()),
                count: 3
            ),
            spacing: 16
        ) {
            
            ForEach(1...9, id: \.self) {
                NumberButtonView(number: String($0))
            }
            
            FaceidButtonView()
            NumberButtonView(number: "0")
            DeleteNumberButtonView()
        }
        .padding(.vertical)
        .padding(.bottom)
        .background(.ultraThinMaterial)
        
        //Offset the number pad for isShowingNumberPad
        
        .offset(y: self.isShowingNumberPad ? 0 : UIScreen.main.bounds.height)
        
        //Showing up the number pad after 0.3s appear
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) {
                    self.isShowingNumberPad = true
                }
            }
        }
    }
}

struct PasswordNumberPad_Previews: PreviewProvider {
    static var previews: some View {
        PasswordNumberPadView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
