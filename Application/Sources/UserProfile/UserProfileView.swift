//
//  UserProfileView.swift
//  
//
//  Created by Daniil Shmoylove on 16.06.2022.
//

import SwiftUI
import Authentication

public struct UserProfileView: View {
    public init() { }
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    @State private var isPresentedSignOutAlert: Bool = false
    
    public var body: some View {
        Form {
            Section(footer: Text("Sign out from account.")) {
                Button(role: .destructive) {
                    self.isPresentedSignOutAlert.toggle()
                } label: {
                    Text("Sign out")
                        .font(.system(size: 14, weight: .medium))
                }
                .alert(isPresented: self.$isPresentedSignOutAlert) {
                    Alert(
                        title: Text("Sign out?"),
                        primaryButton: .destructive(Text("Out")) { self.authenticationViewModel.signOut() },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}

#if DEBUG
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(AuthenticationViewModel.init())
    }
}
#endif
