//
//  HapticService.swift
//  
//
//  Created by Daniil Shmoylove on 25.05.2022.
//

import SwiftUI

public class HapticService {
    private init() { }
    
    //MARK: - Impact style
    
    public static func impact(
        style: UIImpactFeedbackGenerator.FeedbackStyle
    ) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    //MARK: - Notification style
    
    public static func notification(
        type: UINotificationFeedbackGenerator.FeedbackType
    ) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    //MARK: - Selection style
    
    public static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
