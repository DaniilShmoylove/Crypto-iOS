//
//  SignInView.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import SwiftUI
import CoreUI

struct SignInView: View {
    @State private var isAppear: Bool = false
    
    @StateObject private var signInViewModel = SignInViewModel()
    
    var body: some View {
        VStack {
            if self.signInViewModel.isConfirmed {
                
                //MARK: - Confirm PIN fields
                
                self.getNumberFields(
                    text: self.signInViewModel.confirmPIN,
                    title: "Confirm PIN"
                )
                .onChange(of: self.signInViewModel.confirmPIN) { _ in
                    self.signInViewModel.checkPINs()
                }
                .transition(.slide.combined(with: .opacity))
            } else {
                
                //MARK: - Create PIN fields
                
                self.getNumberFields(
                    text: self.signInViewModel.createPIN,
                    title: "Create PIN"
                )
                .onChange(of: self.signInViewModel.createPIN) { _ in
                    self.signInViewModel.createPINChanged()
                }
                .transition(.slide.combined(with: .opacity))
            }
            Spacer()
            NumberFieldsView(
                for: self.signInViewModel.isConfirmed ?
                self.$signInViewModel.confirmPIN : self.$signInViewModel.createPIN,
                isShowingBiometricButton: false) { self.signInViewModel.isConfirmed = false }
                .offset(y: self.isAppear ? 0 : UIScreen.main.bounds.height)
        }
        .animation(.spring(), value: self.signInViewModel.isConfirmed)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.3
            ) {
                withAnimation(.spring()) {
                    self.isAppear = true
                }
            }
        }
    }
}

extension SignInView {
    
    //MARK: - Number fields
    
    private func getNumberFields(
        text: String,
        title: String
    ) -> some View {
        VStack {
            CircleFieldsView(for: text)
            
            Text(LocalizedStringKey(title))
                .opacity(self.isAppear ? 1 : 0)
            
            Text("PIN's do not match. Try it again")
                .opacity(self.signInViewModel.isPINError && self.signInViewModel.createPIN.count == 0 ? 1 : 0)
                .animation(.default, value: self.signInViewModel.isPINError && self.signInViewModel.createPIN.count == 0)
        }
        .foregroundColor(.secondary)
        .font(.system(size: 16, weight: .medium))
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
#endif
