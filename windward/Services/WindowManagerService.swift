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
}
