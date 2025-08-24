//
//  MainWindow.swift
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

struct MainView: View {
    @State private var mode: ManagerMode = .selecting
    @State private var focussedWindow: Int = 0
    @State private var selectedWindow: Int? = nil
    @State private var localKeyMonitor: Any?
    private var nWindows: Int = 6
    private let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    var body: some View {
        FloatingContainerView {
            VStack(spacing: 16) {
                Grid(
                    alignment: .center, horizontalSpacing: 12,
                    verticalSpacing: 12
                ) {
                    GridRow {
                        windowRectangle(
                            focussed: focussedWindow == 0,
                            selected: selectedWindow == 0)
                        windowRectangle(
                            focussed: focussedWindow == 1,
                            selected: selectedWindow == 1)
                        windowRectangle(
                            focussed: focussedWindow == 2,
                            selected: selectedWindow == 2)
                    }
                    GridRow {
                        windowRectangle(
                            focussed: focussedWindow == 3,
                            selected: selectedWindow == 3)
                        windowRectangle(
                            focussed: focussedWindow == 4,
                            selected: selectedWindow == 4)
                        windowRectangle(
                            focussed: focussedWindow == 5,
                            selected: selectedWindow == 5)
                    }
                }

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .frame(width: WINDOW_WIDTH, height: WINDOW_HEIGHT)
        }
        .onAppear {
            localKeyMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .keyDown,
                handler: self.handleKeyEvent)
        }
        .onDisappear {
            removeLocalKeyMonitors()
        }
    }

    private func handleKeyEvent(_ event: NSEvent) -> NSEvent? {
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
                self.onDismiss()
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

    private func windowRectangle(focussed: Bool = false, selected: Bool = false)
        -> some View
    {
        RoundedRectangle(cornerRadius: 12, style: .circular)
            .stroke(
                selected ? Color.green : focussed ? Color.blue : Color.gray,
                lineWidth: selected || focussed ? 3 : 1
            )
            .frame(width: 100, height: 100)  // Set desired size
            .background(Color.clear)  // Clear background
    }

    private func removeLocalKeyMonitors() {
        if let monitor = localKeyMonitor {
            NSEvent.removeMonitor(monitor)
            localKeyMonitor = nil
        }
    }
}
