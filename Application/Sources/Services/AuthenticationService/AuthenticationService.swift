//
//  AuthenticationService.swift
//  
//
//  Created by Daniil Shmoylove on 15.06.2022.
//

import AuthenticationServices
import Resolver
import Foundation
import FirebaseAuth
import CryptoKit
import GoogleSignIn
import Firebase

//MARK: - AuthenticationService protocol

public protocol AuthenticationService {
    func signWithApple(request: ASAuthorizationAppleIDRequest)
    func signWithApple(result: Result<ASAuthorization, Error>) async throws
    func signWithGoogle() async throws
    func signOut() throws
    func getCurrentUser() throws -> User?
    var isAuthenticated: Bool { get }
}

//MARK: - AuthenticationServiceImpl

final public class AuthenticationServiceImpl: AuthenticationService {
    public init() { }
    
    private var appleNonce: String?
    
    //MARK: - Sign in
    
    private func signIn(with credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
    }
    
    //MARK: - Sign out
    
    public func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - Get current user
    
    public func getCurrentUser() throws -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user
    }
    
    //MARK: - isAuthenticated
    
    public var isAuthenticated: Bool {
        Auth.auth().currentUser?.email != nil
    }
}

//MARK: - Sign in with Google

extension AuthenticationServiceImpl {
    public func signWithGoogle() async throws {
        let scenes = await UIApplication.shared.connectedScenes
        guard  let windowScene = scenes.first as? UIWindowScene, let vc = await windowScene.windows.first?.rootViewController else {
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        let user = try await GIDSignIn.sharedInstance.signIn(
            with: config,
            presenting: vc
        )
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: authentication.accessToken
        )
        
        try await self.signIn(with: credential)
    }
}

// MARK: - Sign in with Apple

extension AuthenticationServiceImpl {
    public func signWithApple(result: Result<ASAuthorization,Error>) async throws {
        switch result {
        case .failure(let error):
            throw error
        case .success(let authorization):
            if let appleIDCredential: ASAuthorizationAppleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = appleNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                
                guard let appleIDToken: Data = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                
                guard let idTokenString: String = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential: OAuthCredential = OAuthProvider
                    .credential(
                        withProviderID: "apple.com",
                        idToken: idTokenString,
                        rawNonce: nonce
                    )
                
                try await signIn(with: credential)
            }
        }
    }
    
    public func signWithApple(request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        appleNonce = nonce
        request.requestedScopes = [.email]
        request.nonce = sha256(nonce)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result: String = ""
        var remainingLength: Int = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0...16).map { _ in
                var random: UInt8 = 0
                let errorCode: Int32 = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    let randomIndex: Int = Int(random)
                    result.append(charset[randomIndex])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData: Data = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString: String = hashedData.compactMap { String(format: "%02x", $0) }
            .joined()
        
        return hashString
    }
}

extension GIDSignIn {
    @MainActor
    func signIn(with: GIDConfiguration, presenting: UIViewController) async throws -> GIDGoogleUser? {
        try await withCheckedThrowingContinuation({ continuation in
            self.signIn(with: with, presenting: presenting, callback: { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: user)
                }
            })
        })
    }
}
