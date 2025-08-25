//
//  KeybindView.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI

func KeybindDisplay(keybind: Keybind) -> some View {
    HStack(spacing: 4) {
        Text(keybind.text)
            .font(.caption2)
            .foregroundColor(.primary)

        Image(systemName: keybind.icon)
            .foregroundColor(.primary)
            .font(.caption2)
            .padding(.all, 4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(4)
    }
    .frame(height: 24)
    .padding(.horizontal, 6)
}
