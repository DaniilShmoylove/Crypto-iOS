//
//  SignInViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import Foundation
import Services
import AuthenticationServices
import LocalAuthentication
import Resolver
import Core

final public class AuthenticationViewModel: ObservableObject {
    public init() { }
    
    @Injected private var authenticationService: AuthenticationService
    @Published private(set) var isAuthenticationLoad: Bool = false
    @Published private(set) var isPINError: Bool = false
    @Published public var isUnlocked: Bool = false
    @Published var createPIN: String = ""
    @Published var confirmPIN: String = ""
    @Published var isConfirmed: Bool = false
    
    //MARK: - Entry unlock
    
    func entryUnlock() {
        guard self.createPIN.count == 4 else { return }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            if self.createPIN == UserDefaults.standard.string(forKey: AppKeys.Authentication.PIN) {
                self.createPIN.removeAll()
                self.confirmPIN.removeAll()
                self.isUnlocked = true
                self.isPINError = false
            } else {
                self.createPIN.removeAll()
                self.confirmPIN.removeAll()
                self.isPINError = true
                HapticService.notification(type: .error)
            }
        }
    }
    
    //MARK: - Check PIN's match
    
    func checkPINs() {
        guard self.confirmPIN.count == 4 else { return }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            if self.createPIN == self.confirmPIN {
                UserDefaults.standard.set(
                    self.confirmPIN,
                    forKey: AppKeys.Authentication.PIN
                )
                self.createPIN.removeAll()
                self.confirmPIN.removeAll()
                self.isPINError = false
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
    
    //MARK: - Sign out
    
    public func signOut() {
        do {
            try self.authenticationService.signOut()
            self.isUnlocked = false
            UserDefaults.standard.set(
                nil,
                forKey: AppKeys.Authentication.PIN
            )
            UserDefaults.standard.set(
                false,
                forKey: AppKeys.Authentication.isAuthenticated
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - isAuthenticated
    
    var isAuthenticated: Bool { self.authenticationService.isAuthenticated }
}

// MARK: - Sign in with Apple

extension AuthenticationViewModel {
    @MainActor
    func create(request: ASAuthorizationAppleIDRequest) {
        self.authenticationService.signWithApple(request: request)
    }
    
    @MainActor
    func signInWithApple(result: Result<ASAuthorization, Error>) async {
        do {
            try await self.authenticationService.signWithApple(result: result)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Sign in with Google

extension AuthenticationViewModel {
    @MainActor
    func signInWithGoogle() {
        Task {
            do {
                self.isAuthenticationLoad = true
                try await self.authenticationService.signWithGoogle()
                if let _ = try self.authenticationService.getCurrentUser() {
                    UserDefaults.standard.set(
                        true,
                        forKey: AppKeys.Authentication.isAuthenticated
                    )
                }
                self.isAuthenticationLoad = false
            } catch {
                print(error.localizedDescription)
                self.isAuthenticationLoad = false
            }
        }
    }
}

//MARK: - Unlock with biometric

extension AuthenticationViewModel {
    @MainActor
    func unlockWithBiometric() async {
        do {
            let isUnlocked = try await biometricAuth()
            self.isUnlocked = isUnlocked
            self.createPIN.removeAll()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func biometricAuth() async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {
            let reason = "NSFaceIDUsageDescription"
            return try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
        } else {
            return false
        }
    }
}
