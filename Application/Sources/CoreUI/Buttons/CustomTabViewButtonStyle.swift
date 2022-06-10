//
//  CustomTabViewButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 02.05.2022.
//

import SwiftUI

//MARK: - CustomTabViewButtonStyle

public struct CustomTabViewButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        TabViewButton(configuration: configuration)
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == CustomTabViewButtonStyle {
    static var tabView: CustomTabViewButtonStyle { CustomTabViewButtonStyle() }
}

private extension CustomTabViewButtonStyle {
    
    //MARK: - TabViewButton with spring animation
    
    private struct TabViewButton: View {
        let configuration: ButtonStyle.Configuration
        var body: some View {
            configuration.label
                .scaleEffect(self.configuration.isPressed ? 0.775 : 1)
                .animation(
                    .spring(
                        response: 0.45,
                        dampingFraction: 0.45,
                        blendDuration: 0),
                    value: self.configuration.isPressed
                )
        }
    }
}

#if DEBUG
struct CustomTabViewButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button { } label: {
            Text("Button")
        }
        .padding()
        .background(.red)
        .buttonStyle(CustomTabViewButtonStyle())
    }
}
#endif
