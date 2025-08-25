//
//  WindowDiscoveryService.swift
//  windward
//
//  Created by Zachary Nicoll on 25/8/2025.
//

import AppKit

class WindowDiscoveryService {
    struct AppWindow {
        let appName: String
        let bundleIdentifier: String?
        let windowTitle: String
        let windowID: CGWindowID
        let bounds: CGRect
        let processID: pid_t
    }

    static func getVisibleApplicationWindows() -> [AppWindow] {
        guard
            let windowList = CGWindowListCopyWindowInfo(
                [.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
                as? [[String: Any]]
        else {
            return []
        }

        let windwardBundleId = Bundle.main.bundleIdentifier
        let runningApps = NSWorkspace.shared.runningApplications
        let validApps = runningApps.filter { app in
            app.activationPolicy == .regular && !app.isTerminated
                && app.localizedName != nil
        }
        let appsByPID = Dictionary(
            uniqueKeysWithValues: validApps.map { ($0.processIdentifier, $0) }
        )

        return windowList.compactMap { windowDict -> AppWindow? in
            guard
                let appName = windowDict[kCGWindowOwnerName as String]
                    as? String,
                let windowID = windowDict[kCGWindowNumber as String]
                    as? CGWindowID,
                let processID = windowDict[kCGWindowOwnerPID as String]
                    as? pid_t,
                let boundsDict = windowDict[kCGWindowBounds as String]
                    as? [String: Any],
                let width = boundsDict["Width"] as? CGFloat,
                let height = boundsDict["Height"] as? CGFloat
            else {
                return nil
            }

            let windowTitle =
                windowDict[kCGWindowName as String] as? String ?? ""
            let bundleID = appsByPID[processID]?.bundleIdentifier

            // Filter out windward from the list
            if bundleID == windwardBundleId {
                return nil
            }

            // Exclude windows on the popup layer
            if let windowLayer = windowDict[kCGWindowLayer as String] as? Int {
                // Normal windows are typically on layer 0
                // Popups, alerts, tooltips are on higher layers
                guard windowLayer <= 0 else {
                    return nil
                }
            }

            let bounds = CGRect(
                x: boundsDict["X"] as? CGFloat ?? 0,
                y: boundsDict["Y"] as? CGFloat ?? 0,
                width: width,
                height: height
            )

            return AppWindow(
                appName: appName,
                bundleIdentifier: bundleID,
                windowTitle: windowTitle,
                windowID: windowID,
                bounds: bounds,
                processID: processID
            )
        }
    }
}
