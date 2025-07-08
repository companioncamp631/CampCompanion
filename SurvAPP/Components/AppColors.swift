//
//  AppColors.swift
//  SurvAPP
//
//  Created by D K on 07.07.2025.
//

import Foundation
import SwiftUI

//// Цвета из дизайна для удобного переиспользования
//extension Color {
//    static let appBackground = Color("appBackground")
//    static let cardBackground = Color("cardBackground")
//    static let primaryText = Color("primaryText")
//    static let secondaryText = Color("secondaryText")
//    static let accentYellow = Color("accentYellow")
//    static let buttonBorder = Color("buttonBorder")
//}

// Добавь эти цвета в свой Asset Catalog
// appBackground:  #1E193C
// cardBackground: #3A3266
// primaryText:    #FFFFFF
// secondaryText:  #B0A8DE
// accentYellow:   #FFC700
// buttonBorder:   #595091

// HelperViews.swift
import SwiftUI

// Define the color palette from your design
extension Color {
    static let primaryButton = Color(red: 80/255, green: 43/255, blue: 185/255)
    static let lightPurpleText = Color(red: 218/255, green: 211/255, blue: 232/255)
}

// Custom style for the main purple button
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.primaryButton)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Custom style for the yellow "Save" button
struct AccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .padding()
            .frame(minWidth: 150)
            .background(Color.accentYellow)
            .foregroundStyle(Color.appBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
