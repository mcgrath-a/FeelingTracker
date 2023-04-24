//
//  AppColorSettings.swift
//  FeelingTrackerApp
//
//  Created by Alyanna McGrath on 4/23/23.
//

import Foundation

import SwiftUI
import Combine

class AppColorSettings: ObservableObject {
    @Published var primaryButtonColor: Color = .blue
    @Published var secondaryButtonColor: Color = .green
    @Published var backgroundColor: Color = .white

    // Add more colors as needed
}
