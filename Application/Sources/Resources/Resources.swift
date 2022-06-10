//
//  Resources.swift
//  
//
//  Created by Daniil Shmoylove on 11.06.2022.
//

import SwiftUI

//MARK: - Color extension

extension Color {
    public static func getCoinBackgroundColor(
        for name: String
    ) -> Color {
        Color(name, bundle: .module)
    }
}

//MARK: - Image extension

extension Image {
    public static func getCoinIcon(
        for name: String
    ) -> Image {
        Image(name, bundle: .module)
    }
}


