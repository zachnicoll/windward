//
//  ArrangerService.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import AppKit
import Carbon
import SwiftUI

enum ManagerMode {
    case selecting
    case arranging
}

struct Keybind: Identifiable {
    let id = UUID()
    let text: String
    let icon: String  // SF Symbol name
}

@Observable
class WindowManagerService {
    var mode: ManagerMode = .selecting
    var focussedWindow: CGWindowID = 0
    var selectedWindow: CGWindowID? = nil

    // Add app list property
    var availableApps: [WindowDiscoveryService.AppWindow] = []

    private let onEscape: () -> Void
    private var refreshTimer: Timer? = nil

    init(onEscape: @escaping () -> Void) {
        self.onEscape = onEscape

        // Initial load
        refreshAppList()

        // Start periodic refresh of open windows
        startPeriodicRefresh(interval: 1.0)
    }

    deinit {
        stopPeriodicRefresh()
    }

    func getWindowIndexInAppList(windowId: CGWindowID) -> Int? {
        return availableApps.firstIndex(where: { $0.windowID == windowId })
    }

    func getAppAtIndex(index: Int) -> WindowDiscoveryService.AppWindow {
        return availableApps[index]
    }

    func getAppForWindowId(_ windowId: CGWindowID) -> WindowDiscoveryService
        .AppWindow?
    {
        return availableApps.first(where: { $0.windowID == windowId })
    }

    func handleKeyEvent(_ event: NSEvent) -> NSEvent? {
        let nWindows = getNumberOfApps()
        let focussedAppIndex =
            getWindowIndexInAppList(windowId: focussedWindow) ?? 0

        if mode == .selecting {
            if event.keyCode == UInt16(kVK_RightArrow) {
                let nextAppIndex = (focussedAppIndex + 1) % nWindows
                focussedWindow = getAppAtIndex(index: nextAppIndex).windowID
                return nil
            }

            if event.keyCode == UInt16(kVK_LeftArrow) {
                let nextAppIndex = (focussedAppIndex - 1 + nWindows) % nWindows
                focussedWindow = getAppAtIndex(index: nextAppIndex).windowID
                return nil
            }

            if event.keyCode == UInt16(kVK_UpArrow) {
                let nextAppIndex =
                    (focussedAppIndex + (nWindows / 2)) % nWindows
                focussedWindow = getAppAtIndex(index: nextAppIndex).windowID
                return nil
            }

            if event.keyCode == UInt16(kVK_DownArrow) {
                let nextAppIndex =
                    (nWindows + focussedAppIndex - nWindows / 2) % nWindows
                focussedWindow = getAppAtIndex(index: nextAppIndex).windowID
                return nil
            }

            if event.keyCode == UInt16(kVK_Return) {
                selectedWindow = focussedWindow
                mode = .arranging
                return nil
            }

            if event.keyCode == UInt16(kVK_Escape) {
                self.onEscape()
                return nil
            }
        } else if mode == .arranging {
            if event.keyCode == UInt16(kVK_Escape) {
                selectedWindow = nil
                mode = .selecting
                return nil
            }
        }

        return event
    }

    func keybindsForMode() -> [Keybind] {
        switch self.mode {
        case .selecting:
            return [
                Keybind(text: "Move", icon: "arrowkeys"),
                Keybind(text: "Select", icon: "return"),
                Keybind(text: "Hide", icon: "escape"),
            ]
        case .arranging:
            return [
                Keybind(text: "Cancel", icon: "escape")
            ]
        }
    }

    func getNumberOfApps() -> Int {
        return self.availableApps.count
    }

    func startPeriodicRefresh(interval: TimeInterval) {
        refreshTimer = Timer.scheduledTimer(
            withTimeInterval: interval, repeats: true
        ) { [weak self] _ in
            self?.refreshAppList()
        }
    }

    func stopPeriodicRefresh() {
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
    }

    private func refreshAppList() {
        DispatchQueue.main.async {
            self.availableApps =
                WindowDiscoveryService.getVisibleApplicationWindows()

            let focussedWindowIndex = self.getWindowIndexInAppList(
                windowId: self.focussedWindow)

            if focussedWindowIndex == nil {
                // We've selected a window outside the bounds of our number
                // of apps, so select the last possible app
                self.focussedWindow = self.availableApps.last!.windowID
            }
        }

    }
}
