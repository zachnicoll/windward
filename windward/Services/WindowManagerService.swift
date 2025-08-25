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
    var focussedWindow: Int = 0
    var selectedWindow: Int? = nil

    // Add app list property
    var availableApps: [WindowDiscoveryService.AppWindow] = []

    private let onEscape: () -> Void
    private var refreshTimer: Timer? = nil

    init(onEscape: @escaping () -> Void) {
        self.onEscape = onEscape

        // Initial load
        refreshAppList()

        // Start periodic refresh (every 2 seconds)
        startPeriodicRefresh(interval: 2.0)
    }

    deinit {
        stopPeriodicRefresh()
    }

    func handleKeyEvent(_ event: NSEvent) -> NSEvent? {
        let nWindows = getNumberOfApps()

        if mode == .selecting {
            if event.keyCode == UInt16(kVK_RightArrow) {
                focussedWindow = (focussedWindow + 1) % nWindows
                return nil
            }

            if event.keyCode == UInt16(kVK_LeftArrow) {
                focussedWindow =
                    (focussedWindow - 1 + nWindows) % nWindows
                return nil
            }

            if event.keyCode == UInt16(kVK_UpArrow) {
                focussedWindow =
                    (focussedWindow + (nWindows / 2)) % nWindows
                return nil
            }

            if event.keyCode == UInt16(kVK_DownArrow) {
                focussedWindow =
                    (nWindows + focussedWindow - nWindows / 2) % nWindows
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

    private func startPeriodicRefresh(interval: TimeInterval) {
        refreshTimer = Timer.scheduledTimer(
            withTimeInterval: interval, repeats: true
        ) { [weak self] _ in
            self?.refreshAppList()
        }
    }

    private func stopPeriodicRefresh() {
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
    }

    private func refreshAppList() {
        self.availableApps =
            WindowDiscoveryService.getVisibleApplicationWindows()

        if focussedWindow > self.availableApps.count - 1 {
            // We've selected a window outside the bounds of our number
            // of apps, so select the last possible app
            focussedWindow = self.availableApps.count - 1
        }
    }
}
