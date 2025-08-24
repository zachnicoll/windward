//
//  WindowManager.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import Foundation
import SwiftUI

struct KeyMonitor {
    let keyCode: UInt16
    let handler: () -> Void
}

class WindowManager: ObservableObject {
    private var windowController = FloatingWindowController(
        rootView: MainWindow())
    private var localKeyMonitor: Any?
    private var previousApplication: NSRunningApplication?

    init() {
        // Show automatically for quick visibilty on dev changes
        showFloatingWindow()
    }

    func showFloatingWindow() {
        // Store the currently active application before showing our window
        previousApplication = NSWorkspace.shared.frontmostApplication

        windowController.showWindow(nil)
        windowController.window?.center()
        
        // Focus the floating window
        focusWindow()
        
        // Position the floating window
        positionWindow()

        // Add key monitors to react to key-press events
        let escapeKeyMonitor = KeyMonitor(
            keyCode: 53,
            handler: self.hideFloatingWindow
        )

        addLocalKeyMonitors(
            monitors: [
                escapeKeyMonitor
            ]
        )
    }

    func hideFloatingWindow() {
        windowController.close()
        removeLocalKeyMonitors()
        restorePreviousFocus()
    }

    private func focusWindow() {
        guard let window = windowController.window else { return }

        // Make the window key and bring it to front
        window.makeKeyAndOrderFront(nil)

        // Activate the application to ensure it gets focus
        NSApp.activate(ignoringOtherApps: true)

        // Additional focus enforcement
        DispatchQueue.main.async {
            window.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    private func positionWindow() {
        guard let window = windowController.window,
              let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let windowSize = window.frame.size
        
        // Center horizontally
        let x = screenFrame.midX - (windowSize.width / 2)
        
        // 1/5 from the top of the screen
        // Note: macOS coordinates start from bottom-left, so we calculate from the top
        let y = screenFrame.maxY - (screenFrame.height * 0.2) - windowSize.height
        
        window.setFrameOrigin(NSPoint(x: x, y: y))
    }

    private func restorePreviousFocus() {
        if let prevApp = previousApplication, prevApp.isFinishedLaunching {
            prevApp.activate(options: [.activateAllWindows])
        } else {
            // Fallback: activate any other application
            activateAnyOtherApplication()
        }
    }

    private func activateAnyOtherApplication() {
        let runningApps = NSWorkspace.shared.runningApplications

        // Find the first non-current application that's not a background app
        for app in runningApps {
            if app != NSRunningApplication.current
                && app.activationPolicy == .regular && app.isFinishedLaunching
            {
                app.activate(options: [.activateAllWindows])
                return
            }
        }
    }

    private func addLocalKeyMonitors(monitors: [KeyMonitor]) {
        localKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            event in
            for monitor in monitors {
                if event.keyCode == monitor.keyCode {
                    // Execute the handler asynchronously to avoid blocking
                    DispatchQueue.main.async {
                        monitor.handler()
                    }

                    // Immediately consume the event to prevent further processing
                    return nil
                }
            }

            return event
        }
    }

    private func removeLocalKeyMonitors() {
        if let monitor = localKeyMonitor {
            NSEvent.removeMonitor(monitor)
            localKeyMonitor = nil
        }
    }

    private func handleEscapeKey() {
        hideFloatingWindow()
    }

    deinit {
        removeLocalKeyMonitors()
    }
}
