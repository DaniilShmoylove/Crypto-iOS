//
//  WelcomeView.swift
//  Crypto
//
//  Created by Daniil Shmoylove on 10.02.2022.
//

import SwiftUI
import SceneKit
import Resources
import Services

public struct WelcomeView: View {
    
    let getStartedAction: () -> Void
    
    @StateObject private var signInViewModel = SignInViewModel()
    @State private var isShowingWelcomeView: Bool = false
    
    public init(getStartedAction: @escaping () -> Void) {
        self.getStartedAction = getStartedAction
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                
                //Black background
                
                Color.black
                    .ignoresSafeArea()
                
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
            }
            .background(self.destination)
        }
        .preferredColorScheme(.dark)
    }
}

extension WelcomeView {
    
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
        Text(LocalizedStringKey("AppWelcomeTitle"))
            .font(.system(size: 42, weight: .heavy))
            .foregroundColor(.toxicBlue)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
    
    //Subtitle of app description
    
    private var appSubtitleView: some View {
        Text(LocalizedStringKey("AppWelcomeSubtitle"))
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
    
    //Get started navigation link to registration
    
    private var getStartedButtonView: some View {
        Button {
            self.signInViewModel.isSignInWithApple.toggle()
        } label: {
            HStack {
                Image(systemName: "applelogo")
                Text("Sign in with Apple")
            }
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 236, height: 64)
        }
        .background(Color.toxicBlue)
        .cornerRadius(20)
        .padding()
    }
    
    //Destination entry
    
    private var destination: some View {
        NavigationLink(
            "",
            isActive: self.$signInViewModel.isSignInWithApple
        ) {
            SignInView()
        }
        .labelsHidden()
    }
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView { }
            .preferredColorScheme(.light)
    }
}
#endif
