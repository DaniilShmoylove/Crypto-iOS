//
//  SignInWithAppleView.swift
//
//
//  Created by Daniil Shmoylove on 15.06.2022.
//

import SwiftUI
import CoreUI
import AuthenticationServices

struct SignInWithAppleButtonView: View  {
    @Environment(\.isEnabled) var isEnabled
    
    let onRequest: (ASAuthorizationAppleIDRequest) -> Void
    let onCompletion: (Result<ASAuthorization, Error>) -> Void
    let isLoading: Bool
    
    var body: some View {
        SignInWithAppleView(
            onRequest: onRequest,
            onCompletion: onCompletion
        ) {
            self.signInButtonView
        }
        .background(Color.toxicBlue)
        .cornerRadius(20)
        .padding()
        .disabled(self.isLoading)
    }

    private var signInButtonView: some View {
        HStack {
            Image(systemName: "applelogo")
            Text("Sign in with Apple")
        }
        .foregroundColor(.black)
        .font(.system(size: 16, weight: .bold))
        .frame(width: 236, height: 64)
    }
}

public struct SignInWithAppleView<Content: View>: View {
    @StateObject private var delegate: AuthorizationDelegate
    
    let content: Content
    
    public init(
        onRequest: @escaping (ASAuthorizationAppleIDRequest) -> Void,
        onCompletion: @escaping (Result<ASAuthorization, Error>) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _delegate = .init(
            wrappedValue: .init(
                onRequest: onRequest,
                onCompletion: onCompletion
            )
        )
        self.content = content()
    }
    
    public var body: some View {
        Button(action: delegate.request) { content }
    }
    
    final private class AuthorizationDelegate: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
        let onRequest: (ASAuthorizationAppleIDRequest) -> Void
        let onCompletion: (Result<ASAuthorization, Error>) -> Void
        
        func request() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            onRequest(request)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
        
        
        init(
            onRequest: @escaping ((ASAuthorizationAppleIDRequest) -> Void),
            onCompletion: @escaping ((Result<ASAuthorization, Error>) -> Void)
        ) {
            self.onRequest = onRequest
            self.onCompletion = onCompletion
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            onCompletion(.failure(error))
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            onCompletion(.success(authorization))
        }
    }
}
