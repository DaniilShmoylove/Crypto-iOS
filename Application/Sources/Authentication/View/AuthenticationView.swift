//
//  AuthenticationView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 10.02.2022.
//

import SwiftUI
import SceneKit
import Services
import AuthenticationServices
import Core

public struct AuthenticationView: View {
    
    @ObservedObject private var authenticationViewModel: AuthenticationViewModel
    @State private var isShowingWelcomeView: Bool = false
    
    @AppStorage(AppKeys.Authentication.isAuthenticated) private var isAuthenticated: Bool = false
    
    public init(viewModel: AuthenticationViewModel) {
        self.authenticationViewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                //Meta orb SceneView object
                
                self.metaOrbSceneView
                
                //Title of app name
                
                self.appTitleView
                
                //Subtitle of app description
                
                self.appSubtitleView
                
                //Get started navigation link to registration
                
                self.getStartedButtonView
                
            }
            .navigationBarHidden(true)
            
            //Offset welcome view for isShowingWelcomeView
            
            .offset(y: self.isShowingWelcomeView ? 0 : 96)
            
            //Opacity welcome view for isShowingWelcomeView
            
            .opacity(self.isShowingWelcomeView ? 1 : 0)
            
            //Showing up welcome view after 0.3s appear
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(
                        response: 0.7,
                        dampingFraction: 0.7,
                        blendDuration: 0)
                    ) {
                        self.isShowingWelcomeView = true
                    }
                }
            }
            .background(self.destination)
        }
        .preferredColorScheme(.dark)
    }
}

extension AuthenticationView {
    
    //Meta orb SceneView object
    
    private var metaOrbSceneView: some View {
        SceneView(
            scene: self.getScene(),
            options: [.autoenablesDefaultLighting]
        )
    }
    
    //SCNScene with custom background
    
    private func getScene() -> SCNScene {
        guard let scene = SCNScene(named: "metaOrb.usdz") else {
            return SCNScene()
        }
        
        //Add black background for SceneView
        
        scene.background.contents = UIColor.black
        
        return scene
    }
    
    //Title of app name
    
    private var appTitleView: some View {
        Text("authentication_welcome_title")
            .font(.system(size: 42, weight: .heavy))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
    
    //Subtitle of app description
    
    private var appSubtitleView: some View {
        Text("authentication_welcome_subtitle")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
    
    //Get started navigation link to registration
    
    private var getStartedButtonView: some View {
        Button {
            self.authenticationViewModel.signInWithGoogle()
        } label: {
            HStack {
                Image.getCoinIcon(for: "Google")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                Text("authentication_signin_with_google")
            }
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 236, height: 64)
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
        .disabled(self.authenticationViewModel.isAuthenticationLoad)
        .task {
            if !self.isAuthenticated {  self.authenticationViewModel.signOut() }
        }
    }
    
    //Destination entry
    
    private var destination: some View {
        NavigationLink(
            "",
            isActive: Binding {
                self.isAuthenticated
            } set: { _ in }
        ) {
            SignInView(viewModel: self.authenticationViewModel)
        }
        .labelsHidden()
    }
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: .init())
            .preferredColorScheme(.light)
    }
}
#endif
