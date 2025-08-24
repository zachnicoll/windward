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
    var nWindows: Int

    private let onEscape: () -> Void

    init(nWindows: Int, onEscape: @escaping () -> Void) {
        self.nWindows = nWindows
        self.onEscape = onEscape
    }

    func handleKeyEvent(_ event: NSEvent) -> NSEvent? {
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
                Keybind(text: "Select", icon: "checkmark"),
                Keybind(text: "Cancel", icon: "xmark"),
                Keybind(text: "Move", icon: "move.3d"),
            ]
        case .arranging:
            return [
                Keybind(text: "Cancel", icon: "xmark")
            ]
        }
    }
}
