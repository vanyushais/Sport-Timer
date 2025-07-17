//
//  AppColors.swift
//  SportTimer
//
//  Created by Ivan Istomin on 17.07.2025.
//


import SwiftUI

enum AppColors {
    static let primary = Color(hex: "#007AFF")     // синий Apple
    static let secondary = Color(hex: "#FF9500")   // оранжевый
    static let success = Color(hex: "#34C759")     // зелёный
    static let warning = Color(hex: "#FF9500")     // оранжевый
    static let danger = Color(hex: "#FF3B30")      // красный
    static let background = Color(hex: "#F2F2F7")  // светло-серый
    static let textPrimary = Color.black
    static let textSecondary = Color(hex: "#6D6D70")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

