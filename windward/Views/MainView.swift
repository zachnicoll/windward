//
//  MainWindow.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import AppKit
import SwiftUI

struct MainView: View {
    @State private var windowManagerService: WindowManagerService
    @State private var localKeyMonitor: Any?

    init(onDismiss: @escaping () -> Void) {
        self.windowManagerService = WindowManagerService(
            nWindows: 6, onEscape: onDismiss)
    }

    var body: some View {
        FloatingContainerView {
            VStack(spacing: 4) {
                Grid(
                    alignment: .center, horizontalSpacing: 12,
                    verticalSpacing: 12
                ) {
                    GridRow {
                        WindowRectangle(
                            focussed: windowManagerService.focussedWindow == 0,
                            selected: windowManagerService.selectedWindow == 0)
                        WindowRectangle(
                            focussed: windowManagerService.focussedWindow == 1,
                            selected: windowManagerService.selectedWindow == 1)
                        WindowRectangle(
                            focussed: windowManagerService.focussedWindow == 2,
                            selected: windowManagerService.selectedWindow == 2)
                    }
                    GridRow {
                        WindowRectangle(
                            focussed: windowManagerService.focussedWindow == 3,
                            selected: windowManagerService.selectedWindow == 3)
                        WindowRectangle(
                            focussed: windowManagerService.focussedWindow == 4,
                            selected: windowManagerService.selectedWindow == 4)
                        WindowRectangle(
                            focussed: windowManagerService.focussedWindow == 5,
                            selected: windowManagerService.selectedWindow == 5)
                    }
                }
                .padding(.all, 16)
                .border(
                    Color.white
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()

                // Keybinds display
                HStack(spacing: 16) {
                    ForEach(
                        windowManagerService.keybindsForMode()
                    ) { keybind in
                        KeybindDisplay(keybind: keybind)
                    }

                    Spacer()

                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            localKeyMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .keyDown,
                handler: windowManagerService.handleKeyEvent)
        }
        .onDisappear {
            removeLocalKeyMonitors()
        }
    }

    private func removeLocalKeyMonitors() {
        if let monitor = localKeyMonitor {
            NSEvent.removeMonitor(monitor)
            localKeyMonitor = nil
        }
    }
}
