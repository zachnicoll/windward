//
//  WindowMapView.swift
//  windward
//
//  Created by Zachary Nicoll on 30/8/2025.
//

import SwiftUI

struct WindowMapView: View {
    let windowManagerService: WindowManagerService
    let containerSize: CGSize

    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(Color.clear)
                .frame(width: containerSize.width, height: containerSize.height)

            // Absolutely positioned windows
            ForEach(
                Array(windowManagerService.availableApps.enumerated()),
                id: \.element.processID
            ) { index, appWindow in
                WindowRectangle(
                    focussed: windowManagerService.focussedWindow
                        == appWindow.windowID,
                    selected: windowManagerService.selectedWindow
                        == appWindow.windowID,
                    appWindow: appWindow
                )
                .frame(
                    width: scaledWidth(for: appWindow),
                    height: scaledHeight(for: appWindow)
                )
                .position(scaledPosition(for: appWindow))
            }
        }
    }

    private func getScreenBounds() -> CGRect {
        // Get the bounds that encompass all windows
        guard !windowManagerService.availableApps.isEmpty else {
            return CGRect(x: 0, y: 0, width: 1920, height: 1080)  // fallback
        }

        let frames = windowManagerService.availableApps.map { $0.bounds }
        let minX = frames.map { $0.minX }.min() ?? 0
        let minY = frames.map { $0.minY }.min() ?? 0
        let maxX = frames.map { $0.maxX }.max() ?? 1920
        let maxY = frames.map { $0.maxY }.max() ?? 1080

        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    private func scaledPosition(for appWindow: WindowDiscoveryService.AppWindow)
        -> CGPoint
    {
        let screenBounds = getScreenBounds()

        // Calculate relative position within screen bounds (0-1)
        let relativeX =
            (appWindow.bounds.midX - screenBounds.minX) / screenBounds.width
        let relativeY =
            (appWindow.bounds.midY - screenBounds.minY) / screenBounds.height

        // Scale to container size
        let scaledX = relativeX * containerSize.width
        let scaledY = relativeY * containerSize.height

        return CGPoint(x: scaledX, y: scaledY)
    }

    private func scaledWidth(for appWindow: WindowDiscoveryService.AppWindow)
        -> CGFloat
    {
        let screenBounds = getScreenBounds()
        let relativeWidth = appWindow.bounds.width / screenBounds.width
        return max(relativeWidth * containerSize.width, 20)  // minimum width of 20
    }

    private func scaledHeight(for appWindow: WindowDiscoveryService.AppWindow)
        -> CGFloat
    {
        let screenBounds = getScreenBounds()
        let relativeHeight = appWindow.bounds.height / screenBounds.height
        return max(relativeHeight * containerSize.height, 15)  // minimum height of 15
    }
}
