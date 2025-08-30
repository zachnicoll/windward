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
        .background(
            VisualEffectView(
                material: .hudWindow, blendingMode: .withinWindow
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .overlay(
            VStack {
                if let icon = appWindow.icon {
                    Image(nsImage: icon) // Initialize Image with NSImage
                        .resizable() // Make it resizable
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                        .frame(width: 32, height: 32) // Set a desired size
                } else {
                    // Placeholder if no icon is available
                    Image(systemName: "app.fill") // SF Symbol as a fallback
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.gray)
                }
                
                Text(appWindow.appName)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        )
        .zIndex(focussed ? 1 : 0)
}
