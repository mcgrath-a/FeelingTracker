//
//  SettingsView.swift
//  FeelingTrackerApp
//
//  Created by Alyanna McGrath on 4/23/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appColorSettings: AppColorSettings

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            VStack(alignment: .leading) {
                Text("Primary Button Color")
                    .font(.headline)
                ColorPicker("Choose a color", selection: $appColorSettings.primaryButtonColor)

                Text("Secondary Button Color")
                    .font(.headline)
                ColorPicker("Choose a color", selection: $appColorSettings.secondaryButtonColor)

                Text("Background Color")
                    .font(.headline)
                ColorPicker("Choose a color", selection: $appColorSettings.backgroundColor)
            }
            .padding()
        }
        .padding(.horizontal)
    }
}
