//
//  WelcomeView.swift
//  FeelingTrackerApp
//
//  Created by Alyanna McGrath on 4/24/23.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    @State private var userName: String = ""
    @AppStorage("userName") private var storedUserName: String = ""
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome: Bool = false

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .padding(.bottom)

            TextField("Enter your name", text: $userName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if !userName.isEmpty {
                      storedUserName = userName
                      hasCompletedWelcome = true
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(userName.isEmpty)
        }
    }
}
