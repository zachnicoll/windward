//
//  WindowRectangle.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI

func WindowRectangle(
    focussed: Bool = false, selected: Bool = false,
    appWindow: WindowDiscoveryService.AppWindow
)
    -> some View
{
    RoundedRectangle(cornerRadius: 12, style: .circular)
        .stroke(
            selected
                ? MODE_COLOR_MAP[ManagerMode.arranging]!
                : focussed
                    ? MODE_COLOR_MAP[ManagerMode.selecting]! : Color.white,
            lineWidth: (selected || focussed) ? 3 : 1
        )
        .background(Color.clear)  // Clear background
        .overlay(
            Text(appWindow.appName)
                .font(.caption2)
                .foregroundColor(.primary)
                .lineLimit(1)
        )
}
