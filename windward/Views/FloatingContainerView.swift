//
//  FloatingContainerView.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import AppKit
import SwiftUI

struct FloatingContainerView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                VisualEffectView(
                    material: .menu, blendingMode: .behindWindow
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            )
    }
}
