//
//  FloatingContentView.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI
import AppKit

struct FloatingContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Floating Window")
                .font(.headline)
                .foregroundColor(.primary)
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(24)
        .frame(minWidth: 200, minHeight: 100)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        )
    }
}
