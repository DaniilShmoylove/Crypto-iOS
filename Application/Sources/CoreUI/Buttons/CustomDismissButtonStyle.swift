//
//  CustomDismissButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 09.06.2022.
//

import SwiftUI

//MARK: - Body of TabViewButton

public struct CustomDismissButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        Image(systemName: "xmark")
            .font(.system(size: 10, weight: .heavy))
            .padding(6)
            .background(.gray.opacity(0.16))
            .clipShape(Circle())
            .foregroundColor(.gray.opacity(0.75))
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == CustomDismissButtonStyle {
    static var dismiss: CustomDismissButtonStyle { CustomDismissButtonStyle() }
}

#if DEBUG
struct CustomDismissButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button { } label: {
            Text("Button")
        }
        .padding()
        .buttonStyle(CustomDismissButtonStyle())
    }
}
#endif
