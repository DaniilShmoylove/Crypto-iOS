//
//  SwiftUIView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 08.02.2022.
//

import SwiftUI

struct PasswordNumberField: View {
    
    @State private var sizeOfFields: CGFloat = 0.0
    
    //MARK: - PasswordNumberField View
    var body: some View {
        VStack {
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: 4
                ),
                spacing: 16
            ) {
                
                //Number Fields
                
                ForEach(0..<4) { item in
                    Rectangle()
                        .fill(Color(UIColor.secondarySystemFill))
                        .frame(
                            width: 48,
                            height: 4
                        )
                        .scaleEffect(self.sizeOfFields)
                }
            }
            .frame(
                width: 256,
                height: 48
            )
            
            Text(LocalizedStringKey("EnterPINTitle"))
                .foregroundColor(.secondary)
                .font(.system(
                    size: 16,
                    weight: .bold,
                    design: .default)
                )
                .opacity(self.sizeOfFields)
            
            Button {
            } label: {
                Text(LocalizedStringKey("ForgotPINTitle"))
                    .foregroundColor(.secondary)
                    .font(.system(
                        size: 16,
                        weight: .bold,
                        design: .default)
                    )
                    .opacity(self.sizeOfFields)
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()){
                    self.sizeOfFields = 1.0
                }
            }
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordNumberField()
    }
}
