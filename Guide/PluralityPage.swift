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
    @State var artificialCount: Int // Has to be the initial number of candidates
    
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
                Stepper("Number of candidates: \(artificialCount)", value: $artificialCount, in: 1...(colorNames.count-1))
                    .onChange(of: artificialCount) { old, new in
                        if new > old {
                            election.addCandidate()
                        } else {
                            election.removeCandidate()
                        }
                        
                    }
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
