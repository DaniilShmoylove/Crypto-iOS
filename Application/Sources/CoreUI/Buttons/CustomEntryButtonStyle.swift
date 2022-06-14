//
//  CustomEntryButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 13.06.2022.
//

import SwiftUI
import Resources
import Services

//MARK: - Body of EntryButton

public struct CustomEntryButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .semibold))
            .frame(width: 96, height: 64)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed { HapticService.impact(style: .light) }
            }
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == CustomEntryButtonStyle {
    static var entry: CustomEntryButtonStyle { CustomEntryButtonStyle() }
}

#if DEBUG
struct CustomEntryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button { } label: {
            Text("Button")
        }
        .padding()
        .background(.red)
        .buttonStyle(CustomEntryButtonStyle())
    }
}
#endif
