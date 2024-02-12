//
//  PluralityPage.swift
//
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct PluralityPage: View {
    @EnvironmentObject var election: Election
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(
                """
                Plurality voting is the most widely used voting system. It is hard to think of something more intuitive: “Just pick the candidate you like best.”
                """
            )
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                Stepper("Number of candidates: \(election.candidateCount)", value: $election.candidateCount, in: 1...colorNames.count)
                    .padding(20)
            }
            

            
            Text(election.pluralityTally().map { "\($0.key.name): \($0.value)" }.description)

                
        }
        // .fixedSize(horizontal: false, vertical: true) // Allow for multiple lines (even when they're not filled)
        .onAppear {
            // Maybe set up the political compass
            // print("Appearing")
        }
    }
    
}
