//
//  MainButtonStyle.swift
//  SportTimer
//
//  Created by Ivan Istomin on 14.07.2025.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(minWidth: 100, minHeight: 44)
            .padding(.horizontal, 16)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(
                .interpolatingSpring(stiffness: 300, damping: 15),
                value: configuration.isPressed
            )
    }
}
