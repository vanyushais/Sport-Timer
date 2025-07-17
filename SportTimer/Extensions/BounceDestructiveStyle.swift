//
//  BounceDestructiveStyle.swift
//  SportTimer
//
//  Created by Ivan Istomin on 17.07.2025.
//

import SwiftUI

struct BounceDestructiveStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: configuration.isPressed)
    }
}
