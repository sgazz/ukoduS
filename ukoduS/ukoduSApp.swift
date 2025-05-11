//
//  ukoduSApp.swift
//  ukoduS
//
//  Created by Gazza on 11. 5. 2025..
//

import SwiftUI

@main
struct ukoduSApp: App {
    init() {
        // Postavke za Info.plist
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            let defaults: [String: Any] = [
                "CFBundleIdentifier": bundleIdentifier,
                "CFBundleVersion": "1",
                "CFBundleShortVersionString": "1.0",
                "UILaunchScreen": [:],
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]
                        ]
                    ]
                ],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                "UIRequiresFullScreen": true,
                "UIStatusBarHidden": false,
                "UIViewControllerBasedStatusBarAppearance": true
            ]
            
            UserDefaults.standard.register(defaults: defaults)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SudokuView()
                .preferredColorScheme(.light)
        }
    }
}
