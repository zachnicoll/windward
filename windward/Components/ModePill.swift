//
//  ModePill.swift
//  windward
//
//  Created by Zachary Nicoll on 25/8/2025.
//

import SwiftUI

func ModePill(mode: ManagerMode) -> some View {
    Text(MODE_TEXT_MAP[mode]!)
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8).fill(MODE_COLOR_MAP[mode]!)
        )
        .animation(.easeInOut(duration: 0.1), value: mode)
}
