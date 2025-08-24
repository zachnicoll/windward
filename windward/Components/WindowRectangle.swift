//
//  WindowRectangle.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI

func WindowRectangle(focussed: Bool = false, selected: Bool = false)
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
