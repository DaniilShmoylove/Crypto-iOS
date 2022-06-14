//
//  NumberFieldsView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 08.02.2022.
//

import SwiftUI

struct NumberFieldsView: View {
    init(
        for value: Binding<String>,
        isShowingBiometricButton: Bool = true,
        backwardAction: @escaping () -> () = { }
    ) {
        self._value = value
        self.isShowingBiometricButton = isShowingBiometricButton
        self.backwardAction = backwardAction
    }
    
    @Binding private var value: String
    
    private let isShowingBiometricButton: Bool
    private let backwardAction: () -> ()
    
    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible()),
                count: 3
            ),
            spacing: 16
        ) {
            ForEach(1...9, id: \.self) { item in
                Button {
                    if self.value.count < 4 {
                        self.value.append(String(item))
                    }
                } label: {
                    Text(item.description)
                }
            }
            
            Button {
                
            } label: {
                Image(systemName: "faceid")
            }
            .opacity(self.isShowingBiometricButton ? 1 : 0)
            
            Button {
                if self.value.count < 4 {
                    self.value.append("0")
                }
            } label: {
                Text("0")
            }
            
            Button {
                if self.value.count > 0 {
                    self.value.removeLast()
                } else {
                    self.backwardAction()
                }
            } label: {
                Image(systemName: "delete.left")
            }
        }
        .buttonStyle(.entry)
        .tint(.primaryBlue)
        .padding([.vertical, .bottom])
    }
}


struct NumberFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberFieldsView(for: .constant(""))
    }
}
