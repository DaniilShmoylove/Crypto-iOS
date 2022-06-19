//
//  SignInView.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import SwiftUI
import CoreUI
import Core

struct SignInView: View {
    
    @ObservedObject private var authenticationViewModel: AuthenticationViewModel
    @State private var isAppear: Bool = false
    
    public init(viewModel: AuthenticationViewModel) {
        self.authenticationViewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            if UserDefaults.standard.string(forKey: AppKeys.Authentication.PIN)?.count == 4 {
                
                //MARK: - Main entry
                
                VStack {
                    self.getNumberFields(
                        text: self.authenticationViewModel.createPIN,
                        title: "authentication_pin_enter"
                    )
                    .onChange(of: self.authenticationViewModel.createPIN) { _ in
                        self.authenticationViewModel.entryUnlock()
                    }
                    .transition(.slide.combined(with: .opacity))
                    .task {
                        await self.authenticationViewModel.unlockWithBiometric()
                    }
                    
                    Spacer()
                    NumberFieldsView(for: self.$authenticationViewModel.createPIN) {
                        self.authenticationViewModel.isConfirmed = false
                    } biometricAction: {
                        Task {
                            await self.authenticationViewModel.unlockWithBiometric()
                        }
                    }
                    .offset(y: self.isAppear ? 0 : UIScreen.main.bounds.height)
                }
            } else {
                VStack {
                    if self.authenticationViewModel.isConfirmed {
                        
                        //MARK: - Confirm PIN fields
                        
                        self.getNumberFields(
                            text: self.authenticationViewModel.confirmPIN,
                            title: "authentication_pin_confirm"
                        )
                        .onChange(of: self.authenticationViewModel.confirmPIN) { _ in
                            self.authenticationViewModel.checkPINs()
                        }
                        .transition(.slide.combined(with: .opacity))
                    } else {
                        
                        //MARK: - Create PIN fields
                        
                        self.getNumberFields(
                            text: self.authenticationViewModel.createPIN,
                            title: "authentication_pin_create"
                        )
                        .onChange(of: self.authenticationViewModel.createPIN) { _ in
                            self.authenticationViewModel.createPINChanged()
                        }
                        .transition(.slide.combined(with: .opacity))
                    }
                    Spacer()
                    NumberFieldsView(
                        for: self.authenticationViewModel.isConfirmed ?
                        self.$authenticationViewModel.confirmPIN : self.$authenticationViewModel.createPIN,
                        isShowingBiometricButton: false) {
                            self.authenticationViewModel.isConfirmed = false
                        } biometricAction: { }
                        .offset(y: self.isAppear ? 0 : UIScreen.main.bounds.height)
                }
            }
        }
        .animation(.spring(), value: self.authenticationViewModel.isConfirmed)
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
            
            Text("authentication_pin_error")
                .opacity(
                    self.authenticationViewModel.isPINError &&
                    self.authenticationViewModel.createPIN.count == 0 ?
                    1 : 0
                )
                .animation(
                    .default,
                    value: self.authenticationViewModel.isPINError &&
                    self.authenticationViewModel.createPIN.count == 0
                )
        }
        .foregroundColor(.secondary)
        .font(.system(size: 16, weight: .medium))
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: AuthenticationViewModel.init())
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
#endif
