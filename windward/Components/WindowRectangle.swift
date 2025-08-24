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
            selected ? Color.green : focussed ? Color.blue : Color.white,
            lineWidth: selected || focussed ? 3 : 1
        )
        .background(Color.clear)  // Clear background
}
