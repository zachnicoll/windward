//
//  Constants.swift
//  windward
//
//  Created by Zachary Nicoll on 24/8/2025.
//

import SwiftUI

let WINDOW_HEIGHT: CGFloat = 400
let WINDOW_WIDTH: CGFloat = WINDOW_HEIGHT * (16 / 9)

let MODE_COLOR_MAP: [ManagerMode: Color] = [
    ManagerMode.selecting: Color.blue,
    ManagerMode.arranging: Color.green,
]
let MODE_TEXT_MAP: [ManagerMode: String] = [
    ManagerMode.selecting: "Selecting",
    ManagerMode.arranging: "Arranging",
]
