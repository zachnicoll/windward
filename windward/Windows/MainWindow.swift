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
                Text("Floating Window")
                    .font(.headline)
                    .foregroundColor(.primary)

                Button("Hide") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
    }
}
