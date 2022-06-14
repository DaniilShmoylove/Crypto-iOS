//
//  SignInViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import Foundation
import Services

final class SignInViewModel: ObservableObject {
    init() { }
    
    @Published private(set) var isSuccessCreatedPIN: Bool = false
    @Published private(set) var isPINError: Bool = false
    @Published var createPIN: String = ""
    @Published var confirmPIN: String = ""
    @Published var isConfirmed: Bool = false
    @Published var isSignInWithApple: Bool = false
    
    //MARK: - Check PIN's match
    
    func checkPINs() {
        guard self.confirmPIN.count == 4 else { return }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            if self.createPIN == self.confirmPIN {
                //TODO: Create PIN action
                self.isSuccessCreatedPIN = true
                HapticService.notification(type: .success)
            } else {
                self.isConfirmed = false
                self.isPINError = true
                self.createPIN.removeAll()
                self.confirmPIN.removeAll()
                HapticService.notification(type: .error)
            }
        }
    }
    
    //MARK: - Change PIN's action
    
    func createPINChanged() {
        if self.createPIN.count == 4 {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.3
            ) {
                self.isConfirmed = true
            }
        }
        self.isPINError = false
    }
}
