//
//  WelcomeView.swift
//  
//
//  Created by Daniil Shmoylove on 25.04.2022.
//

import SwiftUI
import Resources

public struct WelcomeView: View {
    public init() { }
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .foregroundColor(color)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
