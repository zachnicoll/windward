//
//  WindowManager.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import Carbon
import Foundation
import SpiceKey
import SwiftUI

class MainWindow: ObservableObject {
    private var windowController: FloatingWindowController<MainView>?
    private var previousApplication: NSRunningApplication?
    private var spiceKey: SpiceKey?

    init() {
        self.windowController = FloatingWindowController(
            rootView: MainView(onDismiss: hideFloatingWindow))

        // Show window immediately
        showFloatingWindow()

        // Register global hotkeys
        registerGlobalHotkeys()
    }
    
    deinit {
        spiceKey?.unregister()
    }

    func showFloatingWindow() {
        // Store the currently active application before showing our window
        previousApplication = NSWorkspace.shared.frontmostApplication

        windowController?.showWindow(nil)
        windowController?.window?.center()

        // Focus the floating window
        focusWindow()

        // Position the floating window
        positionWindow()
    }

    func hideFloatingWindow() {
        windowController?.close()
        restorePreviousFocus()
    }

    private func focusWindow() {
        guard let window = windowController?.window else { return }

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
        guard let window = windowController?.window,
            let screen = NSScreen.main
        else { return }

        let screenFrame = screen.visibleFrame
        let windowSize = window.frame.size

        // Center horizontally
        let x = screenFrame.midX - (windowSize.width / 2.0)

        // Position vertically from the top of the screen
        let screenHeight = screenFrame.height
        let percentageToTopOfScreen = 1.0 / 8.0

        let y =
            screenFrame.maxY - (screenHeight * percentageToTopOfScreen)
            - windowSize.height

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

    private func registerGlobalHotkeys() {
        let key = Key.return
        let modifierFlags = ModifierFlags.sftCmd
        let keyCombo = KeyCombination(key, modifierFlags)

        spiceKey = SpiceKey(
            keyCombo,
            keyDownHandler: {
                [weak self] in
                Task { @MainActor in
                    self?.showFloatingWindow()
                }
            }
        )
        spiceKey?.register()
    }

}
