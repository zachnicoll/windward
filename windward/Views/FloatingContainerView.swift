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
            .padding(24)
            .frame(minWidth: 200, minHeight: 100)
            .background(
                VisualEffectView(
                    material: .hudWindow, blendingMode: .behindWindow
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            )
    }
}
