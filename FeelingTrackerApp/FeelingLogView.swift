//
//  FeelingLogView.swift
//  FeelingTrackerApp
//
//  Created by Alyanna McGrath on 4/22/23.
//

import Foundation
import SwiftUI


struct FeelingLogView: View {
    @ObservedObject var feelingData: FeelingData
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(feelingData.getPastWeekFeelings().sorted(by: { $0.date > $1.date }), id: \.date) { recordedFeeling in
                        VStack(alignment: .leading) {
                        Text(recordedFeeling.feeling.name)
                            .font(.headline)
                        Text("Time: \(dateFormatter.string(from: recordedFeeling.date))")
                            .font(.subheadline)
                        Text("Comment: \(recordedFeeling.comment)")
                            .font(.subheadline)
                            
                        
                    }
                }
            }
            .navigationBarTitle("Feeling Log")
        }
    }
}

