//
//  FeelingTrackerAppApp.swift
//  FeelingTrackerApp
//
//  Created by Alyanna McGrath on 4/22/23.
//

import SwiftUI

@main
struct FeelingTrackerAppApp: App {
    @StateObject private var appColorSettings = AppColorSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appColorSettings)
        }
    }
}
