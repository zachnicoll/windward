//
//  WindowManager.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import Foundation
import SwiftUI

class WindowManager: ObservableObject {
    private var mainWindow = FloatingWindowController(rootView: MainWindow())

    func showFloatingWindow() {
        mainWindow.showWindow(nil)
        mainWindow.window?.center()
    }

    func hideFloatingWindow() {
        mainWindow.close()
    }
}
