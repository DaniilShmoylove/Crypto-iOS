//
//  CustomPrimaryButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 10.06.2022.
//

import SwiftUI
import Resources

//MARK: - Body of PrimaryButton

public struct CustomPrimaryButtonStyle: ButtonStyle {
    
    private let theme: PrimaryTheme
    
    public init(theme: PrimaryTheme) {
        self.theme = theme
    }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .foregroundColor(self.theme == .light ? .black : .toxicBlue)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 236, height: 64)
            .background(self.theme == .light ? Color.toxicBlue : Color.black)
            .cornerRadius(20)
            .padding()
    }
}

//MARK: - PrimaryTheme

public enum PrimaryTheme {
    case light, dark
}

//MARK: - Typealias

public extension ButtonStyle where Self == CustomPrimaryButtonStyle {
    static func primary(theme: PrimaryTheme) -> CustomPrimaryButtonStyle {
        CustomPrimaryButtonStyle(theme: theme)
    }
}

#if DEBUG
struct CustomPrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button { } label: {
            Text("Button")
        }
        .padding()
        .background(.red)
        .buttonStyle(CustomPrimaryButtonStyle(theme: .dark))
    }
}
#endif
