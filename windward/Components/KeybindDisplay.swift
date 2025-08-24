//
//  KeybindView.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI

func KeybindDisplay(keybind: Keybind) -> some View {
    HStack(spacing: 4) {
        Image(systemName: keybind.icon)
            .foregroundColor(.secondary)
            .font(.caption)
        Text(keybind.text)
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding(.horizontal, 6)
    .padding(.vertical, 2)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(4)
}
