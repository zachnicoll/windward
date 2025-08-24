//
//  WindowManager.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import Foundation

class WindowManager: ObservableObject {
    private var floatingWindow = FloatingWindowController(rootView: FloatingContentView())
    
    func showFloatingWindow() {
        floatingWindow.showWindow(nil)
        floatingWindow.window?.center()
    }
    
    func hideFloatingWindow() {
        floatingWindow.close()
    }
}
