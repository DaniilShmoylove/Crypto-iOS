//
//  RoundedCorner.swift
//  
//
//  Created by Daniil Shmoylove on 25.05.2022.
//

import SwiftUI

//MARK: - Extension modifier "cornerRadius"

extension View {
    func cornerRadius(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

//MARK: - Path fot rounded corner

private struct RoundedCorner: Shape {
    
    private var radius: CGFloat = .infinity
    private var corners: UIRectCorner = .allCorners
    
    init(
        radius: CGFloat,
        corners: UIRectCorner
    ) {
        self.radius = radius
        self.corners = corners
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
