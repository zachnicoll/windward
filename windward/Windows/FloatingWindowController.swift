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
            contentRect: NSRect(x: 0, y: 0, width: WINDOW_WIDTH, height: WINDOW_HEIGHT),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.hasShadow = true
        window.isMovableByWindowBackground = false
        
        // Inject the root view into the floating window
        window.contentView = NSHostingView(rootView: rootView)
        
        self.init(window: window)
    }
}
