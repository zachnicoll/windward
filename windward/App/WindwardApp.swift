//
//  windwardApp.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import AppKit
import SwiftUI

@main
struct WindwardApp: App {
    @StateObject private var mainWindow = MainWindow()

    init() {
        // Schedule the activation policy change for the next run loop cycle
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.accessory)
        }
    }

    var body: some Scene {
        MenuBarExtra("Windward", systemImage: "wind") {
            Button("Open Window") {
                mainWindow.showFloatingWindow()
            }
            Button("Close Window") {
                mainWindow.hideFloatingWindow()
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
