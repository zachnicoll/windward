//
//  FloatingWindowController.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI
import AppKit

class FloatingWindowController<Content: View>: NSWindowController {
    convenience init(rootView: Content) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.borderless, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.hasShadow = true
        window.isMovableByWindowBackground = true
        window.contentView = NSHostingView(rootView: rootView)
        
        self.init(window: window)
    }
}
