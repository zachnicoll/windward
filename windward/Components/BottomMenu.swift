//
//  KeybindView.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI

func BottomMenu(windowManagerService: WindowManagerService) -> some View {
    HStack(spacing: 4) {
        // Current mode
        ModePill(mode: windowManagerService.mode)

        Spacer()
        
        ForEach(
            windowManagerService.keybindsForMode()
        ) { keybind in
            KeybindDisplay(keybind: keybind)
        }
    }
    .padding(.all, 8)
    .overlay(
        Rectangle()
            .fill(Color.white.opacity(0.3))
            .frame(height: 1),
        alignment: .top
    )
    .background(
        VisualEffectView(
            material: .fullScreenUI, blendingMode: .withinWindow
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 12,
                bottomTrailingRadius: 12,
                topTrailingRadius: 0
            ))
    )
}
