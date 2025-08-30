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
        self.windowManagerService = WindowManagerService(onEscape: onDismiss)
    }

    var body: some View {
        FloatingContainerView {
            VStack(spacing: 4) {
                VStack {
                    Grid(
                        alignment: .center, horizontalSpacing: 12,
                        verticalSpacing: 12
                    ) {
                        GridRow {
                            ForEach(
                                0..<windowManagerService.getNumberOfApps(), id: \.self
                            ) { index in
                                WindowRectangle(
                                    focussed: windowManagerService
                                        .focussedWindow
                                        == index,
                                    selected: windowManagerService
                                        .selectedWindow
                                        == index)
                            }
                        }
                    }
                }
                .padding(.all, 16)

                // Keybinds & mode display
                BottomMenu(
                    windowManagerService: windowManagerService)

            }
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
