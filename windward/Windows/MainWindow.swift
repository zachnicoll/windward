//
//  MainWindow.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import AppKit
import SwiftUI

struct MainWindow: View {
    var body: some View {
        FloatingContainerView {
            VStack(spacing: 16) {
                Grid(
                    alignment: .center, horizontalSpacing: 12,
                    verticalSpacing: 12
                ) {
                    GridRow {
                        windowRectangle(selected: true)
                        windowRectangle()

                    }
                    GridRow {
                        windowRectangle()
                        windowRectangle()
                    }
                }

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .frame(width: WINDOW_WIDTH, height: WINDOW_HEIGHT)
        }
        .focusable()
    }

    private func windowRectangle(selected: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: 12, style: .circular)
            .stroke(
                selected ? Color.blue : Color.gray, lineWidth: selected ? 3 : 1
            )  // Border color and thickness
            .frame(width: 100, height: 100)  // Set desired size
            .background(Color.clear)  // Clear background
    }
}
